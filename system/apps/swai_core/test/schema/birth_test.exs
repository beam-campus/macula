defmodule Swai.Schema.BirthTest do
  use ExUnit.Case
  alias Swai.Schema.Birth

  @tag :ignore_test
  doctest Birth

  @tag :ignore_test
  test "that the Birth module esists" do
    assert is_list(Birth.module_info)
  end



end
