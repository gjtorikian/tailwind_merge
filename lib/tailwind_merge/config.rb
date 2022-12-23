# frozen_string_literal: true

module TailwindMerge
  module Config
    include Validators

    FROM_THEME = ->(config, theme) {
      config.fetch(:theme, {}).fetch(theme, nil)
    }

    COLORS = ->(config) { FROM_THEME.call(config, "colors") }
    SPACING = ->(config) { FROM_THEME.call(config, "spacing") }
    BLUR = ->(config) { FROM_THEME.call(config, "blur") }
    BRIGHTNESS = ->(config) { FROM_THEME.call(config, "brightness") }
    BORDER_COLOR = ->(config) { FROM_THEME.call(config, "border-color") }
    BORDER_RADIUS = ->(config) { FROM_THEME.call(config, "border-radius") }
    BORDER_SPACING = ->(config) { FROM_THEME.call(config, "border-spacing") }
    BORDER_WIDTH = ->(config) { FROM_THEME.call(config, "border-width") }
    CONTRAST = ->(config) { FROM_THEME.call(config, "contrast") }
    GRAYSCALE = ->(config) { FROM_THEME.call(config, "grayscale") }
    HUE_ROTATE = ->(config) { FROM_THEME.call(config, "hue-rotate") }
    INVERT = ->(config) { FROM_THEME.call(config, "invert") }
    GAP = ->(config) { FROM_THEME.call(config, "gap") }
    GRADIENT_COLOR_STOPS = ->(config) { FROM_THEME.call(config, "gradient-color-stops") }
    INSET = ->(config) { FROM_THEME.call(config, "inset") }
    MARGIN = ->(config) { FROM_THEME.call(config, "margin") }
    OPACITY = ->(config) { FROM_THEME.call(config, "opacity") }
    PADDING = ->(config) { FROM_THEME.call(config, "padding") }
    SATURATE = ->(config) { FROM_THEME.call(config, "saturate") }
    SCALE = ->(config) { FROM_THEME.call(config, "scale") }
    SEPIA = ->(config) { FROM_THEME.call(config, "sepia") }
    SKEW = ->(config) { FROM_THEME.call(config, "skew") }
    SPACE = ->(config) { FROM_THEME.call(config, "space") }
    TRANSLATE = ->(config) { FROM_THEME.call(config, "translate") }

    VALID_THEME_IDS = Set.new([
      COLORS.object_id,
      SPACING.object_id,
      BLUR.object_id,
      BRIGHTNESS.object_id,
      BORDER_COLOR.object_id,
      BORDER_RADIUS.object_id,
      BORDER_SPACING.object_id,
      BORDER_WIDTH.object_id,
      CONTRAST.object_id,
      GRAYSCALE.object_id,
      HUE_ROTATE.object_id,
      INVERT.object_id,
      GAP.object_id,
      GRADIENT_COLOR_STOPS.object_id,
      INSET.object_id,
      MARGIN.object_id,
      OPACITY.object_id,
      PADDING.object_id,
      SATURATE.object_id,
      SCALE.object_id,
      SEPIA.object_id,
      SKEW.object_id,
      SPACE.object_id,
      TRANSLATE.object_id,
    ]).freeze

    OVERSCROLL = -> { ["auto", "contain", "none"] }
    OVERFLOW = -> { ["auto", "hidden", "clip", "visible", "scroll"] }
    SPACING_WITH_AUTO = -> { ["auto", SPACING] }
    LENGTH_WITH_EMPTY = -> { ["", IS_LENGTH] }
    INTEGER_WITH_AUTO = -> { ["auto", IS_INTEGER] }
    POSITIONS = -> {
      [
        "bottom",
        "center",
        "left",
        "left-bottom",
        "left-top",
        "right",
        "right-bottom",
        "right-top",
        "top",
      ]
    }
    LINE_STYLES = -> { ["solid", "dashed", "dotted", "double", "none"] }
    BLEND_MODES = -> {
      [
        "normal",
        "multiply",
        "screen",
        "overlay",
        "darken",
        "lighten",
        "color-dodge",
        "color-burn",
        "hard-light",
        "soft-light",
        "difference",
        "exclusion",
        "hue",
        "saturation",
        "color",
        "luminosity",
        "plus-lighter",
      ]
    }
    ALIGN = -> { ["start", "end", "center", "between", "around", "evenly"] }
    ZERO_AND_EMPTY = -> { ["", "0", IS_ARBITRARY_VALUE] }
    BREAKS = -> { ["auto", "avoid", "all", "avoid-page", "page", "left", "right", "column"] }

    DEFAULTS = {
      cache_size: 500,
      separator: ":",
      theme: {
        "colors" => [IS_ANY],
        "spacing" => [IS_LENGTH],
        "blur" => ["none", "", IS_TSHIRT_SIZE, IS_ARBITRARY_LENGTH],
        "brightness" => [IS_INTEGER],
        "border-color" => [COLORS],
        "border-radius" => ["none", "", "full", IS_TSHIRT_SIZE, IS_ARBITRARY_LENGTH],
        "border-spacing" => [SPACING],
        "border-width" => LENGTH_WITH_EMPTY.call,
        "contrast" => [IS_INTEGER],
        "grayscale" => ZERO_AND_EMPTY.call,
        "hue-rotate" => [IS_INTEGER],
        "invert" => ZERO_AND_EMPTY.call,
        "gap" => [SPACING],
        "gradient-color-stops" => [COLORS],
        "inset" => SPACING_WITH_AUTO.call,
        "margin" => SPACING_WITH_AUTO.call,
        "opacity" => [IS_INTEGER],
        "padding" => [SPACING],
        "saturate" => [IS_INTEGER],
        "scale" => [IS_INTEGER],
        "sepia" => ZERO_AND_EMPTY.call,
        "skew" => [IS_INTEGER, IS_ARBITRARY_VALUE],
        "space" => [SPACING],
        "translate" => [SPACING],
      },
      class_groups: {
        # Layout
        ##
        # Aspect Ratio
        # @see https://tailwindcss.com/docs/aspect-ratio
        ##
        "aspect" => [{ "aspect" => ["auto", "square", "video", IS_ARBITRARY_VALUE] }],
        ##
        # Container
        # @see https://tailwindcss.com/docs/container
        ##
        "container" => ["container"],
        ##
        # Columns
        # @see https://tailwindcss.com/docs/columns
        ##
        "columns" => [{ "columns" => [IS_TSHIRT_SIZE] }],
        ##
        # Break After
        # @see https://tailwindcss.com/docs/break-after
        ##
        "break-after" => [{ "break-after" => BREAKS.call }],
        ##
        # Break Before
        # @see https://tailwindcss.com/docs/break-before
        ##
        "break-before" => [{ "break-before" => BREAKS.call }],
        ##
        # Break Inside
        # @see https://tailwindcss.com/docs/break-inside
        ##
        "break-inside" => [{ "break-inside" => ["auto", "avoid", "avoid-page", "avoid-column"] }],
        ##
        # Box Decoration Break
        # @see https://tailwindcss.com/docs/box-decoration-break
        ##
        "box-decoration" => [{ "box-decoration" => ["slice", "clone"] }],
        ##
        # Box Sizing
        # @see https://tailwindcss.com/docs/box-sizing
        ##
        "box" => [{ "box" => ["border", "content"] }],
        ##
        # Display
        # @see https://tailwindcss.com/docs/display
        ##
        "display" => [
          "block",
          "inline-block",
          "inline",
          "flex",
          "inline-flex",
          "table",
          "inline-table",
          "table-caption",
          "table-cell",
          "table-column",
          "table-column-group",
          "table-footer-group",
          "table-header-group",
          "table-row-group",
          "table-row",
          "flow-root",
          "grid",
          "inline-grid",
          "contents",
          "list-item",
          "hidden",
        ],
        ##
        # Floats
        # @see https://tailwindcss.com/docs/float
        ##
        "float" => [{ "float" => ["right", "left", "none"] }],
        ##
        # Clear
        # @see https://tailwindcss.com/docs/clear
        ##
        "clear" => [{ "clear" => ["left", "right", "both", "none"] }],
        ##
        # Isolation
        # @see https://tailwindcss.com/docs/isolation
        ##
        "isolation" => ["isolate", "isolation-auto"],
        ##
        # Object Fit
        # @see https://tailwindcss.com/docs/object-fit
        ##
        "object-fit" => [{ "object" => ["contain", "cover", "fill", "none", "scale-down"] }],
        ##
        # Object Position
        # @see https://tailwindcss.com/docs/object-position
        ##
        "object-position" => [{ "object" => [*POSITIONS.call, IS_ARBITRARY_VALUE] }],
        ##
        # Overflow
        # @see https://tailwindcss.com/docs/overflow
        ##
        "overflow" => [{ "overflow" => OVERFLOW.call }],
        ##
        # Overflow X
        # @see https://tailwindcss.com/docs/overflow
        ##
        "overflow-x" => [{ "overflow-x" => OVERFLOW.call }],
        ##
        # Overflow Y
        # @see https://tailwindcss.com/docs/overflow
        ##
        "overflow-y" => [{ "overflow-y" => OVERFLOW.call }],
        ##
        # Overscroll Behavior
        # @see https://tailwindcss.com/docs/overscroll-behavior
        ##
        "overscroll" => [{ "overscroll" => OVERSCROLL.call }],
        ##
        # Overscroll Behavior X
        # @see https://tailwindcss.com/docs/overscroll-behavior
        ##
        "overscroll-x" => [{ "overscroll-x" => OVERSCROLL.call }],
        ##
        # Overscroll Behavior Y
        # @see https://tailwindcss.com/docs/overscroll-behavior
        ##
        "overscroll-y" => [{ "overscroll-y" => OVERSCROLL.call }],
        ##
        # Position
        # @see https://tailwindcss.com/docs/position
        ##
        "position" => ["static", "fixed", "absolute", "relative", "sticky"],
        ##
        # Top / Right / Bottom / Left
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        ##
        "inset" => [{ "inset" => [INSET] }],
        ##
        # Right / Left
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        ##
        "inset-x" => [{ "inset-x" => [INSET] }],
        ##
        # Top / Bottom
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        ##
        "inset-y" => [{ "inset-y" => [INSET] }],
        ##
        # Top
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        ##
        "top" => [{ "top" => [INSET] }],
        ##
        # Right
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        ##
        "right" => [{ "right" => [INSET] }],
        ##
        # Bottom
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        ##
        "bottom" => [{ "bottom" => [INSET] }],
        ##
        # Left
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        ##
        "left" => [{ "left" => [INSET] }],
        ##
        # Visibility
        # @see https://tailwindcss.com/docs/visibility
        ##
        "visibility" => ["visible", "invisible", "collapse"],
        ##
        # Z-Index
        # @see https://tailwindcss.com/docs/z-index
        ##
        "z" => [{ "z" => [IS_INTEGER] }],
        # Flexbox and Grid
        ##
        # Flex Basis
        # @see https://tailwindcss.com/docs/flex-basis
        ##
        "basis" => [{ "basis" => [SPACING] }],
        ##
        # Flex Direction
        # @see https://tailwindcss.com/docs/flex-direction
        ##
        "flex-direction" => [{ "flex" => ["row", "row-reverse", "col", "col-reverse"] }],
        ##
        # Flex Wrap
        # @see https://tailwindcss.com/docs/flex-wrap
        ##
        "flex-wrap" => [{ "flex" => ["wrap", "wrap-reverse", "nowrap"] }],
        ##
        # Flex
        # @see https://tailwindcss.com/docs/flex
        ##
        "flex" => [{ "flex" => ["1", "auto", "initial", "none", IS_ARBITRARY_VALUE] }],
        ##
        # Flex Grow
        # @see https://tailwindcss.com/docs/flex-grow
        ##
        "grow" => [{ "grow" => ZERO_AND_EMPTY.call }],
        ##
        # Flex Shrink
        # @see https://tailwindcss.com/docs/flex-shrink
        ##
        "shrink" => [{ "shrink" => ZERO_AND_EMPTY.call }],
        ##
        # Order
        # @see https://tailwindcss.com/docs/order
        ##
        "order" => [{ "order" => ["first", "last", "none", IS_INTEGER] }],
        ##
        # Grid Template Columns
        # @see https://tailwindcss.com/docs/grid-template-columns
        ##
        "grid-cols" => [{ "grid-cols" => [IS_ANY] }],
        ##
        # Grid Column Start / End
        # @see https://tailwindcss.com/docs/grid-column
        ##
        "col-start-end" => [{ "col" => ["auto", { "span" => [IS_INTEGER] }] }],
        ##
        # Grid Column Start
        # @see https://tailwindcss.com/docs/grid-column
        ##
        "col-start" => [{ "col-start" => INTEGER_WITH_AUTO.call }],
        ##
        # Grid Column End
        # @see https://tailwindcss.com/docs/grid-column
        ##
        "col-end" => [{ "col-end" => INTEGER_WITH_AUTO.call }],
        ##
        # Grid Template Rows
        # @see https://tailwindcss.com/docs/grid-template-rows
        ##
        "grid-rows" => [{ "grid-rows" => [IS_ANY] }],
        ##
        # Grid Row Start / End
        # @see https://tailwindcss.com/docs/grid-row
        ##
        "row-start-end" => [{ "row" => ["auto", { "span" => [IS_INTEGER] }] }],
        ##
        # Grid Row Start
        # @see https://tailwindcss.com/docs/grid-row
        ##
        "row-start" => [{ "row-start" => INTEGER_WITH_AUTO.call }],
        ##
        # Grid Row End
        # @see https://tailwindcss.com/docs/grid-row
        ##
        "row-end" => [{ "row-end" => INTEGER_WITH_AUTO.call }],
        ##
        # Grid Auto Flow
        # @see https://tailwindcss.com/docs/grid-auto-flow
        ##
        "grid-flow" => [{ "grid-flow" => ["row", "col", "dense", "row-dense", "col-dense"] }],
        ##
        # Grid Auto Columns
        # @see https://tailwindcss.com/docs/grid-auto-columns
        ##
        "auto-cols" => [{ "auto-cols" => ["auto", "min", "max", "fr", IS_ARBITRARY_VALUE] }],
        ##
        # Grid Auto Rows
        # @see https://tailwindcss.com/docs/grid-auto-rows
        ##
        "auto-rows" => [{ "auto-rows" => ["auto", "min", "max", "fr", IS_ARBITRARY_VALUE] }],
        ##
        # Gap
        # @see https://tailwindcss.com/docs/gap
        ##
        "gap" => [{ "gap" => [GAP] }],
        ##
        # Gap X
        # @see https://tailwindcss.com/docs/gap
        ##
        "gap-x" => [{ "gap-x" => [GAP] }],
        ##
        # Gap Y
        # @see https://tailwindcss.com/docs/gap
        ##
        "gap-y" => [{ "gap-y" => [GAP] }],
        ##
        # Justify Content
        # @see https://tailwindcss.com/docs/justify-content
        ##
        "justify-content" => [{ "justify" => ALIGN.call }],
        ##
        # Justify Items
        # @see https://tailwindcss.com/docs/justify-items
        ##
        "justify-items" => [{ "justify-items" => ["start", "end", "center", "stretch"] }],
        ##
        # Justify Self
        # @see https://tailwindcss.com/docs/justify-self
        ##
        "justify-self" => [{ "justify-self" => ["auto", "start", "end", "center", "stretch"] }],
        ##
        # Align Content
        # @see https://tailwindcss.com/docs/align-content
        ##
        "align-content" => [{ content: [*ALIGN.call, "baseline"] }],
        ##
        # Align Items
        # @see https://tailwindcss.com/docs/align-items
        ##
        "align-items" => [{ "items" => ["start", "end", "center", "baseline", "stretch"] }],
        ##
        # Align Self
        # @see https://tailwindcss.com/docs/align-self
        ##
        "align-self" => [{ "self" => ["auto", "start", "end", "center", "stretch", "baseline"] }],
        ##
        # Place Content
        # @see https://tailwindcss.com/docs/place-content
        ##
        "place-content" => [{ "place-content" => [*ALIGN.call, "baseline", "stretch"] }],
        ##
        # Place Items
        # @see https://tailwindcss.com/docs/place-items
        ##
        "place-items" => [{ "place-items" => ["start", "end", "center", "baseline", "stretch"] }],
        ##
        # Place Self
        # @see https://tailwindcss.com/docs/place-self
        ##
        "place-self" => [{ "place-self" => ["auto", "start", "end", "center", "stretch"] }],
        # Spacing
        ##
        # Padding
        # @see https://tailwindcss.com/docs/padding
        ##
        "p" => [{ "p" => [PADDING] }],
        ##
        # Padding X
        # @see https://tailwindcss.com/docs/padding
        ##
        "px" => [{ "px" => [PADDING] }],
        ##
        # Padding Y
        # @see https://tailwindcss.com/docs/padding
        ##
        "py" => [{ "py" => [PADDING] }],
        ##
        # Padding Top
        # @see https://tailwindcss.com/docs/padding
        ##
        "pt" => [{ "pt" => [PADDING] }],
        ##
        # Padding Right
        # @see https://tailwindcss.com/docs/padding
        ##
        "pr" => [{ "pr" => [PADDING] }],
        ##
        # Padding Bottom
        # @see https://tailwindcss.com/docs/padding
        ##
        "pb" => [{ "pb" => [PADDING] }],
        ##
        # Padding Left
        # @see https://tailwindcss.com/docs/padding
        ##
        "pl" => [{ "pl" => [PADDING] }],
        ##
        # Margin
        # @see https://tailwindcss.com/docs/margin
        ##
        "m" => [{ "m" => [MARGIN] }],
        ##
        # Margin X
        # @see https://tailwindcss.com/docs/margin
        ##
        "mx" => [{ "mx" => [MARGIN] }],
        ##
        # Margin Y
        # @see https://tailwindcss.com/docs/margin
        ##
        "my" => [{ "my" => [MARGIN] }],
        ##
        # Margin Top
        # @see https://tailwindcss.com/docs/margin
        ##
        "mt" => [{ "mt" => [MARGIN] }],
        ##
        # Margin Right
        # @see https://tailwindcss.com/docs/margin
        ##
        "mr" => [{ "mr" => [MARGIN] }],
        ##
        # Margin Bottom
        # @see https://tailwindcss.com/docs/margin
        ##
        "mb" => [{ "mb" => [MARGIN] }],
        ##
        # Margin Left
        # @see https://tailwindcss.com/docs/margin
        ##
        "ml" => [{ "ml" => [MARGIN] }],
        ##
        # Space Between X
        # @see https://tailwindcss.com/docs/space
        ##
        "space-x" => [{ "space-x" => [SPACE] }],
        ##
        # Space Between X Reverse
        # @see https://tailwindcss.com/docs/space
        ##
        "space-x-reverse" => ["space-x-reverse"],
        ##
        # Space Between Y
        # @see https://tailwindcss.com/docs/space
        ##
        "space-y" => [{ "space-y" => [SPACE] }],
        ##
        # Space Between Y Reverse
        # @see https://tailwindcss.com/docs/space
        ##
        "space-y-reverse" => ["space-y-reverse"],
        # Sizing
        ##
        # Width
        # @see https://tailwindcss.com/docs/width
        ##
        "w" => [{ "w" => ["auto", "min", "max", "fit", SPACING] }],
        ##
        # Min-Width
        # @see https://tailwindcss.com/docs/min-width
        ##
        "min-w" => [{ "min-w" => ["min", "max", "fit", IS_LENGTH] }],
        ##
        # Max-Width
        # @see https://tailwindcss.com/docs/max-width
        ##
        "max-w" => [
          {
            "max-w" => [
              "0",
              "none",
              "full",
              "min",
              "max",
              "fit",
              "prose",
              { "screen" => [IS_TSHIRT_SIZE] },
              IS_TSHIRT_SIZE,
              IS_ARBITRARY_LENGTH,
            ],
          },
        ],
        ##
        # Height
        # @see https://tailwindcss.com/docs/height
        ##
        "h" => [{ "h" => ["auto", "min", "max", "fit", SPACING] }],
        ##
        # Min-Height
        # @see https://tailwindcss.com/docs/min-height
        ##
        "min-h" => [{ "min-h" => ["min", "max", "fit", IS_LENGTH] }],
        ##
        # Max-Height
        # @see https://tailwindcss.com/docs/max-height
        ##
        "max-h" => [{ "max-h" => [SPACING, "min", "max", "fit"] }],
        # Typography
        ##
        # Font Size
        # @see https://tailwindcss.com/docs/font-size
        ##
        "font-size" => [{ "text" => ["base", IS_TSHIRT_SIZE, IS_ARBITRARY_LENGTH] }],
        ##
        # Font Smoothing
        # @see https://tailwindcss.com/docs/font-smoothing
        ##
        "font-smoothing" => ["antialiased", "subpixel-antialiased"],
        ##
        # Font Style
        # @see https://tailwindcss.com/docs/font-style
        ##
        "font-style" => ["italic", "not-italic"],
        ##
        # Font Weight
        # @see https://tailwindcss.com/docs/font-weight
        ##
        "font-weight" => [
          {
            "font" => [
              "thin",
              "extralight",
              "light",
              "normal",
              "medium",
              "semibold",
              "bold",
              "extrabold",
              "black",
              IS_ARBITRARY_NUMBER,
            ],
          },
        ],
        ##
        # Font Family
        # @see https://tailwindcss.com/docs/font-family
        ##
        "font-family" => [{ "font" => [IS_ANY] }],
        ##
        # Font Variant Numeric
        # @see https://tailwindcss.com/docs/font-variant-numeric
        ##
        "fvn-normal" => ["normal-nums"],
        ##
        # Font Variant Numeric
        # @see https://tailwindcss.com/docs/font-variant-numeric
        ##
        "fvn-ordinal" => ["ordinal"],
        ##
        # Font Variant Numeric
        # @see https://tailwindcss.com/docs/font-variant-numeric
        ##
        "fvn-slashed-zero" => ["slashed-zero"],
        ##
        # Font Variant Numeric
        # @see https://tailwindcss.com/docs/font-variant-numeric
        ##
        "fvn-figure" => ["lining-nums", "oldstyle-nums"],
        ##
        # Font Variant Numeric
        # @see https://tailwindcss.com/docs/font-variant-numeric
        ##
        "fvn-spacing" => ["proportional-nums", "tabular-nums"],
        ##
        # Font Variant Numeric
        # @see https://tailwindcss.com/docs/font-variant-numeric
        ##
        "fvn-fraction" => ["diagonal-fractions", "stacked-fractons"],
        ##
        # Letter Spacing
        # @see https://tailwindcss.com/docs/letter-spacing
        ##
        "tracking" => [
          {
            "tracking" => [
              "tighter",
              "tight",
              "normal",
              "wide",
              "wider",
              "widest",
              IS_ARBITRARY_LENGTH,
            ],
          },
        ],
        ##
        # Line Height
        # @see https://tailwindcss.com/docs/line-height
        ##
        "leading" => [
          { "leading" => ["none", "tight", "snug", "normal", "relaxed", "loose", IS_LENGTH] },
        ],
        ##
        # List Style Type
        # @see https://tailwindcss.com/docs/list-style-type
        ##
        "list-style-type" => [{ "list" => ["none", "disc", "decimal", IS_ARBITRARY_VALUE] }],
        ##
        # List Style Position
        # @see https://tailwindcss.com/docs/list-style-position
        ##
        "list-style-position" => [{ "list" => ["inside", "outside"] }],
        ##
        # Placeholder Color
        # @deprecated since Tailwind CSS v3.0.0
        # @see https://tailwindcss.com/docs/placeholder-color
        ##
        "placeholder-color" => [{ "placeholder" => [COLORS] }],
        ##
        # Placeholder Opacity
        # @see https://tailwindcss.com/docs/placeholder-opacity
        ##
        "placeholder-opacity" => [{ "placeholder-opacity" => [OPACITY] }],
        ##
        # Text Alignment
        # @see https://tailwindcss.com/docs/text-align
        ##
        "text-alignment" => [{ "text" => ["left", "center", "right", "justify", "start", "end"] }],
        ##
        # Text Color
        # @see https://tailwindcss.com/docs/text-color
        ##
        "text-color" => [{ "text" => [COLORS] }],
        ##
        # Text Opacity
        # @see https://tailwindcss.com/docs/text-opacity
        ##
        "text-opacity" => [{ "text-opacity" => [OPACITY] }],
        ##
        # Text Decoration
        # @see https://tailwindcss.com/docs/text-decoration
        ##
        "text-decoration" => ["underline", "overline", "line-through", "no-underline"],
        ##
        # Text Decoration Style
        # @see https://tailwindcss.com/docs/text-decoration-style
        ##
        "text-decoration-style" => [{ "decoration" => [*LINE_STYLES.call, "wavy"] }],
        ##
        # Text Decoration Thickness
        # @see https://tailwindcss.com/docs/text-decoration-thickness
        ##
        "text-decoration-thickness" => [{ "decoration" => ["auto", "from-font", IS_LENGTH] }],
        ##
        # Text Underline Offset
        # @see https://tailwindcss.com/docs/text-underline-offset
        ##
        "underline-offset" => [{ "underline-offset" => ["auto", IS_LENGTH] }],
        ##
        # Text Decoration Color
        # @see https://tailwindcss.com/docs/text-decoration-color
        ##
        "text-decoration-color" => [{ "decoration" => [COLORS] }],
        ##
        # Text Transform
        # @see https://tailwindcss.com/docs/text-transform
        ##
        "text-transform" => ["uppercase", "lowercase", "capitalize", "normal-case"],
        ##
        # Text Overflow
        # @see https://tailwindcss.com/docs/text-overflow
        ##
        "text-overflow" => ["truncate", "text-ellipsis", "text-clip"],
        ##
        # Text Indent
        # @see https://tailwindcss.com/docs/text-indent
        ##
        "indent" => [{ "indent" => [SPACING] }],
        ##
        # Vertical Alignment
        # @see https://tailwindcss.com/docs/vertical-align
        ##
        "vertical-align" => [
          {
            "align" => [
              "baseline",
              "top",
              "middle",
              "bottom",
              "text-top",
              "text-bottom",
              "sub",
              "super",
              IS_ARBITRARY_LENGTH,
            ],
          },
        ],
        ##
        # Whitespace
        # @see https://tailwindcss.com/docs/whitespace
        ##
        "whitespace" => [{ "whitespace" => ["normal", "nowrap", "pre", "pre-line", "pre-wrap"] }],
        ##
        # Word Break
        # @see https://tailwindcss.com/docs/word-break
        ##
        "break" => [{ "break" => ["normal", "words", "all", "keep"] }],
        ##
        # Content
        # @see https://tailwindcss.com/docs/content
        ##
        "content" => [{ "content" => ["none", IS_ARBITRARY_VALUE] }],
        # Backgrounds
        ##
        # Background Attachment
        # @see https://tailwindcss.com/docs/background-attachment
        ##
        "bg-attachment" => [{ "bg" => ["fixed", "local", "scroll"] }],
        ##
        # Background Clip
        # @see https://tailwindcss.com/docs/background-clip
        ##
        "bg-clip" => [{ "bg-clip" => ["border", "padding", "content", "text"] }],
        ##
        # Background Opacity
        # @deprecated since Tailwind CSS v3.0.0
        # @see https://tailwindcss.com/docs/background-opacity
        ##
        "bg-opacity" => [{ "bg-opacity" => [OPACITY] }],
        ##
        # Background Origin
        # @see https://tailwindcss.com/docs/background-origin
        ##
        "bg-origin" => [{ "bg-origin" => ["border", "padding", "content"] }],
        ##
        # Background Position
        # @see https://tailwindcss.com/docs/background-position
        ##
        "bg-position" => [{ "bg" => [*POSITIONS.call, IS_ARBITRARY_POSITION] }],
        ##
        # Background Repeat
        # @see https://tailwindcss.com/docs/background-repeat
        ##
        "bg-repeat" => [{ "bg" => ["no-repeat", { "repeat" => ["", "x", "y", "round", "space"] }] }],
        ##
        # Background Size
        # @see https://tailwindcss.com/docs/background-size
        ##
        "bg-size" => [{ "bg" => ["auto", "cover", "contain", IS_ARBITRARY_SIZE] }],
        ##
        # Background Image
        # @see https://tailwindcss.com/docs/background-image
        ##
        "bg-image" => [
          {
            "bg" => [
              "none",
              { "gradient-to" => ["t", "tr", "r", "br", "b", "bl", "l", "tl"] },
              IS_ARBITRARY_URL,
            ],
          },
        ],
        ##
        # Background Color
        # @see https://tailwindcss.com/docs/background-color
        ##
        "bg-color" => [{ "bg" => [COLORS] }],
        ##
        # Gradient Color Stops From
        # @see https://tailwindcss.com/docs/gradient-color-stops
        ##
        "gradient-from" => [{ "from" => [GRADIENT_COLOR_STOPS] }],
        ##
        # Gradient Color Stops Via
        # @see https://tailwindcss.com/docs/gradient-color-stops
        ##
        "gradient-via" => [{ "via" => [GRADIENT_COLOR_STOPS] }],
        ##
        # Gradient Color Stops To
        # @see https://tailwindcss.com/docs/gradient-color-stops
        ##
        "gradient-to" => [{ "to" => [GRADIENT_COLOR_STOPS] }],
        # Borders
        ##
        # Border Radius
        # @see https://tailwindcss.com/docs/border-radius
        ##
        "rounded" => [{ "rounded" => [BORDER_RADIUS] }],
        ##
        # Border Radius Top
        # @see https://tailwindcss.com/docs/border-radius
        ##
        "rounded-t" => [{ "rounded-t" => [BORDER_RADIUS] }],
        ##
        # Border Radius Right
        # @see https://tailwindcss.com/docs/border-radius
        ##
        "rounded-r" => [{ "rounded-r" => [BORDER_RADIUS] }],
        ##
        # Border Radius Bottom
        # @see https://tailwindcss.com/docs/border-radius
        ##
        "rounded-b" => [{ "rounded-b" => [BORDER_RADIUS] }],
        ##
        # Border Radius Left
        # @see https://tailwindcss.com/docs/border-radius
        ##
        "rounded-l" => [{ "rounded-l" => [BORDER_RADIUS] }],
        ##
        # Border Radius Top Left
        # @see https://tailwindcss.com/docs/border-radius
        ##
        "rounded-tl" => [{ "rounded-tl" => [BORDER_RADIUS] }],
        ##
        # Border Radius Top Right
        # @see https://tailwindcss.com/docs/border-radius
        ##
        "rounded-tr" => [{ "rounded-tr" => [BORDER_RADIUS] }],
        ##
        # Border Radius Bottom Right
        # @see https://tailwindcss.com/docs/border-radius
        ##
        "rounded-br" => [{ "rounded-br" => [BORDER_RADIUS] }],
        ##
        # Border Radius Bottom Left
        # @see https://tailwindcss.com/docs/border-radius
        ##
        "rounded-bl" => [{ "rounded-bl" => [BORDER_RADIUS] }],
        ##
        # Border Width
        # @see https://tailwindcss.com/docs/border-width
        ##
        "border-w" => [{ "border" => [BORDER_WIDTH] }],
        ##
        # Border Width X
        # @see https://tailwindcss.com/docs/border-width
        ##
        "border-w-x" => [{ "border-x" => [BORDER_WIDTH] }],
        ##
        # Border Width Y
        # @see https://tailwindcss.com/docs/border-width
        ##
        "border-w-y" => [{ "border-y" => [BORDER_WIDTH] }],
        ##
        # Border Width Top
        # @see https://tailwindcss.com/docs/border-width
        ##
        "border-w-t" => [{ "border-t" => [BORDER_WIDTH] }],
        ##
        # Border Width Right
        # @see https://tailwindcss.com/docs/border-width
        ##
        "border-w-r" => [{ "border-r" => [BORDER_WIDTH] }],
        ##
        # Border Width Bottom
        # @see https://tailwindcss.com/docs/border-width
        ##
        "border-w-b" => [{ "border-b" => [BORDER_WIDTH] }],
        ##
        # Border Width Left
        # @see https://tailwindcss.com/docs/border-width
        ##
        "border-w-l" => [{ "border-l" => [BORDER_WIDTH] }],
        ##
        # Border Opacity
        # @see https://tailwindcss.com/docs/border-opacity
        ##
        "border-opacity" => [{ "border-opacity" => [OPACITY] }],
        ##
        # Border Style
        # @see https://tailwindcss.com/docs/border-style
        ##
        "border-style" => [{ "border" => [*LINE_STYLES.call, "hidden"] }],
        ##
        # Divide Width X
        # @see https://tailwindcss.com/docs/divide-width
        ##
        "divide-x" => [{ "divide-x" => [BORDER_WIDTH] }],
        ##
        # Divide Width X Reverse
        # @see https://tailwindcss.com/docs/divide-width
        ##
        "divide-x-reverse" => ["divide-x-reverse"],
        ##
        # Divide Width Y
        # @see https://tailwindcss.com/docs/divide-width
        ##
        "divide-y" => [{ "divide-y" => [BORDER_WIDTH] }],
        ##
        # Divide Width Y Reverse
        # @see https://tailwindcss.com/docs/divide-width
        ##
        "divide-y-reverse" => ["divide-y-reverse"],
        ##
        # Divide Opacity
        # @see https://tailwindcss.com/docs/divide-opacity
        ##
        "divide-opacity" => [{ "divide-opacity" => [OPACITY] }],
        ##
        # Divide Style
        # @see https://tailwindcss.com/docs/divide-style
        ##
        "divide-style" => [{ "divide" => LINE_STYLES.call }],
        ##
        # Border Color
        # @see https://tailwindcss.com/docs/border-color
        ##
        "border-color" => [{ "border" => [BORDER_COLOR] }],
        ##
        # Border Color X
        # @see https://tailwindcss.com/docs/border-color
        ##
        "border-color-x" => [{ "border-x" => [BORDER_COLOR] }],
        ##
        # Border Color Y
        # @see https://tailwindcss.com/docs/border-color
        ##
        "border-color-y" => [{ "border-y" => [BORDER_COLOR] }],
        ##
        # Border Color Top
        # @see https://tailwindcss.com/docs/border-color
        ##
        "border-color-t" => [{ "border-t" => [BORDER_COLOR] }],
        ##
        # Border Color Right
        # @see https://tailwindcss.com/docs/border-color
        ##
        "border-color-r" => [{ "border-r" => [BORDER_COLOR] }],
        ##
        # Border Color Bottom
        # @see https://tailwindcss.com/docs/border-color
        ##
        "border-color-b" => [{ "border-b" => [BORDER_COLOR] }],
        ##
        # Border Color Left
        # @see https://tailwindcss.com/docs/border-color
        ##
        "border-color-l" => [{ "border-l" => [BORDER_COLOR] }],
        ##
        # Divide Color
        # @see https://tailwindcss.com/docs/divide-color
        ##
        "divide-color" => [{ "divide" => [BORDER_COLOR] }],
        ##
        # Outline Style
        # @see https://tailwindcss.com/docs/outline-style
        ##
        "outline-style" => [{ "outline" => ["", *LINE_STYLES.call] }],
        ##
        # Outline Offset
        # @see https://tailwindcss.com/docs/outline-offset
        ##
        "outline-offset" => [{ "outline-offset" => [IS_LENGTH] }],
        ##
        # Outline Width
        # @see https://tailwindcss.com/docs/outline-width
        ##
        "outline-w" => [{ "outline" => [IS_LENGTH] }],
        ##
        # Outline Color
        # @see https://tailwindcss.com/docs/outline-color
        ##
        "outline-color" => [{ "outline" => [COLORS] }],
        ##
        # Ring Width
        # @see https://tailwindcss.com/docs/ring-width
        ##
        "ring-w" => [{ "ring" => LENGTH_WITH_EMPTY.call }],
        ##
        # Ring Width Inset
        # @see https://tailwindcss.com/docs/ring-width
        ##
        "ring-w-inset" => ["ring-inset"],
        ##
        # Ring Color
        # @see https://tailwindcss.com/docs/ring-color
        ##
        "ring-color" => [{ "ring" => [COLORS] }],
        ##
        # Ring Opacity
        # @see https://tailwindcss.com/docs/ring-opacity
        ##
        "ring-opacity" => [{ "ring-opacity" => [OPACITY] }],
        ##
        # Ring Offset Width
        # @see https://tailwindcss.com/docs/ring-offset-width
        ##
        "ring-offset-w" => [{ "ring-offset" => [IS_LENGTH] }],
        ##
        # Ring Offset Color
        # @see https://tailwindcss.com/docs/ring-offset-color
        ##
        "ring-offset-color" => [{ "ring-offset" => [COLORS] }],
        # Effects
        ##
        # Box Shadow
        # @see https://tailwindcss.com/docs/box-shadow
        ##
        "shadow" => [{ "shadow" => ["", "inner", "none", IS_TSHIRT_SIZE, IS_ARBITRARY_SHADOW] }],
        ##
        # Box Shadow Color
        # @see https://tailwindcss.com/docs/box-shadow-color
        ##
        "shadow-color" => [{ "shadow" => [IS_ANY] }],
        ##
        # Opacity
        # @see https://tailwindcss.com/docs/opacity
        ##
        "opacity" => [{ "opacity" => [OPACITY] }],
        ##
        # Mix Blend Mode
        # @see https://tailwindcss.com/docs/mix-blend-mode
        ##
        "mix-blend" => [{ "mix-blend" => BLEND_MODES.call }],
        ##
        # Background Blend Mode
        # @see https://tailwindcss.com/docs/background-blend-mode
        ##
        "bg-blend" => [{ "bg-blend" => BLEND_MODES.call }],
        # Filters
        ##
        # Filter
        # @deprecated since Tailwind CSS v3.0.0
        # @see https://tailwindcss.com/docs/filter
        ##
        "filter" => [{ "filter" => ["", "none"] }],
        ##
        # Blur
        # @see https://tailwindcss.com/docs/blur
        ##
        "blur" => [{ "blur" => [BLUR] }],
        ##
        # Brightness
        # @see https://tailwindcss.com/docs/brightness
        ##
        "brightness" => [{ "brightness" => [BRIGHTNESS] }],
        ##
        # Contrast
        # @see https://tailwindcss.com/docs/contrast
        ##
        "contrast" => [{ "contrast" => [CONTRAST] }],
        ##
        # Drop Shadow
        # @see https://tailwindcss.com/docs/drop-shadow
        ##
        "drop-shadow" => [{ "drop-shadow" => ["", "none", IS_TSHIRT_SIZE, IS_ARBITRARY_VALUE] }],
        ##
        # Grayscale
        # @see https://tailwindcss.com/docs/grayscale
        ##
        "grayscale" => [{ "grayscale" => [GRAYSCALE] }],
        ##
        # Hue Rotate
        # @see https://tailwindcss.com/docs/hue-rotate
        ##
        "hue-rotate" => [{ "hue-rotate" => [HUE_ROTATE] }],
        ##
        # Invert
        # @see https://tailwindcss.com/docs/invert
        ##
        "invert" => [{ "invert" => [INVERT] }],
        ##
        # Saturate
        # @see https://tailwindcss.com/docs/saturate
        ##
        "saturate" => [{ "saturate" => [SATURATE] }],
        ##
        # Sepia
        # @see https://tailwindcss.com/docs/sepia
        ##
        "sepia" => [{ "sepia" => [SEPIA] }],
        ##
        # Backdrop Filter
        # @deprecated since Tailwind CSS v3.0.0
        # @see https://tailwindcss.com/docs/backdrop-filter
        ##
        "backdrop-filter" => [{ "backdrop-filter" => ["", "none"] }],
        ##
        # Backdrop Blur
        # @see https://tailwindcss.com/docs/backdrop-blur
        ##
        "backdrop-blur" => [{ "backdrop-blur" => [BLUR] }],
        ##
        # Backdrop Brightness
        # @see https://tailwindcss.com/docs/backdrop-brightness
        ##
        "backdrop-brightness" => [{ "backdrop-brightness" => [BRIGHTNESS] }],
        ##
        # Backdrop Contrast
        # @see https://tailwindcss.com/docs/backdrop-contrast
        ##
        "backdrop-contrast" => [{ "backdrop-contrast" => [CONTRAST] }],
        ##
        # Backdrop Grayscale
        # @see https://tailwindcss.com/docs/backdrop-grayscale
        ##
        "backdrop-grayscale" => [{ "backdrop-grayscale" => [GRAYSCALE] }],
        ##
        # Backdrop Hue Rotate
        # @see https://tailwindcss.com/docs/backdrop-hue-rotate
        ##
        "backdrop-hue-rotate" => [{ "backdrop-hue-rotate" => [HUE_ROTATE] }],
        ##
        # Backdrop Invert
        # @see https://tailwindcss.com/docs/backdrop-invert
        ##
        "backdrop-invert" => [{ "backdrop-invert" => [INVERT] }],
        ##
        # Backdrop Opacity
        # @see https://tailwindcss.com/docs/backdrop-opacity
        ##
        "backdrop-opacity" => [{ "backdrop-opacity" => [OPACITY] }],
        ##
        # Backdrop Saturate
        # @see https://tailwindcss.com/docs/backdrop-saturate
        ##
        "backdrop-saturate" => [{ "backdrop-saturate" => [SATURATE] }],
        ##
        # Backdrop Sepia
        # @see https://tailwindcss.com/docs/backdrop-sepia
        ##
        "backdrop-sepia" => [{ "backdrop-sepia" => [SEPIA] }],
        # Tables
        ##
        # Border Collapse
        # @see https://tailwindcss.com/docs/border-collapse
        ##
        "border-collapse" => [{ "border" => ["collapse", "separate"] }],
        ##
        # Border Spacing
        # @see https://tailwindcss.com/docs/border-spacing
        ##
        "border-spacing" => [{ "border-spacing" => [BORDER_SPACING] }],
        ##
        # Border Spacing X
        # @see https://tailwindcss.com/docs/border-spacing
        ##
        "border-spacing-x" => [{ "border-spacing-x" => [BORDER_SPACING] }],
        ##
        # Border Spacing Y
        # @see https://tailwindcss.com/docs/border-spacing
        ##
        "border-spacing-y" => [{ "border-spacing-y" => [BORDER_SPACING] }],
        ##
        # Table Layout
        # @see https://tailwindcss.com/docs/table-layout
        ##
        "table-layout" => [{ "table" => ["auto", "fixed"] }],
        # Transitions and Animation
        ##
        # Tranisition Property
        # @see https://tailwindcss.com/docs/transition-property
        ##
        "transition" => [
          {
            "transition" => [
              "none",
              "all",
              "",
              "colors",
              "opacity",
              "shadow",
              "transform",
              IS_ARBITRARY_VALUE,
            ],
          },
        ],
        ##
        # Transition Duration
        # @see https://tailwindcss.com/docs/transition-duration
        ##
        "duration" => [{ "duration" => [IS_INTEGER] }],
        ##
        # Transition Timing Function
        # @see https://tailwindcss.com/docs/transition-timing-function
        ##
        "ease" => [{ "ease" => ["linear", "in", "out", "in-out", IS_ARBITRARY_VALUE] }],
        ##
        # Transition Delay
        # @see https://tailwindcss.com/docs/transition-delay
        ##
        "delay" => [{ "delay" => [IS_INTEGER] }],
        ##
        # Animation
        # @see https://tailwindcss.com/docs/animation
        ##
        "animate" => [{ "animate" => ["none", "spin", "ping", "pulse", "bounce", IS_ARBITRARY_VALUE] }],
        # Transforms
        ##
        # Transform
        # @see https://tailwindcss.com/docs/transform
        ##
        "transform" => [{ "transform" => ["", "gpu", "none"] }],
        ##
        # Scale
        # @see https://tailwindcss.com/docs/scale
        ##
        "scale" => [{ "scale" => [SCALE] }],
        ##
        # Scale X
        # @see https://tailwindcss.com/docs/scale
        ##
        "scale-x" => [{ "scale-x" => [SCALE] }],
        ##
        # Scale Y
        # @see https://tailwindcss.com/docs/scale
        ##
        "scale-y" => [{ "scale-y" => [SCALE] }],
        ##
        # Rotate
        # @see https://tailwindcss.com/docs/rotate
        ##
        "rotate" => [{ "rotate" => [IS_INTEGER, IS_ARBITRARY_VALUE] }],
        ##
        # Translate X
        # @see https://tailwindcss.com/docs/translate
        ##
        "translate-x" => [{ "translate-x" => [TRANSLATE] }],
        ##
        # Translate Y
        # @see https://tailwindcss.com/docs/translate
        ##
        "translate-y" => [{ "translate-y" => [TRANSLATE] }],
        ##
        # Skew X
        # @see https://tailwindcss.com/docs/skew
        ##
        "skew-x" => [{ "skew-x" => [SKEW] }],
        ##
        # Skew Y
        # @see https://tailwindcss.com/docs/skew
        ##
        "skew-y" => [{ "skew-y" => [SKEW] }],
        ##
        # Transform Origin
        # @see https://tailwindcss.com/docs/transform-origin
        ##
        "transform-origin" => [
          {
            "origin" => [
              "center",
              "top",
              "top-right",
              "right",
              "bottom-right",
              "bottom",
              "bottom-left",
              "left",
              "top-left",
              IS_ARBITRARY_VALUE,
            ],
          },
        ],
        # Interactivity
        ##
        # Accent Color
        # @see https://tailwindcss.com/docs/accent-color
        ##
        "accent" => [{ "accent" => ["auto", COLORS] }],
        ##
        # Appearance
        # @see https://tailwindcss.com/docs/appearance
        ##
        "appearance" => ["appearance-none"],
        ##
        # Cursor
        # @see https://tailwindcss.com/docs/cursor
        ##
        "cursor" => [
          {
            "cursor" => [
              "auto",
              "default",
              "pointer",
              "wait",
              "text",
              "move",
              "help",
              "not-allowed",
              "none",
              "context-menu",
              "progress",
              "cell",
              "crosshair",
              "vertical-text",
              "alias",
              "copy",
              "no-drop",
              "grab",
              "grabbing",
              "all-scroll",
              "col-resize",
              "row-resize",
              "n-resize",
              "e-resize",
              "s-resize",
              "w-resize",
              "ne-resize",
              "nw-resize",
              "se-resize",
              "sw-resize",
              "ew-resize",
              "ns-resize",
              "nesw-resize",
              "nwse-resize",
              "zoom-in",
              "zoom-out",
              IS_ARBITRARY_VALUE,
            ],
          },
        ],
        ##
        # Caret Color
        # @see https://tailwindcss.com/docs/just-in-time-mode#caret-color-utilities
        ##
        "caret-color" => [{ "caret" => [COLORS] }],
        ##
        # Pointer Events
        # @see https://tailwindcss.com/docs/pointer-events
        ##
        "pointer-events" => [{ "pointer-events" => ["none", "auto"] }],
        ##
        # Resize
        # @see https://tailwindcss.com/docs/resize
        ##
        "resize" => [{ "resize" => ["none", "y", "x", ""] }],
        ##
        # Scroll Behavior
        # @see https://tailwindcss.com/docs/scroll-behavior
        ##
        "scroll-behavior" => [{ "scroll" => ["auto", "smooth"] }],
        ##
        # Scroll Margin
        # @see https://tailwindcss.com/docs/scroll-margin
        ##
        "scroll-m" => [{ "scroll-m" => [SPACING] }],
        ##
        # Scroll Margin X
        # @see https://tailwindcss.com/docs/scroll-margin
        ##
        "scroll-mx" => [{ "scroll-mx" => [SPACING] }],
        ##
        # Scroll Margin Y
        # @see https://tailwindcss.com/docs/scroll-margin
        ##
        "scroll-my" => [{ "scroll-my" => [SPACING] }],
        ##
        # Scroll Margin Top
        # @see https://tailwindcss.com/docs/scroll-margin
        ##
        "scroll-mt" => [{ "scroll-mt" => [SPACING] }],
        ##
        # Scroll Margin Right
        # @see https://tailwindcss.com/docs/scroll-margin
        ##
        "scroll-mr" => [{ "scroll-mr" => [SPACING] }],
        ##
        # Scroll Margin Bottom
        # @see https://tailwindcss.com/docs/scroll-margin
        ##
        "scroll-mb" => [{ "scroll-mb" => [SPACING] }],
        ##
        # Scroll Margin Left
        # @see https://tailwindcss.com/docs/scroll-margin
        ##
        "scroll-ml" => [{ "scroll-ml" => [SPACING] }],
        ##
        # Scroll Padding
        # @see https://tailwindcss.com/docs/scroll-padding
        ##
        "scroll-p" => [{ "scroll-p" => [SPACING] }],
        ##
        # Scroll Padding X
        # @see https://tailwindcss.com/docs/scroll-padding
        ##
        "scroll-px" => [{ "scroll-px" => [SPACING] }],
        ##
        # Scroll Padding Y
        # @see https://tailwindcss.com/docs/scroll-padding
        ##
        "scroll-py" => [{ "scroll-py" => [SPACING] }],
        ##
        # Scroll Padding Top
        # @see https://tailwindcss.com/docs/scroll-padding
        ##
        "scroll-pt" => [{ "scroll-pt" => [SPACING] }],
        ##
        # Scroll Padding Right
        # @see https://tailwindcss.com/docs/scroll-padding
        ##
        "scroll-pr" => [{ "scroll-pr" => [SPACING] }],
        ##
        # Scroll Padding Bottom
        # @see https://tailwindcss.com/docs/scroll-padding
        ##
        "scroll-pb" => [{ "scroll-pb" => [SPACING] }],
        ##
        # Scroll Padding Left
        # @see https://tailwindcss.com/docs/scroll-padding
        ##
        "scroll-pl" => [{ "scroll-pl" => [SPACING] }],
        ##
        # Scroll Snap Align
        # @see https://tailwindcss.com/docs/scroll-snap-align
        ##
        "snap-align" => [{ "snap" => ["start", "end", "center", "align-none"] }],
        ##
        # Scroll Snap Stop
        # @see https://tailwindcss.com/docs/scroll-snap-stop
        ##
        "snap-stop" => [{ "snap" =>  ["normal", "always"] }],
        ##
        # Scroll Snap Type
        # @see https://tailwindcss.com/docs/scroll-snap-type
        ##
        "snap-type" => [{ "snap" =>  ["none", "x", "y", "both"] }],
        ##
        # Scroll Snap Type Strictness
        # @see https://tailwindcss.com/docs/scroll-snap-type
        ##
        "snap-strictness" => [{ "snap" => ["mandatory", "proximity"] }],
        ##
        # Touch Action
        # @see https://tailwindcss.com/docs/touch-action
        ##
        "touch" => [
          {
            "touch" => [
              "auto",
              "none",
              "pinch-zoom",
              "manipulation",
              { "pan" => ["x", "left", "right", "y", "up", "down"] },
            ],
          },
        ],
        ##
        # User Select
        # @see https://tailwindcss.com/docs/user-select
        ##
        "select" => [{ "select" => ["none", "text", "all", "auto"] }],
        ##
        # Will Change
        # @see https://tailwindcss.com/docs/will-change
        ##
        "will-change" => [
          { "will-change" => ["auto", "scroll", "contents", "transform", IS_ARBITRARY_VALUE] },
        ],
        # SVG
        ##
        # Fill
        # @see https://tailwindcss.com/docs/fill
        ##
        "fill" => [{ "fill" => [COLORS, "none"] }],
        ##
        # Stroke Width
        # @see https://tailwindcss.com/docs/stroke-width
        ##
        "stroke-w" => [{ "stroke" => [IS_LENGTH, IS_ARBITRARY_NUMBER] }],
        ##
        # Stroke
        # @see https://tailwindcss.com/docs/stroke
        ##
        "stroke" => [{ "stroke" => [COLORS, "none"] }],
        # Accessibility
        ##
        # Screen Readers
        # @see https://tailwindcss.com/docs/screen-readers
        ##
        "sr" => ["sr-only", "not-sr-only"],
      },
      conflicting_class_groups: {
        "overflow" => ["overflow-x", "overflow-y"],
        "overscroll" => ["overscroll-x", "overscroll-y"],
        "inset" => ["inset-x", "inset-y", "top", "right", "bottom", "left"],
        "inset-x" => ["right", "left"],
        "inset-y" => ["top", "bottom"],
        "flex" => ["basis", "grow", "shrink"],
        "gap" => ["gap-x", "gap-y"],
        "p" => ["px", "py", "pt", "pr", "pb", "pl"],
        "px" => ["pr", "pl"],
        "py" => ["pt", "pb"],
        "m" => ["mx", "my", "mt", "mr", "mb", "ml"],
        "mx" => ["mr", "ml"],
        "my" => ["mt", "mb"],
        "font-size" => ["leading"],
        "fvn-normal" => [
          "fvn-ordinal",
          "fvn-slashed-zero",
          "fvn-figure",
          "fvn-spacing",
          "fvn-fraction",
        ],
        "fvn-ordinal" => ["fvn-normal"],
        "fvn-slashed-zero" => ["fvn-normal"],
        "fvn-figure" => ["fvn-normal"],
        "fvn-spacing" => ["fvn-normal"],
        "fvn-fraction" => ["fvn-normal"],
        "rounded" => [
          "rounded-t",
          "rounded-r",
          "rounded-b",
          "rounded-l",
          "rounded-tl",
          "rounded-tr",
          "rounded-br",
          "rounded-bl",
        ],
        "rounded-t" => ["rounded-tl", "rounded-tr"],
        "rounded-r" => ["rounded-tr", "rounded-br"],
        "rounded-b" => ["rounded-br", "rounded-bl"],
        "rounded-l" => ["rounded-tl", "rounded-bl"],
        "border-spacing" => ["border-spacing-x", "border-spacing-y"],
        "border-w" => ["border-w-t", "border-w-r", "border-w-b", "border-w-l"],
        "border-w-x" => ["border-w-r", "border-w-l"],
        "border-w-y" => ["border-w-t", "border-w-b"],
        "border-color" => [
          "border-color-t",
          "border-color-r",
          "border-color-b",
          "border-color-l",
        ],
        "border-color-x" => ["border-color-r", "border-color-l"],
        "border-color-y" => ["border-color-t", "border-color-b"],
        "scroll-m" => [
          "scroll-mx",
          "scroll-my",
          "scroll-mt",
          "scroll-mr",
          "scroll-mb",
          "scroll-ml",
        ],
        "scroll-mx" => ["scroll-mr", "scroll-ml"],
        "scroll-my" => ["scroll-mt", "scroll-mb"],
        "scroll-p" => [
          "scroll-px",
          "scroll-py",
          "scroll-pt",
          "scroll-pr",
          "scroll-pb",
          "scroll-pl",
        ],
        "scroll-px" => ["scroll-pr", "scroll-pl"],
        "scroll-py" => ["scroll-pt", "scroll-pb"],
      },
    }.freeze

    def merge_configs(extension_config)
      config = TailwindMerge::Config::DEFAULTS
      [:theme].each do |type|
        extension_config.fetch(type, {}).each_pair do |key, value|
          config[type][value] = ->(config) { FROM_THEME.call(config, key) }
        end
      end
      config
    end
  end
end
