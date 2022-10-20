# frozen_string_literal: true

require "test_helper"

class TestArbitraryVariants < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_basic_arbitrary_variants
    assert_equal("[&>*]:line-through", @merger.merge("[&>*]:underline [&>*]:line-through"))
    assert_equal("[&>*]:line-through [&_div]:line-through", @merger.merge("[&>*]:underline [&>*]:line-through [&_div]:line-through"))
    assert_equal("supports-[display:grid]:grid", @merger.merge("supports-[display:grid]:flex supports-[display:grid]:grid"))
  end

  def test_arbitrary_variants_with_modifiers
    assert_equal("dark:lg:hover:[&>*]:line-through", @merger.merge("dark:lg:hover:[&>*]:underline dark:lg:hover:[&>*]:line-through"))
    assert_equal("dark:hover:lg:[&>*]:line-through", @merger.merge("dark:lg:hover:[&>*]:underline dark:hover:lg:[&>*]:line-through"))
    # Whether a modifier is before or after arbitrary variant matters
    assert_equal("hover:[&>*]:underline [&>*]:hover:line-through", @merger.merge("hover:[&>*]:underline [&>*]:hover:line-through"))
    assert_equal("dark:hover:[&>*]:underline dark:[&>*]:hover:line-through", @merger.merge("hover:dark:[&>*]:underline dark:hover:[&>*]:underline dark:[&>*]:hover:line-through"))
  end

  def test_arbitrary_variants_with_complex_syntax_in_them
    assert_equal("[@media_screen{@media(hover:hover)}]:line-through", @merger.merge("[@media_screen{@media(hover:hover)}]:underline [@media_screen{@media(hover:hover)}]:line-through"))
    assert_equal("hover:[@media_screen{@media(hover:hover)}]:line-through", @merger.merge("hover:[@media_screen{@media(hover:hover)}]:underline hover:[@media_screen{@media(hover:hover)}]:line-through"))
  end

  def test_arbitrary_variants_with_attribute_selectors
    assert_equal("[&[data-open]]:line-through", @merger.merge("[&[data-open]]:underline [&[data-open]]:line-through"))
  end

  def test_arbitrary_variants_with_multiple_attribute_selectors
    assert_equal("[&[data-foo][data-bar]:not([data-baz])]:line-through", @merger.merge("[&[data-foo][data-bar]:not([data-baz])]:underline [&[data-foo][data-bar]:not([data-baz])]:line-through"))
  end

  def test_multiple_arbitrary_variants
    assert_equal("[&>*]:[&_div]:line-through", @merger.merge("[&>*]:[&_div]:underline [&>*]:[&_div]:line-through"))
    assert_equal("[&>*]:[&_div]:underline [&_div]:[&>*]:line-through", @merger.merge("[&>*]:[&_div]:underline [&_div]:[&>*]:line-through"))
    assert_equal("dark:hover:[&>*]:disabled:focus:[&_div]:line-through", @merger.merge("hover:dark:[&>*]:focus:disabled:[&_div]:underline dark:hover:[&>*]:disabled:focus:[&_div]:line-through"))
    assert_equal("hover:dark:[&>*]:focus:[&_div]:disabled:underline dark:hover:[&>*]:disabled:focus:[&_div]:line-through", @merger.merge("hover:dark:[&>*]:focus:[&_div]:disabled:underline dark:hover:[&>*]:disabled:focus:[&_div]:line-through"))
  end

  def test_arbitrary_variants_with_arbitrary_properties
    assert_equal("[&>*]:[color:blue]", @merger.merge("[&>*]:[color:red] [&>*]:[color:blue]"))
    assert_equal("[&[data-foo][data-bar]:not([data-baz])]:noa:nod:[color:blue]", @merger.merge("[&[data-foo][data-bar]:not([data-baz])]:nod:noa:[color:red] [&[data-foo][data-bar]:not([data-baz])]:noa:nod:[color:blue]"))
  end
end
