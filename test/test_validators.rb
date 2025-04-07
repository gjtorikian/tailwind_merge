# frozen_string_literal: true

require "test_helper"

class TestValidators < Minitest::Test
  include TailwindMerge::Validators

  def test_is_any
    assert(IS_ANY.call)
    assert(IS_ANY.call(""))
    assert(IS_ANY.call("something"))
  end

  def test_is_any_non_arbitrary
    assert(IS_ANY_NON_ARBITRARY.call("test"))
    assert(IS_ANY_NON_ARBITRARY.call("1234-hello-world"))
    assert(IS_ANY_NON_ARBITRARY.call("[hello"))
    assert(IS_ANY_NON_ARBITRARY.call("hello]"))
    assert(IS_ANY_NON_ARBITRARY.call("[)"))
    assert(IS_ANY_NON_ARBITRARY.call("(hello]"))

    refute(IS_ANY_NON_ARBITRARY.call("[test]"))
    refute(IS_ANY_NON_ARBITRARY.call("[label:test]"))
    refute(IS_ANY_NON_ARBITRARY.call("(test)"))
    refute(IS_ANY_NON_ARBITRARY.call("(label:test)"))
  end

  def test_is_arbitrary_image
    assert(IS_ARBITRARY_IMAGE.call("[url:var(--my-url)]"))
    assert(IS_ARBITRARY_IMAGE.call("[url(something)]"))
    assert(IS_ARBITRARY_IMAGE.call("[url:bla]"))
    assert(IS_ARBITRARY_IMAGE.call("[image:bla]"))
    assert(IS_ARBITRARY_IMAGE.call("[linear-gradient(something)]"))
    assert(IS_ARBITRARY_IMAGE.call("[repeating-conic-gradient(something)]"))

    refute(IS_ARBITRARY_IMAGE.call("[var(--my-url)]"))
    refute(IS_ARBITRARY_IMAGE.call("[bla]"))
    refute(IS_ARBITRARY_IMAGE.call("url:2px"))
    refute(IS_ARBITRARY_IMAGE.call("url(2px)"))
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

  def test_is_arbitrary_position
    assert(IS_ARBITRARY_POSITION.call("[position:2px]"))
    assert(IS_ARBITRARY_POSITION.call("[position:bla]"))
    assert(IS_ARBITRARY_POSITION.call("[percentage:bla]"))

    refute(IS_ARBITRARY_POSITION.call("[2px]"))
    refute(IS_ARBITRARY_POSITION.call("[bla]"))
    refute(IS_ARBITRARY_POSITION.call("position:2px"))
  end

  def test_is_arbitrary_shadow
    assert(IS_ARBITRARY_SHADOW.call("[0_35px_60px_-15px_rgba(0,0,0,0.3)]"))
    assert(IS_ARBITRARY_SHADOW.call("[inset_0_1px_0,inset_0_-1px_0]"))
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

  def test_is_arbitrary_size
    assert(IS_ARBITRARY_SIZE.call("[size:2px]"))
    assert(IS_ARBITRARY_SIZE.call("[size:bla]"))
    assert(IS_ARBITRARY_SIZE.call("[length:bla]"))

    refute(IS_ARBITRARY_SIZE.call("[2px]"))
    refute(IS_ARBITRARY_SIZE.call("[bla]"))
    refute(IS_ARBITRARY_SIZE.call("size:2px"))
    refute(IS_ARBITRARY_SIZE.call("[percentage:bla]"))
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

  def test_is_arbitrary_variable
    assert(IS_ARBITRARY_VARIABLE.call("(1)"))
    assert(IS_ARBITRARY_VARIABLE.call("(bla)"))
    assert(IS_ARBITRARY_VARIABLE.call("(not-an-arbitrary-value?)"))
    assert(IS_ARBITRARY_VARIABLE.call("(--my-arbitrary-variable)"))
    assert(IS_ARBITRARY_VARIABLE.call("(label:--my-arbitrary-variable)"))

    refute(IS_ARBITRARY_VARIABLE.call("()"))
    refute(IS_ARBITRARY_VARIABLE.call("(1"))
    refute(IS_ARBITRARY_VARIABLE.call("1)"))
    refute(IS_ARBITRARY_VARIABLE.call("1"))
    refute(IS_ARBITRARY_VARIABLE.call("one"))
    refute(IS_ARBITRARY_VARIABLE.call("o(n)e"))
  end

  def test_is_arbitrary_variable_family_name
    assert(IS_ARBITRARY_VARIABLE_FAMILY_NAME.call("(family-name:test)"))

    refute(IS_ARBITRARY_VARIABLE_FAMILY_NAME.call("(other:test)"))
    refute(IS_ARBITRARY_VARIABLE_FAMILY_NAME.call("(test)"))
    refute(IS_ARBITRARY_VARIABLE_FAMILY_NAME.call("family-name:test"))
  end

  def test_is_arbitrary_variable_image
    assert(IS_ARBITRARY_VARIABLE_IMAGE.call("(image:test)"))
    assert(IS_ARBITRARY_VARIABLE_IMAGE.call("(url:test)"))

    refute(IS_ARBITRARY_VARIABLE_IMAGE.call("(other:test)"))
    refute(IS_ARBITRARY_VARIABLE_IMAGE.call("(test)"))
    refute(IS_ARBITRARY_VARIABLE_IMAGE.call("image:test"))
  end

  def test_is_arbitrary_variable_length
    assert(IS_ARBITRARY_VARIABLE_LENGTH.call("(length:test)"))

    refute(IS_ARBITRARY_VARIABLE_LENGTH.call("(other:test)"))
    refute(IS_ARBITRARY_VARIABLE_LENGTH.call("(test)"))
    refute(IS_ARBITRARY_VARIABLE_LENGTH.call("length:test"))
  end

  def test_is_arbitrary_variable_position
    assert(IS_ARBITRARY_VARIABLE_POSITION.call("(position:test)"))

    refute(IS_ARBITRARY_VARIABLE_POSITION.call("(other:test)"))
    refute(IS_ARBITRARY_VARIABLE_POSITION.call("(test)"))
    refute(IS_ARBITRARY_VARIABLE_POSITION.call("position:test"))
    refute(IS_ARBITRARY_VARIABLE_POSITION.call("percentage:test"))
  end

  def test_is_arbitrary_variable_shadow
    assert(IS_ARBITRARY_VARIABLE_SHADOW.call("(shadow:test)"))
    assert(IS_ARBITRARY_VARIABLE_SHADOW.call("(test)"))

    refute(IS_ARBITRARY_VARIABLE_SHADOW.call("(other:test)"))
    refute(IS_ARBITRARY_VARIABLE_SHADOW.call("shadow:test"))
  end

  def test_is_arbitrary_variable_size
    assert(IS_ARBITRARY_VARIABLE_SIZE.call("(size:test)"))
    assert(IS_ARBITRARY_VARIABLE_SIZE.call("(length:test)"))

    refute(IS_ARBITRARY_VARIABLE_SIZE.call("(other:test)"))
    refute(IS_ARBITRARY_VARIABLE_SIZE.call("(test)"))
    refute(IS_ARBITRARY_VARIABLE_SIZE.call("size:test"))
    refute(IS_ARBITRARY_VARIABLE_SIZE.call("percentage:test"))
  end

  def test_is_fraction
    assert(IS_FRACTION.call("1/2"))
    assert(IS_FRACTION.call("123/209"))

    refute(IS_FRACTION.call("1"))
    refute(IS_FRACTION.call("1/2/3"))
    refute(IS_FRACTION.call("[1/2]"))
  end

  def test_is_integer
    assert(IS_INTEGER.call("1"))
    assert(IS_INTEGER.call("123"))
    assert(IS_INTEGER.call("8312"))

    refute(IS_INTEGER.call("[8312]"))
    refute(IS_INTEGER.call("[2]"))
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

  def test_is_number
    assert(IS_NUMBER.call("1"))
    assert(IS_NUMBER.call("123"))
    assert(IS_NUMBER.call("8312"))
    assert(IS_NUMBER.call("8312.2"))
    assert(IS_NUMBER.call("1.2"))

    refute(IS_NUMBER.call("[8312]"))
    refute(IS_NUMBER.call("[2]"))
    refute(IS_NUMBER.call("[8312px]"))
    refute(IS_NUMBER.call("[8312%]"))
    refute(IS_NUMBER.call("[8312rem]"))
    refute(IS_NUMBER.call("one"))
    refute(IS_NUMBER.call("1/2"))
    refute(IS_NUMBER.call("1%"))
    refute(IS_NUMBER.call("1px"))
  end

  def test_is_percent
    assert(IS_PERCENT.call("1%"))
    assert(IS_PERCENT.call("100.001%"))
    assert(IS_PERCENT.call(".01%"))
    assert(IS_PERCENT.call("0%"))

    refute(IS_PERCENT.call("0"))
    refute(IS_PERCENT.call("one%"))
  end

  def test_is_tshirt_size
    assert(IS_TSHIRT_SIZE.call("xs"))
    assert(IS_TSHIRT_SIZE.call("sm"))
    assert(IS_TSHIRT_SIZE.call("md"))
    assert(IS_TSHIRT_SIZE.call("lg"))
    assert(IS_TSHIRT_SIZE.call("xl"))
    assert(IS_TSHIRT_SIZE.call("2xl"))
    assert(IS_TSHIRT_SIZE.call("2.5xl"))
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
end
