defmodule Swai.Schema.IdTest do
  use ExUnit.Case

  alias Swai.Schema.Id

  @moduletag :capture_log
  @id_value "ff6ceab0-d3b1-4d38-ab0e-3158f3a7e127"

  @tag :ignore_test
  doctest Id

  @tag :ignore_test
  test "that the module exists" do
    assert is_list(Id.module_info())
  end

  @tag :ignore_test
  test "should create new/1 life id" do
    id = Id.new("life")
    assert (id != nil)
    assert (id.prefix === "life")
    IO.inspect(id, [])
  end

  @tag :ignore_test
  test "should create new/2 life id" do
    id = Id.new("life", @id_value)
    assert (id != nil)
    assert (id.value === @id_value)
    IO.inspect(id, [])
  end

  @tag :ignore_test
  test "that as_string/1 returns the correct string" do
    ## GIVEN
    id = Id.new("life", @id_value)
    ## WHEN
    res = Id.as_string(id)
    ## THEN
    assert is_bitstring(res)
  end



end
