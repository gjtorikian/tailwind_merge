# frozen_string_literal: true

# "frozen_string_literal" => true

require "test_helper"
require "set"

class TestTailwindCSSVersions < Minitest::Test
  def setup
    @merger = TailwindMerge::Merger.new
  end

  def test_tailwind_3_3_features
    assert_equal("text-red text-lg/8", @merger.merge("text-red text-lg/7 text-lg/8"))

    assert_equal("start-1 end-1 ps-1 pe-1 ms-1 me-1 rounded-s-md rounded-e-md rounded-ss-md rounded-ee-md", @merger.merge("start-0 start-1 end-0 end-1 ps-0 ps-1 pe-0 pe-1 ms-0 ms-1 me-0 me-1 rounded-s-sm rounded-s-md rounded-e-sm rounded-e-md rounded-ss-sm rounded-ss-md rounded-ee-sm rounded-ee-md"))

    assert_equal("inset-0 p-0 m-0 rounded-s", @merger.merge("start-0 end-0 inset-0 ps-0 pe-0 p-0 ms-0 me-0 m-0 rounded-ss rounded-es rounded-s"))

    assert_equal("hyphens-manual", @merger.merge("hyphens-auto hyphens-manual"))

    assert_equal("from-[12.5%] via-[12.5%] to-[12.5%]", @merger.merge("from-0% from-10% from-[12.5%] via-0% via-10% via-[12.5%] to-0% to-10% to-[12.5%]"))

    assert_equal("from-0% from-red", @merger.merge("from-0% from-red"))

    assert_equal("list-image-[var(--value)]", @merger.merge("list-image-none list-image-[url(./my-image.png)] list-image-[var(--value)]"))

    assert_equal("caption-bottom", @merger.merge("caption-top caption-bottom"))
    assert_equal("line-clamp-[10]", @merger.merge("line-clamp-2 line-clamp-none line-clamp-[10]"))
    assert_equal("delay-0 duration-0", @merger.merge("delay-150 delay-0 duration-150 duration-0"))
    assert_equal("justify-stretch", @merger.merge("justify-normal justify-center justify-stretch"))
    assert_equal("content-stretch", @merger.merge("content-normal content-center content-stretch"))
    assert_equal("whitespace-break-spaces", @merger.merge("whitespace-nowrap whitespace-break-spaces"))
  end
end
