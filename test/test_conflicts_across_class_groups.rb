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

  def test_axis_shorthands_override_logical_sides
    # Since Tailwind CSS v4 the axis utilities compile to logical shorthand
    # properties (px → padding-inline), which fully override their logical-side
    # longhands (ps → padding-inline-start) in every writing mode.
    assert_equal("px-4", @merger.merge("ps-2 px-4"))
    assert_equal("px-4", @merger.merge("pe-2 px-4"))
    assert_equal("px-4 ps-2", @merger.merge("px-4 ps-2"))
    assert_equal("py-4", @merger.merge("pbs-2 py-4"))
    assert_equal("mx-4", @merger.merge("ms-2 mx-4"))
    assert_equal("my-4", @merger.merge("mbe-2 my-4"))
    assert_equal("inset-x-4", @merger.merge("start-2 inset-x-4"))
    assert_equal("inset-x-4", @merger.merge("end-2 inset-x-4"))
    assert_equal("inset-y-4", @merger.merge("inset-bs-2 inset-y-4"))
    assert_equal("border-x-4", @merger.merge("border-s-2 border-x-4"))
    assert_equal("border-y-4", @merger.merge("border-be-2 border-y-4"))
    assert_equal("border-x-blue-500", @merger.merge("border-s-red-500 border-x-blue-500"))
    assert_equal("border-y-blue-500", @merger.merge("border-bs-red-500 border-y-blue-500"))
    assert_equal("scroll-mx-4", @merger.merge("scroll-ms-2 scroll-mx-4"))
    assert_equal("scroll-my-4", @merger.merge("scroll-mbs-2 scroll-my-4"))
    assert_equal("scroll-px-4", @merger.merge("scroll-ps-2 scroll-px-4"))
    assert_equal("scroll-py-4", @merger.merge("scroll-pbe-2 scroll-py-4"))
  end

  def test_ring_and_shadow_classes_do_not_create_conflict
    assert_equal("ring shadow", @merger.merge("ring shadow"))
    assert_equal("ring-2 shadow-md", @merger.merge("ring-2 shadow-md"))
    assert_equal("shadow ring", @merger.merge("shadow ring"))
    assert_equal("shadow-md ring-2", @merger.merge("shadow-md ring-2"))
  end

  def test_touch_classes_do_create_conflicts_correctly
    assert_equal("touch-pan-right", @merger.merge("touch-pan-x touch-pan-right"))
    assert_equal("touch-pan-x", @merger.merge("touch-none touch-pan-x"))
    assert_equal("touch-none", @merger.merge("touch-pan-x touch-none"))
    assert_equal("touch-pan-x touch-pan-y touch-pinch-zoom", @merger.merge("touch-pan-x touch-pan-y touch-pinch-zoom"))
    assert_equal("touch-pan-x touch-pan-y touch-pinch-zoom", @merger.merge("touch-manipulation touch-pan-x touch-pan-y touch-pinch-zoom"))

    assert_equal("touch-auto", @merger.merge("touch-pan-x touch-pan-y touch-pinch-zoom touch-auto"))

    assert_equal("line-clamp-1", @merger.merge("overflow-auto inline line-clamp-1"))
    assert_equal("line-clamp-1 overflow-auto inline", @merger.merge("line-clamp-1 overflow-auto inline"))
  end
end
