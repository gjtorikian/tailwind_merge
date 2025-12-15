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
    assert_equal("gap-px basis-3", @merger.merge("gap-2 gap-px basis-px basis-3"))
  end

  def test_merges_classes_from_font_variant_numeric_section_correctly
    assert_equal("lining-nums tabular-nums diagonal-fractions", @merger.merge("lining-nums tabular-nums diagonal-fractions"))
    assert_equal("tabular-nums diagonal-fractions", @merger.merge("normal-nums tabular-nums diagonal-fractions"))
    assert_equal("normal-nums", @merger.merge("tabular-nums diagonal-fractions normal-nums"))
    assert_equal("proportional-nums", @merger.merge("tabular-nums proportional-nums"))
  end

  def test_merges_typography_plugin_classes_correctly
    assert_equal("prose-lg", @merger.merge("prose-base prose-lg"))
    assert_equal("prose-sm", @merger.merge("prose-lg prose-sm"))

    assert_equal("prose-zinc", @merger.merge("prose-gray prose-zinc"))
    assert_equal("prose-slate", @merger.merge("prose-zinc prose-slate"))

    assert_equal("prose prose-lg prose-zinc", @merger.merge("prose prose-lg prose-zinc"))

    assert_equal("prose-lg prose-zinc", @merger.merge("prose-lg prose-zinc"))
  end
end
