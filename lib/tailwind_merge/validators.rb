# frozen_string_literal: true

require "set"

module TailwindMerge
  module Validators
    class << self
      def arbitrary_value?(class_part, label, test_value)
        match = ARBITRARY_VALUE_REGEX.match(class_part)
        return false unless match

        unless match[1].nil?
          return label.is_a?(Set) ? label.include?(match[1]) : label == match[1]
        end

        test_value.call(match[2])
      end

      def numeric?(x)
        Float(x, exception: false).is_a?(Numeric)
      end

      def integer?(x)
        Integer(x, exception: false).is_a?(Integer)
      end
    end

    STRING_LENGTHS = Set.new(["px", "full", "screen"]).freeze

    ARBITRARY_VALUE_REGEX = /^\[(?:([a-z-]+):)?(.+)\]$/i
    FRACTION_REGEX = %r{^\d+/\d+$}
    LENGTH_UNIT_REGEX = /\d+(%|px|r?em|[sdl]?v([hwib]|min|max)|pt|pc|in|cm|mm|cap|ch|ex|r?lh|cq(w|h|i|b|min|max))|\b(calc|min|max|clamp)\(.+\)|^0$/
    TSHIRT_UNIT_REGEX = /^(\d+(\.\d+)?)?(xs|sm|md|lg|xl)$/
    COLOR_FUNCTION_REGEX = /^(rgba?|hsla?|hwb|(ok)?(lab|lch))\(.+\)$/
    # Shadow always begins with x and y offset separated by underscore optionally prepended by inset
    SHADOW_REGEX = /^(inset_)?-?((\d+)?\.?(\d+)[a-z]+|0)_-?((\d+)?\.?(\d+)[a-z]+|0)/
    IMAGE_REGEX = /^(url|image|image-set|cross-fade|element|(repeating-)?(linear|radial|conic)-gradient)\(.+\)$/

    SIZE_LABELS = Set.new(["length", "size", "percentage"]).freeze
    IMAGE_LABELS = Set.new(["image", "url"]).freeze

    is_length_only = ->(value) {
      # `colorFunctionRegex` check is necessary because color functions can have percentages in them which which would be incorrectly classified as lengths.
      # For example, `hsl(0 0% 0%)` would be classified as a length without this check.
      # I could also use lookbehind assertion in `lengthUnitRegex` but that isn't supported widely enough.
      LENGTH_UNIT_REGEX.match?(value) && !COLOR_FUNCTION_REGEX.match?(value)
    }

    is_never = ->(_) { false }

    is_number = ->(value) {
      numeric?(value)
    }

    is_integer_only = ->(value) {
      integer?(value)
    }

    is_shadow = ->(value) {
      SHADOW_REGEX.match?(value)
    }

    is_image = ->(value) {
      IMAGE_REGEX.match?(value)
    }

    IS_LENGTH = ->(value) {
      numeric?(value) ||
        STRING_LENGTHS.include?(value) ||
        FRACTION_REGEX.match?(value)
    }

    IS_ARBITRARY_LENGTH = ->(value) {
      arbitrary_value?(value, "length", is_length_only)
    }

    IS_ARBITRARY_NUMBER = ->(value) {
      arbitrary_value?(value, "number", is_number)
    }

    IS_NUMBER = ->(value) {
      is_number.call(value)
    }

    IS_INTEGER = ->(value) {
      is_integer_only.call(value)
    }

    IS_PERCENT = ->(value) {
      value.end_with?("%") && is_number.call(value[0..-2])
    }

    IS_ARBITRARY_VALUE = ->(value) {
      ARBITRARY_VALUE_REGEX.match(value)
    }

    IS_TSHIRT_SIZE = ->(value) {
      TSHIRT_UNIT_REGEX.match?(value)
    }

    IS_ARBITRARY_SIZE = ->(value) {
      arbitrary_value?(value, SIZE_LABELS, is_never)
    }

    IS_ARBITRARY_POSITION = ->(value) {
      arbitrary_value?(value, "position", is_never)
    }

    IS_ARBITRARY_IMAGE = ->(value) {
      arbitrary_value?(value, IMAGE_LABELS, is_image)
    }

    IS_ARBITRARY_SHADOW = ->(value) {
      arbitrary_value?(value, "", is_shadow)
    }

    IS_ANY = ->(_) { true }
  end
end
