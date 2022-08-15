# frozen_string_literal: true

require "test_helper"

class TestModifiers < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_conflicts_across_modifiers
    assert_equal("hover:inline", @merger.merge("hover:block hover:inline"))
    assert_equal("hover:block hover:focus:inline", @merger.merge("hover:block hover:focus:inline"))
    assert_equal("hover:block focus:hover:inline", @merger.merge("hover:block hover:focus:inline focus:hover:inline"))
    assert_equal("focus-within:block", @merger.merge("focus-within:inline focus-within:block"))
  end
end
