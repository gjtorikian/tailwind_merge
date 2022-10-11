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

  def test_removes_duplicates
    original = "bg-red-500 border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm border-indigo-500 text-indigo-600 bg-red-500 border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm"
    merged = "bg-red-500 border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm"
    refute_equal(original, @merger.merge(original))
    assert_equal(merged, @merger.merge(original))
  end
end
