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
require_relative "tailwind_merge/modifier_utils"

require "strscan"
require "set"

module TailwindMerge
  class Merger
    include Config
    include ModifierUtils

    SPLIT_CLASSES_REGEX = /\s+/

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
        modifiers, has_important_modifier, base_class_name = split_modifiers(original_class_name, separator: @config[:separator])

        class_group_id = @class_utils.class_group_id(base_class_name)

        unless class_group_id
          next {
            is_tailwind_class: false,
            original_class_name: original_class_name,
          }
        end

        variant_modifier = sort_modifiers(modifiers).join(":")

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
  end
end
