# frozen_string_literal: true

require "set"

module TailwindMerge
  module Validators
    class << self
      def arbitrary_value?(class_part, label, test_value)
        match = ARBITRARY_VALUE_REGEX.match(class_part)
        return false unless match

        return match[1] == label if match[1]

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
    # Shadow always begins with x and y offset separated by underscore
    SHADOW_REGEX = /^-?((\d+)?\.?(\d+)[a-z]+|0)_-?((\d+)?\.?(\d+)[a-z]+|0)/

    is_length_only = ->(value) {
      LENGTH_UNIT_REGEX.match?(value)
    }

    is_never = ->(_) { false }

    is_url = ->(value) {
      value.start_with?("url(")
    }

    is_number = ->(value) {
      numeric?(value)
    }

    is_integer_only = ->(value) {
      integer?(value)
    }

    is_shadow = ->(value) {
      SHADOW_REGEX.match?(value)
    }

    IS_LENGTH = ->(value) {
      numeric?(value) ||
        STRING_LENGTHS.include?(value) ||
        FRACTION_REGEX.match?(value) ||
        IS_ARBITRARY_LENGTH.call(value)
    }

    IS_ARBITRARY_LENGTH = ->(value) {
      arbitrary_value?(value, "length", is_length_only)
    }

    IS_ARBITRARY_SIZE = ->(value) {
      arbitrary_value?(value, "size", is_never)
    }

    IS_ARBITRARY_POSITION = ->(value) {
      arbitrary_value?(value, "position", is_never)
    }

    IS_ARBITRARY_URL = ->(value) {
      arbitrary_value?(value, "url", is_url)
    }

    IS_ARBITRARY_NUMBER = ->(value) {
      arbitrary_value?(value, "number", is_number)
    }

    IS_NUMBER = ->(value) {
      is_number.call(value)
    }

    IS_PERCENT = ->(value) {
      value.end_with?("%") && is_number.call(value[0..-2])
    }

    IS_INTEGER = ->(value) {
      is_integer_only.call(value) || arbitrary_value?(value, "number", is_integer_only)
    }

    IS_ARBITRARY_VALUE = ->(value) {
      ARBITRARY_VALUE_REGEX.match(value)
    }

    IS_ANY = ->(_) { return true }

    IS_TSHIRT_SIZE = ->(value) {
      TSHIRT_UNIT_REGEX.match?(value)
    }

    IS_ARBITRARY_SHADOW = ->(value) {
      arbitrary_value?(value, "", is_shadow)
    }
  end
end
