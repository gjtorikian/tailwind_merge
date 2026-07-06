# frozen_string_literal: true

require "test_helper"

class TestThreadSafety < Minitest::Test
  # A single Merger instance is commonly shared process-wide (as the README
  # recommends), so its internal cache is hit by many threads at once. Unique
  # keys force concurrent inserts and LRU evictions, repeated keys force the
  # hit path's delete/re-insert. With a non-thread-safe cache this corrupts the
  # cache Hash on GVL-less engines (JRuby/TruffleRuby): threads livelock inside
  # the eviction loop (caught below by the join deadline) or results go wrong.
  # Assertions happen after the join — anything slow inside the loop spaces out
  # cache operations and hides the race.
  def test_shared_merger_is_thread_safe
    merger = TailwindMerge::Merger.new(config: { cache_size: 100 })

    warm_inputs = Array.new(20) { |i| "px-#{i} py-#{i} px-8" }
    expected = warm_inputs.map { |input| TailwindMerge::Merger.new.merge(input) }

    mismatches = Queue.new
    threads = Array.new(16) do |t|
      Thread.new do # rubocop:disable ThreadSafety/NewThread
        2000.times do |i|
          merger.merge("m-#{t}-#{i} p-#{i}")
          key = (t + i) % warm_inputs.size
          result = merger.merge(warm_inputs[key])
          mismatches << [warm_inputs[key], expected[key], result] if result != expected[key]
        end
      end
    end

    deadline = Time.now + 30
    finished = threads.all? { |thread| thread.join([deadline - Time.now, 0].max) }

    assert(finished, "threads still running after 30s — cache livelock")
    assert_empty(Array.new(mismatches.size) { mismatches.pop })
  end
end
