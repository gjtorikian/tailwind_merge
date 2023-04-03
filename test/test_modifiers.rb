# frozen_string_literal: true

require "test_helper"

class TestModifiers < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_conflicts_across_prefix_modifiers
    assert_equal("hover:inline", @merger.merge("hover:block hover:inline"))
    assert_equal("hover:block hover:focus:inline", @merger.merge("hover:block hover:focus:inline"))
    assert_equal("hover:block focus:hover:inline", @merger.merge("hover:block hover:focus:inline focus:hover:inline"))
    assert_equal("focus-within:block", @merger.merge("focus-within:inline focus-within:block"))
  end

  def test_conflicts_across_postfix_modifiers
    assert_equal("text-lg/8", @merger.merge("text-lg/7 text-lg/8"))
    assert_equal("text-lg/none leading-9", @merger.merge("text-lg/none leading-9"))
    assert_equal("text-lg/none", @merger.merge("leading-9 text-lg/none"))
    assert_equal("w-1/2", @merger.merge("w-full w-1/2"))
  end
end
