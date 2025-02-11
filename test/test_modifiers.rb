# frozen_string_literal: true

require "test_helper"

class TestModifiers < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_conflicts_across_prefix_modifiers
    assert_equal("hover:inline", @merger.merge("hover:block hover:inline"))
    assert_equal("hover:block hover:focus:inline", @merger.merge("hover:block hover:focus:inline"))
    assert_equal("hover:block focus:hover:inline", @merger.merge("hover:block hover:focus:inline focus:hover:inline"))
    assert_equal("focus-within:block", @merger.merge("focus-within:inline focus-within:block"))
  end

  def test_conflicts_across_postfix_modifiers
    assert_equal("text-lg/8", @merger.merge("text-lg/7 text-lg/8"))
    assert_equal("text-lg/none leading-9", @merger.merge("text-lg/none leading-9"))
    assert_equal("text-lg/none", @merger.merge("leading-9 text-lg/none"))
    assert_equal("w-1/2", @merger.merge("w-full w-1/2"))

    config = {
      cache_size: 10,
      theme: {},
      class_groups: {
        foo: ["foo-1/2", "foo-2/3"],
        bar: ["bar-1", "bar-2"],
        baz: ["baz-1", "baz-2"],
      },
      conflicting_class_groups: {},
      conflicting_class_group_modifiers: {
        baz: ["bar"],
      },
      order_sensitive_modifiers: [],
    }
    custom_merger = TailwindMerge::Merger.new(config:)

    assert_equal("foo-2/3", custom_merger.merge("foo-1/2 foo-2/3"))
    assert_equal("foo-2/3", custom_merger.merge("foo-1/2 foo-2/3"))

    assert_equal("bar-2", custom_merger.merge("bar-1 bar-2"))
    assert_equal("bar-1 baz-1", custom_merger.merge("bar-1 baz-1"))
    assert_equal("bar-2", custom_merger.merge("bar-1/2 bar-2"))
    assert_equal("bar-1/2", custom_merger.merge("bar-2 bar-1/2"))
    assert_equal("baz-1/2", custom_merger.merge("bar-1 baz-1/2"))
  end

  def test_sorts_modifiers_correctly
    assert_equal("d:c:e:inline", @merger.merge("c:d:e:block d:c:e:inline"))
    assert_equal("*:before:inline", @merger.merge("*:before:block *:before:inline"))
    assert_equal("*:before:block before:*:inline", @merger.merge("*:before:block before:*:inline"))
    assert_equal("y:x:*:z:inline", @merger.merge("x:y:*:z:block y:x:*:z:inline"))
  end

  def test_sorts_modifiers_correctly_according_to_order_sensitive_modifiers
    config = {
      cache_size: 10,
      theme: {},
      class_groups: {
        foo: ["foo-1", "foo-2"],
      },
      conflicting_class_groups: {},
      conflicting_class_group_modifiers: {},
      order_sensitive_modifiers: ["a", "b"],
    }

    custom_merger = TailwindMerge::Merger.new(config:)

    assert_equal("d:c:e:foo-2", custom_merger.merge("c:d:e:foo-1 d:c:e:foo-2"))
    assert_equal("a:b:foo-2", custom_merger.merge("a:b:foo-1 a:b:foo-2"))
    assert_equal("a:b:foo-1 b:a:foo-2", custom_merger.merge("a:b:foo-1 b:a:foo-2"))
    assert_equal("y:x:a:z:foo-2", custom_merger.merge("x:y:a:z:foo-1 y:x:a:z:foo-2"))
  end
end
