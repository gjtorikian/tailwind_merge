# frozen_string_literal: true

module TailwindMerge
  module ModifierUtils
    IMPORTANT_MODIFIER = "!"

    def split_modifiers(class_name, separator: ":")
      separator_length = separator.length
      separator_is_single_char = (separator_length == 1)
      first_separator_char = separator[0]

      modifiers = []
      bracket_depth = 0
      modifier_start = 0
      postfix_modifier_position = nil

      class_name.each_char.with_index do |char, index|
        if bracket_depth.zero?
          if char == first_separator_char && (separator_is_single_char || class_name[index, separator_length] == separator)
            modifiers << class_name[modifier_start...index]
            modifier_start = index + separator_length
            next
          elsif char == "/"
            postfix_modifier_position = index
            next
          end
        end

        bracket_depth += 1 if char == "["
        bracket_depth -= 1 if char == "]"
      end

      base_class_name_with_important_modifier = modifiers.empty? ? class_name : class_name[modifier_start..]
      has_important_modifier = base_class_name_with_important_modifier.start_with?(IMPORTANT_MODIFIER)
      base_class_name = has_important_modifier ? base_class_name_with_important_modifier[1..] : base_class_name_with_important_modifier

      maybe_postfix_modifier_position = if postfix_modifier_position && postfix_modifier_position > modifier_start
        postfix_modifier_position - modifier_start
      end

      [modifiers, has_important_modifier, base_class_name, maybe_postfix_modifier_position]
    end

    # Sorts modifiers according to following schema:
    # - Predefined modifiers are sorted alphabetically
    # - When an arbitrary variant appears, it must be preserved which modifiers are before and after it
    def sort_modifiers(modifiers)
      return modifiers if modifiers.size <= 1

      sorted_modifiers = []
      unsorted_modifiers = []

      modifiers.each do |modifier|
        if modifier.start_with?("[")
          sorted_modifiers.concat(unsorted_modifiers.sort)
          sorted_modifiers << modifier
          unsorted_modifiers.clear
        else
          unsorted_modifiers << modifier
        end
      end

      sorted_modifiers.concat(unsorted_modifiers.sort)

      sorted_modifiers
    end
  end
end
