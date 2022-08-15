# frozen_string_literal: true

require "test_helper"

class TestClassGroupConflicts < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_merge_classes_from_same_group_correctly
    assert_equal("overflow-x-hidden", @merger.merge("overflow-x-auto overflow-x-hidden"))
    assert_equal("w-fit", @merger.merge("w-full w-fit"))
    assert_equal("overflow-x-scroll", @merger.merge("overflow-x-auto overflow-x-hidden overflow-x-scroll"))
    assert_equal("hover:overflow-x-hidden overflow-x-scroll", @merger.merge("overflow-x-auto hover:overflow-x-hidden overflow-x-scroll"))
    assert_equal("hover:overflow-x-auto overflow-x-scroll", @merger.merge("overflow-x-auto hover:overflow-x-hidden hover:overflow-x-auto overflow-x-scroll"))
  end

  def test_merges_classes_from_font_variant_numeric_section_correctly
    assert_equal("lining-nums tabular-nums diagonal-fractions", @merger.merge("lining-nums tabular-nums diagonal-fractions"))
    assert_equal("tabular-nums diagonal-fractions", @merger.merge("normal-nums tabular-nums diagonal-fractions"))
    assert_equal("normal-nums", @merger.merge("tabular-nums diagonal-fractions normal-nums"))
    assert_equal("proportional-nums", @merger.merge("tabular-nums proportional-nums"))
  end
end
