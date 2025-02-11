# frozen_string_literal: true

require "test_helper"

class TestImportantModifier < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_merges_tailwind_classes_with_important_modifier_correctly
    assert_equal("font-bold!", @merger.merge("font-medium! font-bold!"))
    assert_equal("font-bold! font-thin", @merger.merge("font-medium! font-bold! font-thin"))
    assert_equal("-inset-x-px!", @merger.merge("right-2! -inset-x-px!"))
    assert_equal("focus:block!", @merger.merge("focus:inline! focus:block!"))
    assert_equal("[--my-var:30px]!", @merger.merge("[--my-var:20px]! [--my-var:30px]!"))

    # Tailwind CSS v3 legacy syntax
    assert_equal("!font-bold", @merger.merge("font-medium! !font-bold"))
    assert_equal("!font-bold", @merger.merge("!font-medium !font-bold"))
    assert_equal("!font-bold font-thin", @merger.merge("!font-medium !font-bold font-thin"))
    assert_equal("!-inset-x-px", @merger.merge("!right-2 !-inset-x-px"))
    assert_equal("focus:!block", @merger.merge("focus:!inline focus:!block"))
    assert_equal("![--my-var:30px]", @merger.merge("![--my-var:20px] ![--my-var:30px]"))
  end
end
