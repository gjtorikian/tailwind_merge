# frozen_string_literal: true

require "test_helper"

class TestArbitraryValues < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_handles_simple_conflicts_with_arbitrary_values_correctly
    assert_equal("m-[10px]", @merger.merge("m-[2px] m-[10px]"))
    assert_equal("z-[99]", @merger.merge("z-20 z-[99]"))
    assert_equal("m-[10rem]", @merger.merge("my-[2px] m-[10rem]"))
    assert_equal("cursor-[grab]", @merger.merge("cursor-pointer cursor-[grab]"))
    assert_equal("m-[calc(100%-var(--arbitrary))]", @merger.merge("m-[2px] m-[calc(100%-var(--arbitrary))]"))
    assert_equal("m-[length:var(--mystery-var)]", @merger.merge("m-[2px] m-[length:var(--mystery-var)]"))
  end

  def test_handles_arbitrary_length_conflicts_with_labels_and_modifiers_correctly
    assert_equal("hover:m-[length:var(--c)]", @merger.merge("hover:m-[2px] hover:m-[length:var(--c)]"))
    assert_equal("focus:hover:m-[length:var(--c)]", @merger.merge("hover:focus:m-[2px] focus:hover:m-[length:var(--c)]"))
  end

  def test_handles_complex_arbitrary_value_conflicts_correctly
    assert_equal("grid-rows-2", @merger.merge("grid-rows-[1fr,auto] grid-rows-2"))
    assert_equal("grid-rows-3", @merger.merge("grid-rows-[repeat(20,minmax(0,1fr))] grid-rows-3"))
  end
end
