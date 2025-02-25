# frozen_string_literal: true

require "test_helper"

class TestPseudoVariants < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_handles_pseudo_variants_conflicts_properly
    assert_equal("empty:p-3", @merger.merge("empty:p-2 empty:p-3"))
    # assert_equal("hover:empty:p-3", @merger.merge("hover:empty:p-2 hover:empty:p-3"))
    # assert_equal("read-only:p-3", @merger.merge("read-only:p-2 read-only:p-3"))
  end

  def test_handles_pseudo_variant_group_conflicts_properly
    assert_equal("group-empty:p-3", @merger.merge("group-empty:p-2 group-empty:p-3"))
    assert_equal("peer-empty:p-3", @merger.merge("peer-empty:p-2 peer-empty:p-3"))
    assert_equal("group-empty:p-2 peer-empty:p-3", @merger.merge("group-empty:p-2 peer-empty:p-3"))
    assert_equal("hover:group-empty:p-3", @merger.merge("hover:group-empty:p-2 hover:group-empty:p-3"))
    assert_equal("group-read-only:p-3", @merger.merge("group-read-only:p-2 group-read-only:p-3"))
  end
end
