# frozen_string_literal: true

require "test_helper"

class TestNegativeValues < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_handles_negative_value_conflicts_correctly
    assert_equal("-m-5", @merger.merge("-m-2 -m-5"))
    assert_equal("-top-2000", @merger.merge("-top-12 -top-2000"))
  end

  def test_handles_conflicts_between_positive_and_negative_values_correctly
    assert_equal("m-auto", @merger.merge("-m-2 m-auto"))
    assert_equal("-top-69", @merger.merge("top-12 -top-69"))
  end

  def test_handles_conflicts_across_groups_with_negative_values_correctly
    assert_equal("inset-x-1", @merger.merge("-right-1 inset-x-1"))
    assert_equal("focus:hover:inset-x-1", @merger.merge("hover:focus:-right-1 focus:hover:inset-x-1"))
  end
end
