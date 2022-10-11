# frozen_string_literal: true

if ENV.fetch("DEBUG", false)
  require "amazing_print"
  require "debug"
end

require "lru_redux"

require_relative "tailwind_merge/version"
require_relative "tailwind_merge/validators"
require_relative "tailwind_merge/config"
require_relative "tailwind_merge/class_utils"

require "strscan"
require "set"

module TailwindMerge
  class Merger
    include Config

    SPLIT_CLASSES_REGEX = /\s+/
    IMPORTANT_MODIFIER = "!"

    def initialize(config: {})
      @config = if config.fetch(:theme, nil)
        merge_configs(config)
      else
        TailwindMerge::Config::DEFAULTS.merge(config)
      end

      @class_utils = TailwindMerge::ClassUtils.new(@config)
      @cache = LruRedux::Cache.new(@config[:cache_size])
    end

    def merge(classes)
      @cache.getset(classes) do
        merge_class_list(classes)
      end
    end

    private def merge_class_list(classes)
      # Set of class_group_ids in following format:
      # `{importantModifier}{variantModifiers}{classGroupId}`
      # @example 'float'
      # @example 'hover:focus:bg-color'
      # @example 'md:!pr'
      class_groups_in_conflict = Set.new

      classes.strip.split(SPLIT_CLASSES_REGEX).map do |original_class_name|
        modifiers, has_important_modifier, base_class_name = split_modifiers(original_class_name)

        class_group_id = @class_utils.class_group_id(base_class_name)

        unless class_group_id
          next {
            is_tailwind_class: false,
            original_class_name: original_class_name,
          }
        end

        variant_modifier = sort_modifiers(modifiers).join("")

        modifier_id = has_important_modifier ? "#{variant_modifier}#{IMPORTANT_MODIFIER}" : variant_modifier

        {
          is_tailwind_class: true,
          modifier_id: modifier_id,
          class_group_id: class_group_id,
          original_class_name: original_class_name,
        }
      end.reverse # Last class in conflict wins, so filter conflicting classes in reverse order.
        .select do |parsed|
        next(true) unless parsed[:is_tailwind_class]

        modifier_id = parsed[:modifier_id]
        class_group_id = parsed[:class_group_id]

        class_id = "#{modifier_id}#{class_group_id}"

        next if class_groups_in_conflict.include?(class_id)

        class_groups_in_conflict.add(class_id)

        @class_utils.get_conflicting_class_group_ids(class_group_id).each do |group|
          class_groups_in_conflict.add("#{modifier_id}#{group}")
        end

        true
      end.reverse.map { |parsed| parsed[:original_class_name] }.join(" ")
    end

    SPLIT_MODIFIER_REGEX = /[:\[\]]/
    private def split_modifiers(class_name)
      modifiers = []

      bracket_depth = 0
      modifier_start = 0

      ss = StringScanner.new(class_name)

      until ss.eos?
        portion = ss.scan_until(SPLIT_MODIFIER_REGEX)

        if portion.nil?
          ss.terminate
          next
        end
        pos = ss.pos - 1
        if class_name[pos] == ":" && bracket_depth.zero?
          next_modifier_start = pos
          modifiers << class_name[modifier_start..next_modifier_start]
          modifier_start = next_modifier_start + 1
        elsif class_name[pos] == "["
          bracket_depth += 1
        elsif class_name[pos] == "]"
          bracket_depth -= 1
        end
      end

      base_class_name_with_important_modifier = modifiers.empty? ? class_name : class_name[modifier_start..-1]
      has_important_modifier = base_class_name_with_important_modifier.start_with?(IMPORTANT_MODIFIER)
      base_class_name = has_important_modifier ? base_class_name_with_important_modifier[1..-1] : base_class_name_with_important_modifier

      [modifiers, has_important_modifier, base_class_name]
    end

    # Sorts modifiers according to following schema:
    # - Predefined modifiers are sorted alphabetically
    # - When an arbitrary variant appears, it must be preserved which modifiers are before and after it
    private def sort_modifiers(modifiers)
      if modifiers.length <= 1
        return modifiers
      end

      sorted_modifiers = []
      unsorted_modifiers = []

      modifiers.each do |modifier|
        is_arbitrary_variant = modifier[0] == "["

        if is_arbitrary_variant
          sorted_modifiers.push(unsorted_modifiers.sort, modifier)
          unsorted_modifiers = []
        else
          unsorted_modifiers.push(modifier)
        end
      end

      sorted_modifiers.push(...unsorted_modifiers.sort)

      sorted_modifiers
    end
  end
end
