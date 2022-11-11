# frozen_string_literal: true

require "test_helper"

class TestSeparator < Minitest::Test
  def test_single_character_separator_working_correctly
    merger = TailwindMerge::Merger.new(config: { separator: "_" })

    assert_equal("hidden", merger.merge("block hidden"))
    assert_equal("p-2", merger.merge("p-3 p-2"))
    assert_equal("!inset-0", merger.merge("!right-0 !inset-0"))
    assert_equal("focus_hover_!inset-0", merger.merge("hover_focus_!right-0 focus_hover_!inset-0"))
    assert_equal("hover:focus:!right-0 focus:hover:!inset-0", merger.merge("hover:focus:!right-0 focus:hover:!inset-0"))
  end

  def test_multiple_character_separator_working_correctly
    merger = TailwindMerge::Merger.new(config: { separator: "__" })

    assert_equal("hidden", merger.merge("block hidden"))
    assert_equal("p-2", merger.merge("p-3 p-2"))
    assert_equal("!inset-0", merger.merge("!right-0 !inset-0"))
    assert_equal("focus__hover__!inset-0", merger.merge("hover__focus__!right-0 focus__hover__!inset-0"))
    assert_equal("hover:focus:!right-0 focus:hover:!inset-0", merger.merge("hover:focus:!right-0 focus:hover:!inset-0"))
  end
end
