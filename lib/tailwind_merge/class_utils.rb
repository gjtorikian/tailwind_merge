# frozen_string_literal: true

module TailwindMerge
  class ClassUtils
    attr_reader :class_map

    CLASS_PART_SEPARATOR = "-"

    ARBITRARY_PROPERTY_REGEX = /^\[(.+)\]$/

    def initialize(config)
      @config = config
      @class_map = create_class_map(config)
    end

    def class_group_id(class_name)
      class_parts = class_name.split(CLASS_PART_SEPARATOR)

      # Classes like `-inset-1` produce an empty string as first classPart.
      # Assume that classes for negative values are used correctly and remove it from class_parts.
      class_parts.shift if class_parts.first == "" && class_parts.length != 1

      get_group_recursive(class_parts, @class_map) || get_group_id_for_arbitrary_property(class_name)
    end

    def get_group_recursive(class_parts, class_part_object)
      return class_part_object[:class_group_id] if class_parts.empty?

      current_class_part = class_parts.first

      next_class_part_object = class_part_object[:next_part][current_class_part]

      class_group_from_next_class_part = next_class_part_object ? get_group_recursive(class_parts[1..-1], next_class_part_object) : nil

      return class_group_from_next_class_part if class_group_from_next_class_part

      return if class_part_object[:validators].empty?

      class_rest = class_parts.join(CLASS_PART_SEPARATOR)

      result = class_part_object[:validators].find do |v|
        validator = v[:validator]

        if from_theme?(validator)
          validator.call(@config)
        else
          validator.call(class_rest)
        end
      end

      result.nil? ? result : result[:class_group_id]
    end

    def get_conflicting_class_group_ids(class_group_id, has_postfix_modifier)
      conflicts = @config[:conflicting_class_groups][class_group_id] || []

      if has_postfix_modifier && @config[:conflicting_class_group_modifiers][class_group_id]
        return [...conflicts, ...@config[:conflicting_class_group_modifiers][class_group_id]]
      end

      conflicts
    end

    private def create_class_map(config)
      theme = config[:theme]
      prefix = config[:prefix]
      class_map = {
        next_part: {},
        validators: [],
      }

      prefixed_class_group_entries = get_prefixed_class_group_entries(
        config[:class_groups].map { |cg| [cg[0], cg[1]] },
        prefix,
      )

      prefixed_class_group_entries.each do |(class_group_id, class_group)|
        process_classes_recursively(class_group, class_map, class_group_id, theme)
      end

      class_map
    end

    private def get_prefixed_class_group_entries(class_group_entries, prefix)
      return class_group_entries if prefix.nil?

      class_group_entries.map do |(class_group_id, class_group)|
        prefixed_class_group = class_group.map do |class_definition|
          next("#{prefix}#{class_definition}") if class_definition.is_a?(String)

          next(class_definition.transform_keys { |key| "#{prefix}#{key}" }) if class_definition.is_a?(Hash)

          class_definition
        end

        [class_group_id, prefixed_class_group]
      end
    end

    private def process_classes_recursively(class_group, class_part_object, class_group_id, theme)
      class_group.each do |class_definition|
        if class_definition.is_a?(String)
          class_part_object_to_edit = class_definition.empty? ? class_part_object : get_class_part(class_part_object, class_definition)
          class_part_object_to_edit[:class_group_id] = class_group_id
          next
        end

        if class_definition.is_a?(Proc)
          if from_theme?(class_definition)
            process_classes_recursively(
              class_definition.call(@config),
              class_part_object,
              class_group_id,
              theme,
            )
            next
          end

          class_part_object[:validators].push({
            validator: class_definition,
            class_group_id: class_group_id,
          })

          next
        end

        class_definition.each do |(key, class_group)|
          process_classes_recursively(
            class_group,
            get_class_part(class_part_object, key),
            class_group_id,
            theme,
          )
        end
      end
    end

    private def get_class_part(class_part_object, path)
      current_class_part_object = class_part_object

      path.to_s.split(CLASS_PART_SEPARATOR).each do |path_part|
        unless current_class_part_object[:next_part].key?(path_part)
          current_class_part_object[:next_part][path_part] = {
            next_part: {},
            validators: [],
          }
        end

        current_class_part_object = current_class_part_object[:next_part][path_part]
      end

      current_class_part_object
    end

    private def get_group_id_for_arbitrary_property(class_name)
      if ARBITRARY_PROPERTY_REGEX.match?(class_name)
        match = ARBITRARY_PROPERTY_REGEX.match(class_name) || ""
        arbitrary_property_class_name = match[1] || ""
        property = arbitrary_property_class_name[0...arbitrary_property_class_name.index(":")]

        if !property.nil? && !property.empty?
          # uses two dots here because one dot is used as prefix for class groups in plugins
          "arbitrary..#{property}"
        end
      end
    end

    private def from_theme?(validator)
      TailwindMerge::Config::VALID_THEME_IDS.include?(validator.object_id)
    end
  end
end
