# frozen_string_literal: true

require "test_helper"

class TestConflictsAcrossClassGroups < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_handles_conflicts_across_class_groups_correctly
    assert_equal("inset-1 inset-x-1", @merger.merge("inset-1 inset-x-1"))
    assert_equal("inset-1", @merger.merge("inset-x-1 inset-1"))
    assert_equal("inset-1", @merger.merge("inset-x-1 left-1 inset-1"))
    assert_equal("inset-1 left-1", @merger.merge("inset-x-1 inset-1 left-1"))
    assert_equal("inset-1", @merger.merge("inset-x-1 right-1 inset-1"))
    assert_equal("inset-x-1", @merger.merge("inset-x-1 right-1 inset-x-1"))
    assert_equal("inset-x-1 right-1 inset-y-1", @merger.merge("inset-x-1 right-1 inset-y-1"))
    assert_equal("inset-x-1 inset-y-1", @merger.merge("right-1 inset-x-1 inset-y-1"))
    assert_equal("hover:left-1 inset-1", @merger.merge("inset-x-1 hover:left-1 inset-1"))
  end

  def test_ring_and_shadow_classes_do_not_create_conflict
    assert_equal("ring shadow", @merger.merge("ring shadow"))
    assert_equal("ring-2 shadow-md", @merger.merge("ring-2 shadow-md"))
    assert_equal("shadow ring", @merger.merge("shadow ring"))
    assert_equal("shadow-md ring-2", @merger.merge("shadow-md ring-2"))
  end
end
