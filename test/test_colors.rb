# frozen_string_literal: true

require "test_helper"

class TesColors < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_handles_color_conflicts_properly
    assert_equal("bg-hotpink", @merger.merge("bg-grey-5 bg-hotpink"))
    assert_equal("hover:bg-hotpink", @merger.merge("hover:bg-grey-5 hover:bg-hotpink"))
    assert_equal("stroke-[hsl(350_80%_0%)] stroke-[10px]", @merger.merge("stroke-[hsl(350_80%_0%)] stroke-[10px]"))
  end

  def test_handles_color_functions_with_percentages_correctly
    assert_equal("text-sm text-[color(display-p3_1_0_0/50%)]", @merger.merge("text-sm text-[color(display-p3_1_0_0/50%)]"))
    assert_equal("text-[color(display-p3_1_0_0/50%)] text-sm", @merger.merge("text-[color(display-p3_1_0_0/50%)] text-sm"))
    assert_equal("text-[color(display-p3_1_0_0/50%)]", @merger.merge("text-red-500 text-[color(display-p3_1_0_0/50%)]"))
    assert_equal("text-red-500", @merger.merge("text-[color(display-p3_1_0_0/50%)] text-red-500"))
    assert_equal("border-2 border-[color(display-p3_1_0_0/50%)]", @merger.merge("border-2 border-[color(display-p3_1_0_0/50%)]"))
    assert_equal("border-[color(display-p3_1_0_0/50%)] border-2", @merger.merge("border-[color(display-p3_1_0_0/50%)] border-2"))
    assert_equal("stroke-2 stroke-[color(display-p3_1_0_0/50%)]", @merger.merge("stroke-2 stroke-[color(display-p3_1_0_0/50%)]"))
    assert_equal("stroke-[color(display-p3_1_0_0/50%)] stroke-2", @merger.merge("stroke-[color(display-p3_1_0_0/50%)] stroke-2"))
  end

  def test_handles_light_dark_functions_with_percentages_correctly
    assert_equal("text-sm text-[light-dark(white,rgb(0_0_0/50%))]", @merger.merge("text-sm text-[light-dark(white,rgb(0_0_0/50%))]"))
    assert_equal("text-[light-dark(white,rgb(0_0_0/50%))] text-sm", @merger.merge("text-[light-dark(white,rgb(0_0_0/50%))] text-sm"))
    assert_equal("text-[light-dark(white,rgb(0_0_0/50%))]", @merger.merge("text-red-500 text-[light-dark(white,rgb(0_0_0/50%))]"))
    assert_equal("text-red-500", @merger.merge("text-[light-dark(white,rgb(0_0_0/50%))] text-red-500"))
    assert_equal("border-2 border-[light-dark(white,rgb(0_0_0/50%))]", @merger.merge("border-2 border-[light-dark(white,rgb(0_0_0/50%))]"))
    assert_equal("border-[light-dark(white,rgb(0_0_0/50%))] border-2", @merger.merge("border-[light-dark(white,rgb(0_0_0/50%))] border-2"))
    assert_equal("stroke-2 stroke-[light-dark(white,rgb(0_0_0/50%))]", @merger.merge("stroke-2 stroke-[light-dark(white,rgb(0_0_0/50%))]"))
    assert_equal("stroke-[light-dark(white,rgb(0_0_0/50%))] stroke-2", @merger.merge("stroke-[light-dark(white,rgb(0_0_0/50%))] stroke-2"))
  end
end
