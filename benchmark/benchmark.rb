# frozen_string_literal: true

# Benchmark for the cache-miss merge path.
#
# Usage: ruby benchmark/benchmark.rb
#
# Measures `merge_class_list` directly: `merge` memoizes whole input strings
# in an LRU cache, so benchmarking it with a fixed corpus would mostly
# measure a Hash lookup. The uncached path is what runs for every
# first-seen class string in a real app.

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "benchmark-ips"
  gem "memory_profiler"
  gem "sin_lru_redux"
end

require_relative "../lib/tailwind_merge"

CORPUS = [
  # simple conflicts
  "px-2 px-4",
  "text-sm text-lg font-bold",
  "block inline flex",
  # modifiers
  "hover:focus:!bg-red-500 hover:focus:!bg-blue-600",
  "md:hover:underline md:hover:no-underline",
  "dark:sm:hover:bg-gray-800 dark:sm:hover:bg-gray-900",
  # postfix modifiers
  "bg-red-500/50 bg-red-500/75",
  "text-white/90 leading-7",
  # arbitrary values / properties / variables
  "p-[2px] p-[4px]",
  "[mask-type:luminance] [mask-type:alpha]",
  "bg-(--brand-color) bg-red-500",
  "content-['hello'] content-['world']",
  # non-tailwind classes mixed in
  "my-custom-class px-2 another-class px-4",
  # long realistic string (shadcn-style button + overrides)
  "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md " \
    "text-sm font-medium transition-colors focus-visible:outline-none " \
    "focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none " \
    "disabled:opacity-50 bg-primary text-primary-foreground shadow " \
    "hover:bg-primary/90 h-9 px-4 py-2 rounded-lg px-6 text-base w-full",
].freeze

merger = TailwindMerge::Merger.new

# sanity check: outputs must be non-empty
CORPUS.each do |s|
  result = merger.send(:merge_class_list, s)
  raise "unexpected empty result for #{s.inspect}" if result.empty?
end

puts "ruby #{RUBY_VERSION} (#{RUBY_ENGINE}), tailwind_merge #{TailwindMerge::VERSION}"
puts

Benchmark.ips do |x|
  x.report("merge_class_list (corpus of #{CORPUS.size})") do
    CORPUS.each { |s| merger.send(:merge_class_list, s) }
  end
  x.report("merge_class_list (long string)") do
    merger.send(:merge_class_list, CORPUS.last)
  end
end

puts
report = MemoryProfiler.report do
  CORPUS.each { |s| merger.send(:merge_class_list, s) }
end
puts "allocations for one corpus pass: " \
  "#{report.total_allocated} objects, #{report.total_allocated_memsize} bytes"
