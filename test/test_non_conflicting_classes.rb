# frozen_string_literal: true

require "test_helper"

class TestNonConflictingClasses < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_merges_non_conflicting_classes_correctly
    assert_equal("border-t border-white/10", @merger.merge("border-t border-white/10"))
    assert_equal("border-t border-white", @merger.merge("border-t border-white"))
    assert_equal("text-3.5xl text-black", @merger.merge("text-3.5xl text-black"))
  end
end
