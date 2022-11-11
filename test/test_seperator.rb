# frozen_string_literal: true

require "test_helper"

class TestSeparator < Minitest::Test
  def test_single_character_separator_working_correctly
    merger = TailwindMerge::Merger.new(config: { separator: "_" })

    assert_equal(merger.merge('block hidden'), 'hidden')
    assert_equal(merger.merge('p-3 p-2'), 'p-2')
    assert_equal(merger.merge('!right-0 !inset-0'), '!inset-0')
    assert_equal(merger.merge('hover_focus_!right-0 focus_hover_!inset-0'), 'focus_hover_!inset-0')
    assert_equal(merger.merge('hover:focus:!right-0 focus:hover:!inset-0'), 'hover:focus:!right-0 focus:hover:!inset-0')
  end

  def test_multiple_character_separator_working_correctly
    merger = TailwindMerge::Merger.new(config: { separator: "__" })

    assert_equal(merger.merge('block hidden'), 'hidden')
    assert_equal(merger.merge('p-3 p-2'), 'p-2')
    assert_equal(merger.merge('!right-0 !inset-0'), '!inset-0')
    assert_equal(merger.merge('hover__focus__!right-0 focus__hover__!inset-0'), 'focus__hover__!inset-0')
    assert_equal(merger.merge('hover:focus:!right-0 focus:hover:!inset-0'), 'hover:focus:!right-0 focus:hover:!inset-0')
  end
end
