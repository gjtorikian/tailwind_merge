# frozen_string_literal: true

require "test_helper"

class TestCacheTampering < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_cached_values_are_immutable
    classes = @merger.merge("font-medium font-bold")
    assert_raises(FrozenError) do
      classes << " text-white"
    end
  end
end
