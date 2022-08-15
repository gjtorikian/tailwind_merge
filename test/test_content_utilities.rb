# frozen_string_literal: true

require "test_helper"

class TestContentUtilities < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_merges_content_utilities_correctly
    assert_equal("content-[attr(data-content)]", @merger.merge("content-['hello'] content-[attr(data-content)]"))
  end
end
