# frozen_string_literal: true

require "test_helper"

class TestArbitraryValues < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_handles_simple_conflicts_with_arbitrary_values_correctly
    assert_equal("m-[10px]", @merger.merge("m-[2px] m-[10px]"))
    assert_equal("z-[99]", @merger.merge("z-20 z-[99]"))
    assert_equal("m-[10dvh]", @merger.merge("m-[2px] m-[11svmin] m-[12in] m-[13lvi] m-[14vb] m-[15vmax] m-[16mm] m-[17%] m-[18em] m-[19px] m-[10dvh]"))
    assert_equal("h-[16cqmax]", @merger.merge("h-[10px] h-[11cqw] h-[12cqh] h-[13cqi] h-[14cqb] h-[15cqmin] h-[16cqmax]"))
    assert_equal("m-[10rem]", @merger.merge("my-[2px] m-[10rem]"))
    assert_equal("cursor-[grab]", @merger.merge("cursor-pointer cursor-[grab]"))
    assert_equal("m-[calc(100%-var(--arbitrary))]", @merger.merge("m-[2px] m-[calc(100%-var(--arbitrary))]"))
    assert_equal("m-[length:var(--mystery-var)]", @merger.merge("m-[2px] m-[length:var(--mystery-var)]"))
    assert_equal("opacity-[0.025]", @merger.merge("opacity-10 opacity-[0.025]"))
    assert_equal("scale-[1.7]", @merger.merge("scale-75 scale-[1.7]"))
    assert_equal("brightness-[1.75]", @merger.merge("brightness-90 brightness-[1.75]"))

    # Handling of value `0`
    assert_equal("min-h-[0]", @merger.merge("min-h-[0.5px] min-h-[0]"))
    assert_equal("text-[0.5px] text-[color:0]", @merger.merge("text-[0.5px] text-[color:0]"))
    assert_equal("text-[0.5px] text-[--my-0]", @merger.merge("text-[0.5px] text-[--my-0]"))
  end

  def test_handles_arbitrary_length_conflicts_with_labels_and_modifiers_correctly
    assert_equal("hover:m-[length:var(--c)]", @merger.merge("hover:m-[2px] hover:m-[length:var(--c)]"))
    assert_equal("focus:hover:m-[length:var(--c)]", @merger.merge("hover:focus:m-[2px] focus:hover:m-[length:var(--c)]"))
    assert_equal("border-b border-[color:rgb(var(--color-gray-500-rgb)/50%))]", @merger.merge("border-b border-[color:rgb(var(--color-gray-500-rgb)/50%))]"))
    assert_equal("border-[color:rgb(var(--color-gray-500-rgb)/50%))] border-b", @merger.merge("border-[color:rgb(var(--color-gray-500-rgb)/50%))] border-b"))
    assert_equal("border-b border-some-coloooor", @merger.merge("border-b border-[color:rgb(var(--color-gray-500-rgb)/50%))] border-some-coloooor"))
  end

  def test_handles_complex_arbitrary_value_conflicts_correctly
    assert_equal("grid-rows-2", @merger.merge("grid-rows-[1fr,auto] grid-rows-2"))
    assert_equal("grid-rows-3", @merger.merge("grid-rows-[repeat(20,minmax(0,1fr))] grid-rows-3"))
  end

  def test_handles_ambiguous_arbitrary_values_correctly
    assert_equal("mt-[calc(theme(fontSize.4xl)/1.125)]", @merger.merge("mt-2 mt-[calc(theme(fontSize.4xl)/1.125)]"))
    assert_equal("p-[calc(theme(fontSize.4xl)/1.125)_10px]", @merger.merge("p-2 p-[calc(theme(fontSize.4xl)/1.125)_10px]"))
    assert_equal("mt-[length:theme(someScale.someValue)]", @merger.merge("mt-2 mt-[length:theme(someScale.someValue)]"))

    assert_equal("mt-[theme(someScale.someValue)]", @merger.merge("mt-2 mt-[theme(someScale.someValue)]"))

    assert_equal("text-[length:theme(someScale.someValue)]", @merger.merge("text-2xl text-[length:theme(someScale.someValue)]"))
    assert_equal("text-[calc(theme(fontSize.4xl)/1.125)]", @merger.merge("text-2xl text-[calc(theme(fontSize.4xl)/1.125)]"))

    assert_equal("bg-[length:200px_100px]", @merger.merge("bg-cover bg-[percentage:30%] bg-[length:200px_100px]"))
    assert_equal("bg-gradient-to-r", @merger.merge("bg-none bg-[url(.)] bg-[image:.] bg-[url:.] bg-[linear-gradient(.)] bg-gradient-to-r"))
  end
end
