# frozen_string_literal: true

require "test_helper"

class TestTheme < Minitest::Test
  def test_theme_scale_can_be_extended
    merger = TailwindMerge::Merger.new(config: {
      theme: {
        "spacing" => ["my-space"],
        "leading" => ["my-leading"],
      },
    })

    assert_equal("p-my-space p-my-margin", merger.merge("p-3 p-my-space p-my-margin"))
    assert_equal("leading-my-leading", merger.merge("leading-3 leading-my-space leading-my-leading"))
  end

  # def test_theme_object_can_be_extended
  #   merger = TailwindMerge::Merger.new(config: {
  #     theme: {
  #       "spacing" => ["my-space"],
  #       "margin" => ["my-margin"],
  #     },
  #   })

  #   assert_equal("p-3 p-hello p-hallo", merger.merge("p-3 p-hello p-hallo"))
  #   assert_equal("px-hallo", merger.merge("px-3 px-hello px-hallo"))
  # end
end
