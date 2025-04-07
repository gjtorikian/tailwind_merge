# frozen_string_literal: true

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

  def test_tailwind_3_4_features
    assert_equal("h-dvh w-dvw", @merger.merge("h-svh h-dvh w-svw w-dvw"))

    assert_equal("has-[[data-potato]]:p-2 group-has-[:checked]:flex", @merger.merge("has-[[data-potato]]:p-1 has-[[data-potato]]:p-2 group-has-[:checked]:grid group-has-[:checked]:flex"))

    assert_equal("text-pretty", @merger.merge("text-wrap text-pretty"))
    assert_equal("size-10 w-12", @merger.merge("w-5 h-3 size-10 w-12"))

    assert_equal("grid-cols-subgrid grid-rows-subgrid", @merger.merge("grid-cols-2 grid-cols-subgrid grid-rows-5 grid-rows-subgrid"))

    assert_equal("min-w-px max-w-px", @merger.merge("min-w-0 min-w-50 min-w-px max-w-0 max-w-50 max-w-px"))

    assert_equal("forced-color-adjust-auto", @merger.merge("forced-color-adjust-none forced-color-adjust-auto"))

    assert_equal("appearance-auto", @merger.merge("appearance-none appearance-auto"))
    assert_equal("float-end clear-end", @merger.merge("float-start float-end clear-start clear-end"))
    assert_equal("*:p-20 hover:*:p-20", @merger.merge("*:p-10 *:p-20 hover:*:p-10 hover:*:p-20"))
  end

  def test_tailwind_4_0_features
    assert_equal("transform-flat", @merger.merge("transform-3d transform-flat"))
    assert_equal("rotate-x-2 rotate-none rotate-y-3", @merger.merge("rotate-12 rotate-x-2 rotate-none rotate-y-3"))
    assert_equal("perspective-midrange", @merger.merge("perspective-dramatic perspective-none perspective-midrange"))
    assert_equal("perspective-origin-top-left", @merger.merge("perspective-origin-center perspective-origin-top-left"))
    assert_equal("bg-linear-45", @merger.merge("bg-linear-to-r bg-linear-45"))
    assert_equal("bg-conic-10", @merger.merge("bg-linear-to-r bg-radial-[something] bg-conic-10"))
    assert_equal("ring-4 ring-orange inset-ring-3 inset-ring-blue", @merger.merge("ring-4 ring-orange inset-ring inset-ring-3 inset-ring-blue"))
    assert_equal("field-sizing-fixed", @merger.merge("field-sizing-content field-sizing-fixed"))
    assert_equal("scheme-dark", @merger.merge("scheme-normal scheme-dark"))
    assert_equal("font-stretch-50%", @merger.merge("font-stretch-expanded font-stretch-[66.66%] font-stretch-50%"))
    assert_equal("col-2 row-4", @merger.merge("col-span-full col-2 row-span-3 row-4"))

    assert_equal("via-(--mobile-header-gradient)", @merger.merge("via-red-500 via-(--mobile-header-gradient)"))
    assert_equal("via-red-500 via-(length:--mobile-header-gradient)", @merger.merge("via-red-500 via-(length:--mobile-header-gradient)"))
  end

  def test_tailwind_4_1_features
    #     expect(twMerge('items-baseline items-baseline-last')).toBe('items-baseline-last')

    #     expect(twMerge('self-baseline self-baseline-last')).toBe('self-baseline-last')
    #     expect(twMerge('place-content-center place-content-end-safe place-content-center-safe')).toBe(
    #         'place-content-center-safe',
    #     )
    #     expect(twMerge('items-center-safe items-baseline items-end-safe')).toBe('items-end-safe')
    #     expect(twMerge('wrap-break-word wrap-normal wrap-anywhere')).toBe('wrap-anywhere')
    #     expect(twMerge('text-shadow-none text-shadow-2xl')).toBe('text-shadow-2xl')
    #     expect(
    #         twMerge(
    #             'text-shadow-none text-shadow-md text-shadow-red text-shadow-red-500 shadow-red shadow-3xs',
    #         ),
    #     ).toBe('text-shadow-md text-shadow-red-500 shadow-red shadow-3xs')
    #     expect(twMerge('mask-add mask-subtract')).toBe('mask-subtract')
    #     expect(
    #         twMerge(
    #             // mask-image
    #             'mask-(--foo) mask-[foo] mask-none',
    #             // mask-image-linear-pos
    #             'mask-linear-1 mask-linear-2',
    #             // mask-image-linear-from-pos
    #             'mask-linear-from-[position:test] mask-linear-from-3',
    #             // mask-image-linear-to-pos
    #             'mask-linear-to-[position:test] mask-linear-to-3',
    #             // mask-image-linear-from-color
    #             'mask-linear-from-color-red mask-linear-from-color-3',
    #             // mask-image-linear-to-color
    #             'mask-linear-to-color-red mask-linear-to-color-3',
    #             // mask-image-t-from-pos
    #             'mask-t-from-[position:test] mask-t-from-3',
    #             // mask-image-t-to-pos
    #             'mask-t-to-[position:test] mask-t-to-3',
    #             // mask-image-t-from-color
    #             'mask-t-from-color-red mask-t-from-color-3',
    #             // mask-image-radial
    #             'mask-radial-(--test) mask-radial-[test]',
    #             // mask-image-radial-from-pos
    #             'mask-radial-from-[position:test] mask-radial-from-3',
    #             // mask-image-radial-to-pos
    #             'mask-radial-to-[position:test] mask-radial-to-3',
    #             // mask-image-radial-from-color
    #             'mask-radial-from-color-red mask-radial-from-color-3',
    #         ),
    #     ).toBe(
    #         'mask-none mask-linear-2 mask-linear-from-3 mask-linear-to-3 mask-linear-from-color-3 mask-linear-to-color-3 mask-t-from-3 mask-t-to-3 mask-t-from-color-3 mask-radial-[test] mask-radial-from-3 mask-radial-to-3 mask-radial-from-color-3',
    #     )
    #     expect(
    #         twMerge(
    #             // mask-image
    #             'mask-(--something) mask-[something]',
    #             // mask-position
    #             'mask-top-left mask-center mask-(position:--var) mask-[position:1px_1px] mask-position-(--var) mask-position-[1px_1px]',
    #         ),
    #     ).toBe('mask-[something] mask-position-[1px_1px]')
    #     expect(
    #         twMerge(
    #             // mask-image
    #             'mask-(--something) mask-[something]',
    #             // mask-size
    #             'mask-auto mask-[size:foo] mask-(size:--foo) mask-size-[foo] mask-size-(--foo) mask-cover mask-contain',
    #         ),
    #     ).toBe('mask-[something] mask-contain')
    #     expect(twMerge('mask-type-luminance mask-type-alpha')).toBe('mask-type-alpha')
    #     expect(twMerge('shadow-md shadow-lg/25 text-shadow-md text-shadow-lg/25')).toBe(
    #         'shadow-lg/25 text-shadow-lg/25',
    #     )
    #     expect(
    #         twMerge('drop-shadow-some-color drop-shadow-[#123456] drop-shadow-lg drop-shadow-[10px_0]'),
    #     ).toBe('drop-shadow-[#123456] drop-shadow-[10px_0]')
    #     expect(twMerge('drop-shadow-[#123456] drop-shadow-some-color')).toBe('drop-shadow-some-color')
    #     expect(twMerge('drop-shadow-2xl drop-shadow-[shadow:foo]')).toBe('drop-shadow-[shadow:foo]')
    # })
  end
end
