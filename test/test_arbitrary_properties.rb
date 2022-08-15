# frozen_string_literal: true

require "test_helper"

class TestArbitraryProperties < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_handles_arbitrary_property_conflicts_correctly
    assert_equal("[paint-order:normal]", @merger.merge("[paint-order:markers] [paint-order:normal]"))
    assert_equal("[paint-order:normal] [--my-var:4px]", @merger.merge("[paint-order:markers] [--my-var:2rem] [paint-order:normal] [--my-var:4px]"))
  end

  def test_handles_arbitrary_property_conflicts_with_modifiers_correctly
    assert_equal("[paint-order:markers] hover:[paint-order:normal]", @merger.merge("[paint-order:markers] hover:[paint-order:normal]"))

    assert_equal("hover:[paint-order:normal]", @merger.merge("hover:[paint-order:markers] hover:[paint-order:normal]"))

    assert_equal("focus:hover:[paint-order:normal]", @merger.merge("hover:focus:[paint-order:markers] focus:hover:[paint-order:normal]"))

    assert_equal("[paint-order:normal] [--my-var:2rem] lg:[--my-var:4px]", @merger.merge("[paint-order:markers] [paint-order:normal] [--my-var:2rem] lg:[--my-var:4px]"))
  end

  def test_handles_complex_arbitrary_property_conflicts_correctly
    assert_equal("[-unknown-prop:url(https://hi.com)]", @merger.merge("[-unknown-prop:::123:::] [-unknown-prop:url(https://hi.com)]"))
  end

  def test_handles_important_modifier_correctly
    assert_equal("![some:prop] [some:other]", @merger.merge("![some:prop] [some:other]"))
    assert_equal("[some:one] ![some:another]", @merger.merge("![some:prop] [some:other] [some:one] ![some:another]"))
  end
end
