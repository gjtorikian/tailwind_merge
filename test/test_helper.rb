# frozen_string_literal: true

if ENV.fetch("DEBUG", false)
  require "amazing_print"
  require "debug"
end

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "tailwind_merge"

require "minitest/autorun"
require "minitest/focus"
require "minitest/pride"
