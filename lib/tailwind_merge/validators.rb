# frozen_string_literal: true

require "set"

module TailwindMerge
  module Validators
    class << self
      def numeric?(x)
        Float(x, exception: false).is_a?(Numeric)
      end

      def integer?(x)
        Integer(x, exception: false).is_a?(Integer)
      end
    end

    STRING_LENGTHS = Set.new(["px", "full", "screen"]).freeze

    ARBITRARY_VALUE_REGEX = /^\[(.+)\]$/
    FRACTION_REGEX = %r{^\d+/\d+$}
    LENGTH_UNIT_REGEX = /\d+(%|px|r?em|[sdl]?v([hwib]|min|max)|pt|pc|in|cm|mm|cap|ch|ex|r?lh)/
    TSHIRT_UNIT_REGEX = /^(\d+(\.\d+)?)?(xs|sm|md|lg|xl)$/
    # Shadow always begins with x and y offset separated by underscore
    SHADOW_REGEX = /^-?((\d+)?\.?(\d+)[a-z]+|0)_-?((\d+)?\.?(\d+)[a-z]+|0)/

    IS_ANY = ->(_) { return true }

    IS_LENGTH = ->(class_part) {
      numeric?(class_part) || \
        STRING_LENGTHS.include?(class_part) || \
        FRACTION_REGEX.match?(class_part) || \
        IS_ARBITRARY_LENGTH.call(class_part)
    }

    IS_ARBITRARY_LENGTH = ->(class_part) {
      if (match = ARBITRARY_VALUE_REGEX.match(class_part))
        return match[1].start_with?("length:") || LENGTH_UNIT_REGEX.match?(class_part)
      end

      false
    }

    IS_ARBITRARY_SIZE = ->(class_part) {
      if (match = ARBITRARY_VALUE_REGEX.match(class_part))
        return match[1].start_with?("size:")
      end

      false
    }

    IS_ARBITRARY_POSITION = ->(class_part) {
      if (match = ARBITRARY_VALUE_REGEX.match(class_part))
        return match[1].start_with?("position:")
      end

      false
    }

    IS_ARBITRARY_VALUE = ->(class_part) {
      ARBITRARY_VALUE_REGEX.match(class_part)
    }

    IS_ARBITRARY_URL = ->(class_part) {
      if (match = ARBITRARY_VALUE_REGEX.match(class_part))
        return match[1].start_with?("url(", "url:")
      end

      false
    }

    IS_ARBITRARY_NUMBER = ->(class_part) {
      if (match = ARBITRARY_VALUE_REGEX.match(class_part))
        return match[1].start_with?("number:") || numeric?(match[1])
      end

      false
    }

    IS_TSHIRT_SIZE = ->(class_part) {
      TSHIRT_UNIT_REGEX.match?(class_part)
    }

    IS_INTEGER = ->(class_part) {
      if (match = ARBITRARY_VALUE_REGEX.match(class_part))
        return integer?(match[1])
      end

      integer?(class_part)
    }

    IS_ARBITRARY_SHADOW = ->(class_part) {
      if (match = ARBITRARY_VALUE_REGEX.match(class_part))
        return SHADOW_REGEX.match?(match[1])
      end

      return false
    }
  end
end
