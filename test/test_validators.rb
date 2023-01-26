# frozen_string_literal: true

require "test_helper"

class TestValidators < Minitest::Test
  include TailwindMerge::Validators

  def test_is_length
    assert(IS_LENGTH.call("1"))
    assert(IS_LENGTH.call("1023713"))
    assert(IS_LENGTH.call("1.5"))
    assert(IS_LENGTH.call("1231.503761"))
    assert(IS_LENGTH.call("px"))
    assert(IS_LENGTH.call("full"))
    assert(IS_LENGTH.call("screen"))
    assert(IS_LENGTH.call("1/2"))
    assert(IS_LENGTH.call("123/345"))
    assert(IS_LENGTH.call("[3.7%]"))
    assert(IS_LENGTH.call("[481px]"))
    assert(IS_LENGTH.call("[19.1rem]"))
    assert(IS_LENGTH.call("[50vw]"))
    assert(IS_LENGTH.call("[56vh]"))
    assert(IS_LENGTH.call("[length:var(--arbitrary)]"))

    refute(IS_LENGTH.call("1d5"))
    refute(IS_LENGTH.call("[1]"))
    refute(IS_LENGTH.call("[12px"))
    refute(IS_LENGTH.call("12px]"))
    refute(IS_LENGTH.call("one"))
  end

  def test_is_arbitrary_length
    assert(IS_ARBITRARY_LENGTH.call("[3.7%]"))
    assert(IS_ARBITRARY_LENGTH.call("[481px]"))
    assert(IS_ARBITRARY_LENGTH.call("[19.1rem]"))
    assert(IS_ARBITRARY_LENGTH.call("[50vw]"))
    assert(IS_ARBITRARY_LENGTH.call("[56vh]"))
    assert(IS_ARBITRARY_LENGTH.call("[length:var(--arbitrary)]"))

    refute(IS_ARBITRARY_LENGTH.call("1"))
    refute(IS_ARBITRARY_LENGTH.call("3px"))
    refute(IS_ARBITRARY_LENGTH.call("1d5"))
    refute(IS_ARBITRARY_LENGTH.call("[1]"))
    refute(IS_ARBITRARY_LENGTH.call("[12px"))
    refute(IS_ARBITRARY_LENGTH.call("12px]"))
    refute(IS_ARBITRARY_LENGTH.call("one"))
  end

  def test_is_integer
    assert(IS_INTEGER.call("1"))
    assert(IS_INTEGER.call("123"))
    assert(IS_INTEGER.call("8312"))
    assert(IS_INTEGER.call("[8312]"))
    assert(IS_INTEGER.call("[2]"))

    refute(IS_INTEGER.call("[8312px]"))
    refute(IS_INTEGER.call("[8312%]"))
    refute(IS_INTEGER.call("[8312rem]"))
    refute(IS_INTEGER.call("8312.2"))
    refute(IS_INTEGER.call("1.2"))
    refute(IS_INTEGER.call("one"))
    refute(IS_INTEGER.call("1/2"))
    refute(IS_INTEGER.call("1%"))
    refute(IS_INTEGER.call("1px"))
  end

  def test_is_arbitrary_value
    assert(IS_ARBITRARY_VALUE.call("[1]"))
    assert(IS_ARBITRARY_VALUE.call("[bla]"))
    assert(IS_ARBITRARY_VALUE.call("[not-an-arbitrary-value?]"))
    assert(IS_ARBITRARY_VALUE.call("[auto,auto,minmax(0,1fr),calc(100vw-50%)]"))

    refute(IS_ARBITRARY_VALUE.call("[]"))
    refute(IS_ARBITRARY_VALUE.call("[1"))
    refute(IS_ARBITRARY_VALUE.call("1]"))
    refute(IS_ARBITRARY_VALUE.call("1"))
    refute(IS_ARBITRARY_VALUE.call("one"))
    refute(IS_ARBITRARY_VALUE.call("o[n]e"))
  end

  def test_is_any
    assert(IS_ANY.call("something"))
  end

  def test_is_tshirt_size
    assert(IS_TSHIRT_SIZE.call("xs"))
    assert(IS_TSHIRT_SIZE.call("sm"))
    assert(IS_TSHIRT_SIZE.call("md"))
    assert(IS_TSHIRT_SIZE.call("lg"))
    assert(IS_TSHIRT_SIZE.call("xl"))
    assert(IS_TSHIRT_SIZE.call("2xl"))
    assert(IS_TSHIRT_SIZE.call("10xl"))
    assert(IS_TSHIRT_SIZE.call("2xs"))
    assert(IS_TSHIRT_SIZE.call("2lg"))

    refute(IS_TSHIRT_SIZE.call(""))
    refute(IS_TSHIRT_SIZE.call("hello"))
    refute(IS_TSHIRT_SIZE.call("1"))
    refute(IS_TSHIRT_SIZE.call("xl3"))
    refute(IS_TSHIRT_SIZE.call("2xl3"))
    refute(IS_TSHIRT_SIZE.call("-xl"))
    refute(IS_TSHIRT_SIZE.call("[sm]"))
  end

  def test_is_arbitrary_size
    assert(IS_ARBITRARY_SIZE.call("[size:2px]"))
    assert(IS_ARBITRARY_SIZE.call("[size:bla]"))

    refute(IS_ARBITRARY_SIZE.call("[2px]"))
    refute(IS_ARBITRARY_SIZE.call("[bla]"))
    refute(IS_ARBITRARY_SIZE.call("size:2px"))
  end

  def test_is_arbitrary_position
    assert(IS_ARBITRARY_POSITION.call("[position:2px]"))
    assert(IS_ARBITRARY_POSITION.call("[position:bla]"))

    refute(IS_ARBITRARY_POSITION.call("[2px]"))
    refute(IS_ARBITRARY_POSITION.call("[bla]"))
    refute(IS_ARBITRARY_POSITION.call("position:2px"))
  end

  def test_is_arbitrary_url
    assert(IS_ARBITRARY_URL.call("[url:var(--my-url)]"))
    assert(IS_ARBITRARY_URL.call("[url(something)]"))
    assert(IS_ARBITRARY_URL.call("[url:bla]"))

    refute(IS_ARBITRARY_URL.call("[var(--my-url)]"))
    refute(IS_ARBITRARY_URL.call("[bla]"))
    refute(IS_ARBITRARY_URL.call("url:2px"))
    refute(IS_ARBITRARY_URL.call("url(2px)"))
  end

  def test_is_arbitrary_number
    assert(IS_ARBITRARY_NUMBER.call("[number:black]"))
    assert(IS_ARBITRARY_NUMBER.call("[number:bla]"))
    assert(IS_ARBITRARY_NUMBER.call("[number:230]"))
    assert(IS_ARBITRARY_NUMBER.call("[450]"))

    refute(IS_ARBITRARY_NUMBER.call("[2px]"))
    refute(IS_ARBITRARY_NUMBER.call("[bla]"))
    refute(IS_ARBITRARY_NUMBER.call("[black]"))
    refute(IS_ARBITRARY_NUMBER.call("black"))
    refute(IS_ARBITRARY_NUMBER.call("450"))
  end

  def test_is_arbitrary_shadow
    assert(IS_ARBITRARY_SHADOW.call("[0_35px_60px_-15px_rgba(0,0,0,0.3)]"))
    assert(IS_ARBITRARY_SHADOW.call("[0_0_#00f]"))
    assert(IS_ARBITRARY_SHADOW.call("[.5rem_0_rgba(5,5,5,5)]"))
    assert(IS_ARBITRARY_SHADOW.call("[-.5rem_0_#123456]"))
    assert(IS_ARBITRARY_SHADOW.call("[0.5rem_-0_#123456]"))
    assert(IS_ARBITRARY_SHADOW.call("[0.5rem_-0.005vh_#123456]"))
    assert(IS_ARBITRARY_SHADOW.call("[0.5rem_-0.005vh]"))

    refute(IS_ARBITRARY_SHADOW.call("[rgba(5,5,5,5)]"))
    refute(IS_ARBITRARY_SHADOW.call("[#00f]"))
    refute(IS_ARBITRARY_SHADOW.call("[something-else]"))
  end
end
