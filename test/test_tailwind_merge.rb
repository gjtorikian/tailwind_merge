# frozen_string_literal: true

require "test_helper"

class TestTailwindMerge < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_that_it_has_a_version_number
    refute_nil(::TailwindMerge::VERSION)
  end

  def test_it_basically_works
    assert_equal("mix-blend-multiply", @merger.merge("mix-blend-normal mix-blend-multiply"))
    assert_equal("h-min", @merger.merge("h-10 h-min"))
    assert_equal("stroke-black stroke-1", @merger.merge("stroke-black stroke-1"))
    assert_equal("outline-black outline-1", @merger.merge("outline-black outline-1"))
    assert_equal("grayscale-[50%]", @merger.merge("grayscale-0 grayscale-[50%]"))
    assert_equal("grow-[2]", @merger.merge("grow grow-[2]"))
  end
end
