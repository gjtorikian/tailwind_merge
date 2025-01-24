# frozen_string_literal: true

require "test_helper"

class TestPrefixes < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new(config: { prefix: "tw-" })
  end

  def test_prefix_working_correctly
    assert_equal("tw-hidden", @merger.merge("tw-block tw-hidden"))
    assert_equal("block hidden", @merger.merge("block hidden"))

    assert_equal("tw-p-2", @merger.merge("tw-p-3 tw-p-2"))
    assert_equal("p-3 p-2", @merger.merge("p-3 p-2"))

    assert_equal("!tw-inset-0", @merger.merge("!tw-right-0 !tw-inset-0"))

    assert_equal("focus:hover:!tw-inset-0", @merger.merge("hover:focus:!tw-right-0 focus:hover:!tw-inset-0"))
  end
end
