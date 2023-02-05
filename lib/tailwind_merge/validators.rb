# frozen_string_literal: true

require "set"

module TailwindMerge
  module Validators
    class << self
      def arbitrary_value?(class_part, label, test_value)
        match = ARBITRARY_VALUE_REGEX.match(class_part)
        return false unless match

        return match[1] === label if match[1]

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
    LENGTH_UNIT_REGEX = /\d+(%|px|r?em|[sdl]?v([hwib]|min|max)|pt|pc|in|cm|mm|cap|ch|ex|r?lh)/
    TSHIRT_UNIT_REGEX = /^(\d+(\.\d+)?)?(xs|sm|md|lg|xl)$/
    # Shadow always begins with x and y offset separated by underscore
    SHADOW_REGEX = /^-?((\d+)?\.?(\d+)[a-z]+|0)_-?((\d+)?\.?(\d+)[a-z]+|0)/

    value_length = ->(value) {
      LENGTH_UNIT_REGEX.match?(value)
    }

    value_never = ->(_) { false }

    value_url = ->(value) {
      value.start_with?("url(")
    }

    value_number = ->(value) {
      numeric?(value)
    }

    value_integer = ->(value) {
      integer?(value)
    }

    value_shadow = ->(value) {
      SHADOW_REGEX.match?(value)
    }

    IS_LENGTH = ->(class_part) {
      numeric?(class_part) || \
        STRING_LENGTHS.include?(class_part) || \
        FRACTION_REGEX.match?(class_part) || \
        IS_ARBITRARY_LENGTH.call(class_part)
    }

    IS_ARBITRARY_LENGTH = ->(class_part) {
      arbitrary_value?(class_part, "length", value_length)
    }

    IS_ARBITRARY_SIZE = ->(class_part) {
      arbitrary_value?(class_part, "size", value_never)
    }

    IS_ARBITRARY_POSITION = ->(class_part) {
      arbitrary_value?(class_part, "position", value_never)
    }

    IS_ARBITRARY_URL = ->(class_part) {
      arbitrary_value?(class_part, "url", value_url)
    }

    IS_ARBITRARY_NUMBER = ->(class_part) {
      arbitrary_value?(class_part, "number", value_number)
    }

    IS_INTEGER = ->(class_part) {
      integer?(class_part) || arbitrary_value?(class_part, "number", value_integer)
    }

    IS_ARBITRARY_VALUE = ->(class_part) {
      ARBITRARY_VALUE_REGEX.match(class_part)
    }

    IS_ANY = ->(_) { return true }

    IS_TSHIRT_SIZE = ->(class_part) {
      TSHIRT_UNIT_REGEX.match?(class_part)
    }

    IS_ARBITRARY_SHADOW = ->(class_part) {
      arbitrary_value?(class_part, "", value_shadow)
    }
  end
end
