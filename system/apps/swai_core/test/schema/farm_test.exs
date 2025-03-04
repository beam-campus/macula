defmodule Swai.Schema.FarmTest do
  use ExUnit.Case

  alias Swai.Schema.Farm

  @tag :ignore_test
  doctest Farm

  @valid_farm_attrs %{
    name: "MyFarm",
    nbr_of_robots: 7,
    nbr_of_life: 100
  }

  @invalid_farm_attrs %{
    some_name: "BlahBlah"
  }

  @tag :ignore_test
  test "that the module exists" do
    assert is_list(Farm.module_info())
  end

  @tag :ignore_test
  test "that we can create a Farm using valid arguments and new/1" do
    case Farm.new(@valid_farm_attrs) do

      {:ok, farm} ->
        assert farm != nil
        assert farm.name === "MyFarm"
        IO.inspect(farm, [])

      _ ->
        assert false

    end
  end

  @tag :ignore_test
  test "that we get a changeset back when passing invalid attrs to new/1" do
    case Farm.new(@invalid_farm_attrs) do

     {:error, changeset}  ->
        assert changeset != nil
        IO.inspect(changeset, [])

      _ ->
        assert false

    end
  end



end
