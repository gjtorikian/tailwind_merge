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
      @config = if config.fetch(:theme, nil)
        merge_configs(config)
      else
        TailwindMerge::Config::DEFAULTS.merge(config)
      end

      @class_utils = TailwindMerge::ClassUtils.new(@config)
      @cache = LruRedux::Cache.new(@config[:cache_size])
    end

    def merge(classes)
      if classes.is_a?(Array)
        classes = classes.compact.join(" ")
      end

      @cache.getset(classes) do
        merge_class_list(classes)
      end
    end

    private def merge_class_list(class_list)
      # Set of class_group_ids in following format:
      # `{importantModifier}{variantModifiers}{classGroupId}`
      # @example 'float'
      # @example 'hover:focus:bg-color'
      # @example 'md:!pr'
      class_groups_in_conflict = []
      class_names = class_list.strip.split(SPLIT_CLASSES_REGEX)

      result = ""

      i = class_names.length - 1

      loop do
        break if i < 0

        original_class_name = class_names[i]

        modifiers, has_important_modifier, base_class_name, maybe_postfix_modifier_position = split_modifiers(original_class_name, separator: @config[:separator])

        actual_base_class_name = maybe_postfix_modifier_position ? base_class_name[0...maybe_postfix_modifier_position] : base_class_name
        class_group_id = @class_utils.class_group_id(actual_base_class_name)

        unless class_group_id
          unless maybe_postfix_modifier_position
            # not a Tailwind class
            result = original_class_name + (!result.empty? ? " " + result : result)
            i -= 1
            next
          end

          class_group_id = @class_utils.class_group_id(base_class_name)

          unless class_group_id
            # not a Tailwind class
            result = original_class_name + (!result.empty? ? " " + result : result)
            i -= 1
            next
          end

          has_postfix_modifier = false
        end

        variant_modifier = sort_modifiers(modifiers).join(":")

        modifier_id = has_important_modifier ? "#{variant_modifier}#{IMPORTANT_MODIFIER}" : variant_modifier
        class_id = "#{modifier_id}#{class_group_id}"

        # Tailwind class omitted due to pre-existing conflict
        if class_groups_in_conflict.include?(class_id)
          i -= 1
          next
        end

        class_groups_in_conflict.push(class_id)

        @class_utils.get_conflicting_class_group_ids(class_group_id, has_postfix_modifier).each do |group|
          class_groups_in_conflict.push("#{modifier_id}#{group}")
        end

        # no conflict!
        result = original_class_name + (!result.empty? ? " " + result : result)

        i -= 1
      end

      result
    end
  end
end
