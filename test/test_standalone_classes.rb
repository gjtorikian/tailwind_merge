# frozen_string_literal: true

require "test_helper"

class TestStandaloneClasses < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_merges_standalone_classes_from_same_group_correctly
    assert_equal("block", @merger.merge("inline block"))
    assert_equal("hover:inline", @merger.merge("hover:block hover:inline"))
    assert_equal("hover:block", @merger.merge("hover:block hover:block"))
    assert_equal("inline focus:inline hover:block hover:focus:block", @merger.merge("inline hover:inline focus:inline hover:block hover:focus:block"))
    assert_equal("line-through", @merger.merge("underline line-through"))
    assert_equal("no-underline", @merger.merge("line-through no-underline"))
  end
end
