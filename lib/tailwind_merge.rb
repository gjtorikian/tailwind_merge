# frozen_string_literal: true

require "lru_redux"

require_relative "tailwind_merge/version"
require_relative "tailwind_merge/validators"
require_relative "tailwind_merge/config"
require_relative "tailwind_merge/class_group_utils"
require_relative "tailwind_merge/sort_modifiers"
require_relative "tailwind_merge/parse_class_name"

require "strscan"
require "set"

module TailwindMerge
  class Merger
    include Config
    include ParseClassName
    include SortModifiers

    def initialize(config: {})
      @config = merge_config(config)
      @config[:important_modifier] = @config[:important_modifier].to_s
      @class_utils = TailwindMerge::ClassGroupUtils.new(@config)
      @cache = LruRedux::ThreadSafeCache.new(@config[:cache_size], @config[:ignore_empty_cache])
      @postfix_lookup_class_group_ids = build_postfix_lookup_class_group_ids(@config[:postfix_lookup_class_groups])
      @order_sensitive_modifiers = Set.new(@config[:order_sensitive_modifiers]).freeze
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
      class_names = class_list.split
      return "" if class_names.empty?

      class_groups_in_conflict = Set.new

      merged_classes = []

      class_names.reverse_each do |original_class_name|
        result = parse_class_name(original_class_name, prefix: @config[:prefix])
        is_external = result.is_external
        modifiers = result.modifiers
        has_important_modifier = result.has_important_modifier
        base_class_name = result.base_class_name
        maybe_postfix_modifier_position = result.maybe_postfix_modifier_position

        if is_external
          merged_classes.push(original_class_name)
          next
        end

        has_postfix_modifier = maybe_postfix_modifier_position ? true : false

        if has_postfix_modifier
          # maybe_postfix_modifier_position is a byte offset (see ParseClassName)
          base_class_name_without_postfix = base_class_name.byteslice(0, maybe_postfix_modifier_position)
          class_group_id = @class_utils.class_group_id(base_class_name_without_postfix)

          if class_group_id && @postfix_lookup_class_group_ids[class_group_id]
            class_group_id_with_postfix = @class_utils.class_group_id(base_class_name)
            if class_group_id_with_postfix && class_group_id_with_postfix != class_group_id
              class_group_id = class_group_id_with_postfix
              has_postfix_modifier = false
            end
          end
        else
          class_group_id = @class_utils.class_group_id(base_class_name)
        end

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

        variant_modifier = sort_modifiers(modifiers, @order_sensitive_modifiers).join(":")

        modifier_id = has_important_modifier ? "#{variant_modifier}#{IMPORTANT_MODIFIER}" : variant_modifier
        has_modifier_id = !modifier_id.empty?
        # `to_s` matches the previous interpolation behavior: group ids may be
        # Symbols (custom configs) or Strings (defaults, where to_s is free)
        class_id = has_modifier_id ? "#{modifier_id}#{class_group_id}" : class_group_id.to_s

        # Tailwind class omitted due to conflict
        next if class_groups_in_conflict.include?(class_id)

        class_groups_in_conflict << class_id

        @class_utils.get_conflicting_class_group_ids(class_group_id, has_postfix_modifier).each do |conflicting_id|
          class_groups_in_conflict << (has_modifier_id ? "#{modifier_id}#{conflicting_id}" : conflicting_id.to_s)
        end

        # Tailwind class not in conflict
        merged_classes << original_class_name
      end

      merged_classes.reverse!.join(" ")
    end

    private def build_postfix_lookup_class_group_ids(class_group_ids)
      lookup = {}
      return lookup unless class_group_ids

      class_group_ids.each { |id| lookup[id] = true }
      lookup
    end
  end
end
