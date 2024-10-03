# frozen_string_literal: true

require "test_helper"

class TestPerSideBorderColorsClasses < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_merges_classes_with_per_side_border_colors_correctly
    assert_equal("border-t-other-blue", @merger.merge("border-t-some-blue border-t-other-blue"))
    assert_equal("border-some-blue", @merger.merge("border-t-some-blue border-some-blue"))

    assert_equal("border-some-blue border-s-some-blue", @merger.merge("border-some-blue border-s-some-blue"))
    assert_equal("border-some-blue", @merger.merge("border-e-some-blue border-some-blue"))
  end
end
