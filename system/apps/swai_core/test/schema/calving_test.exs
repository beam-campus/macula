defmodule Swai.Schema.CalvingTest do
  use ExUnit.Case

  alias Swai.Schema.Calving


  @tag :ignore_test
  doctest Calving

  @valid_calving_attrs %{
    mother_life_number: "1234",
    father_life_number: "6874",
    calving_date: DateTime.utc_now(),
    lac_number: 547
  }


  @tag :ignore_test
  test "that the Calving module exists" do
    assert is_list(Calving.module_info)
  end


  @tag :ignore_test
  test "that we get a Calving from valid attributes using new/1" do
    case Calving.new(@valid_calving_attrs) do
      {:ok, calving} ->
        assert calving != nil
        IO.inspect(calving, [])

      {:error, changeset} ->
        assert changeset != nil
        IO.inspect(changeset, [])
      end
  end











end
