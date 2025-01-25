# frozen_string_literal: true

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
      @config = if config.key?(:theme)
        merge_configs(config)
      else
        TailwindMerge::Config::DEFAULTS.merge(config)
      end

      @class_utils = TailwindMerge::ClassUtils.new(@config)
      @cache = LruRedux::Cache.new(@config[:cache_size], @config[:ignore_empty_cache])
    end

    def merge(classes)
      normalized = classes.is_a?(Array) ? classes.compact.join(" ") : classes.to_s

      @cache.getset(normalized) do
        merge_class_list(normalized).freeze
      end
    end

    private def merge_class_list(class_list)
      # Set of class_group_ids in following format:
      # `{importantModifier}{variantModifiers}{classGroupId}`
      # @example 'float'
      # @example 'hover:focus:bg-color'
      # @example 'md:!pr'
      trimmed = class_list.strip
      return "" if trimmed.empty?

      class_groups_in_conflict = Set.new

      merged_classes = []

      trimmed.split(SPLIT_CLASSES_REGEX).reverse_each do |original_class_name|
        modifiers, has_important_modifier, base_class_name, maybe_postfix_modifier_position =
          split_modifiers(original_class_name, separator: @config[:separator])

        actual_base_class_name = if maybe_postfix_modifier_position
          base_class_name[0...maybe_postfix_modifier_position]
        else
          base_class_name
        end

        has_postfix_modifier = maybe_postfix_modifier_position ? true : false
        class_group_id = @class_utils.class_group_id(actual_base_class_name)

        unless class_group_id
          unless has_postfix_modifier
            # Not a Tailwind class
            merged_classes << original_class_name
            next
          end

          class_group_id = @class_utils.class_group_id(base_class_name)

          unless class_group_id
            # Not a Tailwind class
            merged_classes << original_class_name
            next
          end

          has_postfix_modifier = false
        end

        variant_modifier = sort_modifiers(modifiers).join(":")

        modifier_id = has_important_modifier ? "#{variant_modifier}#{IMPORTANT_MODIFIER}" : variant_modifier
        class_id = "#{modifier_id}#{class_group_id}"

        # Tailwind class omitted due to conflict
        next if class_groups_in_conflict.include?(class_id)

        class_groups_in_conflict << class_id

        @class_utils.get_conflicting_class_group_ids(class_group_id, has_postfix_modifier).each do |conflicting_id|
          class_groups_in_conflict << "#{modifier_id}#{conflicting_id}"
        end

        # Tailwind class not in conflict
        merged_classes << original_class_name
      end

      merged_classes.reverse.join(" ")
    end
  end
end
