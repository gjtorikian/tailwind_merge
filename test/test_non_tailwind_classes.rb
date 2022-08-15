# frozen_string_literal: true

require "test_helper"

class TestNonTailwindClasses < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_does_not_alter_non_tailwind_classes
    assert_equal("non-tailwind-class block", @merger.merge("non-tailwind-class inline block"))
    assert_equal("block inline-1", @merger.merge("inline block inline-1"))
    assert_equal("block i-inline", @merger.merge("inline block i-inline"))
    assert_equal("focus:block focus:inline-1", @merger.merge("focus:inline focus:block focus:inline-1"))
  end
end
