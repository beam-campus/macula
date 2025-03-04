defmodule Swai.Schema.RegionTest do
  use ExUnit.Case

  alias Swai.Schema.Region

  @tag :ignore_test
  doctest Swai.Schema.Region

  @valid_input %{
    name: "region_eu_west_1",
    description: "Western Europe 1",
    farms: [
      %{
        id: %{
          prefix: "farm",
          value: "1234"
        },
        name: "Meulemans",
        nbr_of_robots: 5,
        nbr_of_life: 200
      },
      %{
        name: "Vertier",
        nbr_of_robots: 4,
        nbr_of_life: 110
      }
    ]
  }

  @invalid_input %{
    description: "Western Europe 1",
    farms: [
      %{
        farmer: "Valserik",
        nbr_of_robots: 5,
        nbr_of_life: 200
      },
      %{
        name: "Vertier"
      }
    ]
  }

  @tag :ignore_test
  test "that the Swai.Schema.Region module exists" do
    assert is_list(Region.module_info())
  end

  @tag :ignore_test
  test "that we can create a Changeset using changeset/1" do
    case %Region{}
         |> Region.changeset(@valid_input) do
      %{valid?: true}  ->
        assert true

      _ ->
        assert false
    end
  end

  @tag :ignore_test
  test "that we can create a valid Region using new/1 with @valid_input" do
    case Region.new(@valid_input) do
      {:ok, region} ->
        IO.inspect(region, [])
        assert true

      _ ->
        assert false
    end
  end

  @tag :ignore_test
  test "that we return an {:error, changeset} for @invalid_input" do
    case Region.new(@invalid_input) do
      {:ok, _} ->
        assert false

      {:error, _} ->
        assert true
    end
  end

end
