# frozen_string_literal: true

require "test_helper"

class TestConfig < Minitest::Test
  def test_default_config_has_correct_types
    config = TailwindMerge::Config::DEFAULTS

    assert_equal(500, config[:cache_size])
    refute(config[:nonexistent])
    assert_equal("block", config[:class_groups]["display"].first)
    assert_equal("auto", config[:class_groups]["overflow"].first["overflow"].first)
    refute(config[:class_groups]["overflow"].first[:nonexistent])
  end
end
