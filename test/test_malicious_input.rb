# frozen_string_literal: true

require "test_helper"

class TestMaliciousInput < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_handles_wonky_input
    assert_equal("block", @merger.merge(" block"))
    assert_equal("block", @merger.merge("block "))
    assert_equal("block", @merger.merge(" block "))

    assert_equal("block px-2 py-4", @merger.merge("  block  px-2     py-4  "))
    assert_equal("block px-2 py-4", @merger.merge(["  block  px-2", " ", "     py-4  "]))

    assert_equal("block px-2", @merger.merge("block\npx-2"))
    assert_equal("block px-2", @merger.merge("\nblock\npx-2\n"))
    assert_equal("block px-2 py-4", @merger.merge("  block\n        \n        px-2   \n          py-4  "))
    assert_equal("block px-2 py-4", @merger.merge("\r  block\n\r        \n        px-2   \n          py-4  "))
  end
end
