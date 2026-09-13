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

  def test_leading_none_is_independent_of_the_leading_theme_scale
    # `leading-none` is a static Tailwind v4 utility (`line-height: 1`) that does not
    # come from the `--leading-*` theme namespace, so it must stay in the leading class
    # group even if the theme scale is replaced -- same as `rounded-none` / `shadow-none`
    # survive `theme.radius` / `theme.shadow` overrides. This port only supports
    # extending theme scales, so the invariant is pinned on the class group itself.
    leading_group = TailwindMerge::Config::DEFAULTS[:class_groups]["leading"].first["leading"]

    assert_includes(leading_group, "none")

    merger = TailwindMerge::Merger.new

    assert_equal("leading-none", merger.merge("leading-tight leading-none"))
    assert_equal("leading-tight", merger.merge("leading-none leading-tight"))
    assert_equal("leading-none", merger.merge("leading-4 leading-none"))
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
