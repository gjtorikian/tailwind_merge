# frozen_string_literal: true

require "test_helper"

class TestClassGroupConflicts < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_merge_classes_from_same_group_correctly
    assert_equal("overflow-x-hidden", @merger.merge("overflow-x-auto overflow-x-hidden"))
    assert_equal("basis-auto", @merger.merge("basis-full basis-auto"))
    assert_equal("w-fit", @merger.merge("w-full w-fit"))
    assert_equal("overflow-x-scroll", @merger.merge("overflow-x-auto overflow-x-hidden overflow-x-scroll"))
    assert_equal("hover:overflow-x-hidden overflow-x-scroll", @merger.merge("overflow-x-auto hover:overflow-x-hidden overflow-x-scroll"))
    assert_equal("hover:overflow-x-auto overflow-x-scroll", @merger.merge("overflow-x-auto hover:overflow-x-hidden hover:overflow-x-auto overflow-x-scroll"))
    assert_equal("col-span-full", @merger.merge("col-span-1 col-span-full"))
    assert_equal("columns-auto", @merger.merge("columns-12 columns-auto"))
    assert_equal("columns-2xl", @merger.merge("columns-auto columns-2xl"))
    assert_equal("gap-px basis-3", @merger.merge("gap-2 gap-px basis-px basis-3"))
  end

  def test_merges_none_values_in_sizing_groups_correctly
    assert_equal("max-w-none", @merger.merge("max-w-lg max-w-none"))
    assert_equal("max-w-lg", @merger.merge("max-w-none max-w-lg"))
    assert_equal("max-h-none", @merger.merge("max-h-96 max-h-none"))
    assert_equal("max-h-96", @merger.merge("max-h-none max-h-96"))
    assert_equal("max-h-none", @merger.merge("max-h-[300px] max-h-none"))
    assert_equal("max-h-screen", @merger.merge("max-h-none max-h-screen"))
  end

  def test_merges_classes_from_font_variant_numeric_section_correctly
    assert_equal("lining-nums tabular-nums diagonal-fractions", @merger.merge("lining-nums tabular-nums diagonal-fractions"))
    assert_equal("tabular-nums diagonal-fractions", @merger.merge("normal-nums tabular-nums diagonal-fractions"))
    assert_equal("normal-nums", @merger.merge("tabular-nums diagonal-fractions normal-nums"))
    assert_equal("proportional-nums", @merger.merge("tabular-nums proportional-nums"))
  end
end
