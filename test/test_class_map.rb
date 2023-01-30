# frozen_string_literal: true

# "frozen_string_literal" => true

require "test_helper"
require "set"

class TestClassMap < Minitest::Test
  def setup
    @class_utils = TailwindMerge::ClassUtils.new(TailwindMerge::Config::DEFAULTS)
    @class_map = @class_utils.class_map
  end

  def class_groups_in_class_part(class_part)
    class_group_id = class_part[:class_group_id]
    validators = class_part[:validators]
    next_part = class_part[:next_part]

    class_groups = Set.new

    if class_group_id
      class_groups.add(class_group_id)
    end

    validators.each do |validator|
      class_groups.add(validator[:class_group_id])
    end

    next_part.values.each do |next_class_part|
      class_groups_in_class_part(next_class_part).each do |class_group|
        class_groups.add(class_group)
      end
    end

    class_groups
  end

  def test_class_map_has_correct_class_groups_at_first_part
    result = {}

    @class_map[:next_part].each do |key, value|
      result[key] = class_groups_in_class_part(value).to_a.sort
    end

    refute(@class_map[:class_group_id])
    assert_equal(0, @class_map[:validators].length)
    assert_equal(
      {
        "aspect" => ["aspect"],
        "container" => ["container"],
        "columns" => ["columns"],
        "break" => ["break", "break-after", "break-before", "break-inside"],
        "box" => ["box", "box-decoration"],
        "block" => ["display"],
        "inline" => ["display"],
        "flex" => ["display", "flex", "flex-direction", "flex-wrap"],
        "table" => ["display", "table-layout"],
        "flow" => ["display"],
        "grid" => ["display", "grid-cols", "grid-flow", "grid-rows"],
        "contents" => ["display"],
        "list" => ["display", "list-style-position", "list-style-type"],
        "hidden" => ["display"],
        "float" => ["float"],
        "clear" => ["clear"],
        "isolate" => ["isolation"],
        "isolation" => ["isolation"],
        "object" => ["object-fit", "object-position"],
        "overflow" => ["overflow", "overflow-x", "overflow-y"],
        "overscroll" => ["overscroll", "overscroll-x", "overscroll-y"],
        "static" => ["position"],
        "fixed" => ["position"],
        "absolute" => ["position"],
        "relative" => ["position"],
        "sticky" => ["position"],
        "inset" => ["inset", "inset-x", "inset-y"],
        "top" => ["top"],
        "right" => ["right"],
        "bottom" => ["bottom"],
        "left" => ["left"],
        "visible" => ["visibility"],
        "invisible" => ["visibility"],
        "z" => ["z"],
        "basis" => ["basis"],
        "grow" => ["grow"],
        "shrink" => ["shrink"],
        "order" => ["order"],
        "col" => ["col-end", "col-start", "col-start-end"],
        "collapse" => ["visibility"],
        "row" => ["row-end", "row-start", "row-start-end"],
        "auto" => ["auto-cols", "auto-rows"],
        "gap" => ["gap", "gap-x", "gap-y"],
        "justify" => ["justify-content", "justify-items", "justify-self"],
        "content" => ["align-content", "content"],
        "items" => ["align-items"],
        "self" => ["align-self"],
        "place" => ["place-content", "place-items", "place-self"],
        "p" => ["p"],
        "px" => ["px"],
        "py" => ["py"],
        "pt" => ["pt"],
        "pr" => ["pr"],
        "pb" => ["pb"],
        "pl" => ["pl"],
        "m" => ["m"],
        "mx" => ["mx"],
        "my" => ["my"],
        "mt" => ["mt"],
        "mr" => ["mr"],
        "mb" => ["mb"],
        "ml" => ["ml"],
        "space" => ["space-x", "space-x-reverse", "space-y", "space-y-reverse"],
        "w" => ["w"],
        "min" => ["min-h", "min-w"],
        "max" => ["max-h", "max-w"],
        "h" => ["h"],
        "text" => ["font-size", "text-alignment", "text-color", "text-opacity", "text-overflow"],
        "antialiased" => ["font-smoothing"],
        "subpixel" => ["font-smoothing"],
        "italic" => ["font-style"],
        "not" => ["font-style", "sr"],
        "font" => ["font-family", "font-weight"],
        "normal" => ["fvn-normal", "text-transform"],
        "ordinal" => ["fvn-ordinal"],
        "slashed" => ["fvn-slashed-zero"],
        "lining" => ["fvn-figure"],
        "oldstyle" => ["fvn-figure"],
        "proportional" => ["fvn-spacing"],
        "tabular" => ["fvn-spacing"],
        "diagonal" => ["fvn-fraction"],
        "stacked" => ["fvn-fraction"],
        "tracking" => ["tracking"],
        "leading" => ["leading"],
        "placeholder" => ["placeholder-color", "placeholder-opacity"],
        "underline" => ["text-decoration", "underline-offset"],
        "overline" => ["text-decoration"],
        "line" => ["text-decoration"],
        "no" => ["text-decoration"],
        "decoration" => ["text-decoration-color", "text-decoration-style", "text-decoration-thickness"],
        "uppercase" => ["text-transform"],
        "lowercase" => ["text-transform"],
        "capitalize" => ["text-transform"],
        "truncate" => ["text-overflow"],
        "indent" => ["indent"],
        "align" => ["vertical-align"],
        "whitespace" => ["whitespace"],
        "bg" =>
             [
               "bg-attachment",
               "bg-blend",
               "bg-clip",
               "bg-color",
               "bg-image",
               "bg-opacity",
               "bg-origin",
               "bg-position",
               "bg-repeat",
               "bg-size",
             ],
        "from" => ["gradient-from"],
        "via" => ["gradient-via"],
        "to" => ["gradient-to"],
        "rounded" =>
             [
               "rounded",
               "rounded-b",
               "rounded-bl",
               "rounded-br",
               "rounded-l",
               "rounded-r",
               "rounded-t",
               "rounded-tl",
               "rounded-tr",
             ],
        "border" =>
             [
               "border-collapse",
               "border-color",
               "border-color-b",
               "border-color-l",
               "border-color-r",
               "border-color-t",
               "border-color-x",
               "border-color-y",
               "border-opacity",
               "border-spacing",
               "border-spacing-x",
               "border-spacing-y",
               "border-style",
               "border-w",
               "border-w-b",
               "border-w-l",
               "border-w-r",
               "border-w-t",
               "border-w-x",
               "border-w-y",
             ],
        "divide" =>
             [
               "divide-color",
               "divide-opacity",
               "divide-style",
               "divide-x",
               "divide-x-reverse",
               "divide-y",
               "divide-y-reverse",
             ],
        "outline" => ["outline-color", "outline-offset", "outline-style", "outline-w"],
        "ring" => ["ring-color", "ring-offset-color", "ring-offset-w", "ring-opacity", "ring-w", "ring-w-inset"],
        "shadow" => ["shadow", "shadow-color"],
        "opacity" => ["opacity"],
        "mix" => ["mix-blend"],
        "filter" => ["filter"],
        "blur" => ["blur"],
        "brightness" => ["brightness"],
        "contrast" => ["contrast"],
        "drop" => ["drop-shadow"],
        "grayscale" => ["grayscale"],
        "hue" => ["hue-rotate"],
        "invert" => ["invert"],
        "saturate" => ["saturate"],
        "sepia" => ["sepia"],
        "backdrop" =>
             [
               "backdrop-blur",
               "backdrop-brightness",
               "backdrop-contrast",
               "backdrop-filter",
               "backdrop-grayscale",
               "backdrop-hue-rotate",
               "backdrop-invert",
               "backdrop-opacity",
               "backdrop-saturate",
               "backdrop-sepia",
             ],
        "transition" => ["transition"],
        "duration" => ["duration"],
        "ease" => ["ease"],
        "delay" => ["delay"],
        "animate" => ["animate"],
        "transform" => ["transform"],
        "scale" => ["scale", "scale-x", "scale-y"],
        "rotate" => ["rotate"],
        "translate" => ["translate-x", "translate-y"],
        "skew" => ["skew-x", "skew-y"],
        "origin" => ["transform-origin"],
        "accent" => ["accent"],
        "appearance" => ["appearance"],
        "cursor" => ["cursor"],
        "caret" => ["caret-color"],
        "pointer" => ["pointer-events"],
        "resize" => ["resize"],
        "scroll" =>
             [
               "scroll-behavior",
               "scroll-m",
               "scroll-mb",
               "scroll-ml",
               "scroll-mr",
               "scroll-mt",
               "scroll-mx",
               "scroll-my",
               "scroll-p",
               "scroll-pb",
               "scroll-pl",
               "scroll-pr",
               "scroll-pt",
               "scroll-px",
               "scroll-py",
             ],
        "snap" => ["snap-align", "snap-stop", "snap-strictness", "snap-type"],
        "touch" => ["touch"],
        "select" => ["select"],
        "will" => ["will-change"],
        "fill" => ["fill"],
        "stroke" => ["stroke", "stroke-w"],
        "sr" => ["sr"],
      },
      result,
    )
  end
end
