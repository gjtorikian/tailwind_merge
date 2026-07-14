# frozen_string_literal: true

require "test_helper"

class TestConfig < Minitest::Test
  def test_default_config_has_correct_types
    config = TailwindMerge::Config::DEFAULTS

    assert_equal(500, config[:cache_size])
    assert(config[:ignore_empty_cache])
    refute(config[:nonexistent])
    assert_equal("block", config[:class_groups]["display"].first)
    assert_equal("auto", config[:class_groups]["overflow"].first["overflow"].first)
    refute(config[:class_groups]["overflow"].first[:nonexistent])
  end

  def test_defaults_is_deeply_frozen
    unfrozen = []
    walk = lambda do |object, path|
      case object
      when Hash
        unfrozen << path unless object.frozen?
        object.each { |key, value| walk.call(value, "#{path}[#{key.inspect}]") }
      when Array
        unfrozen << path unless object.frozen?
        object.each_with_index { |value, index| walk.call(value, "#{path}[#{index}]") }
      end
    end
    walk.call(TailwindMerge::Config::DEFAULTS, "DEFAULTS")

    assert_empty(unfrozen, "Unfrozen nested structures: #{unfrozen.first(10).join(", ")}")
  end

  def test_custom_theme_does_not_mutate_default_config
    default_spacing = TailwindMerge::Config::DEFAULTS[:theme]["spacing"].dup

    3.times do |index|
      TailwindMerge::Merger.new(config: { theme: { "spacing" => ["custom-spacing-#{index}"] } })
    end

    assert_equal(default_spacing, TailwindMerge::Config::DEFAULTS[:theme]["spacing"])
  end

  def test_merge_config_does_not_mutate_incoming_config
    config = {
      cache_size: 10,
      theme: {
        "spacing" => ["custom-spacing"],
      },
    }
    original_config = config.dup
    original_config[:theme] = config[:theme].dup

    TailwindMerge::Merger.new(config:)

    assert_equal(original_config, config)
  end
end
