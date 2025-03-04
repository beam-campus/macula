defmodule Swai.Schema.ScapeTest do
  use ExUnit.Case

  alias Swai.Schema.Scape

  @valid_scape_map %{
    name: "my-scape",
    regions: [
      %{
        name: "us-west-1",
        description: "United States, West Coast 1"
      }
    ]
  }

  @tag :ignore_test
  test "that the module Swai.Schema.Scape exists" do
    assert is_list(Swai.Schema.Scape.module_info())
  end

  @tag :ignore_test
  test "that we can create a Scape from a valid input using new/1 " do
    case Scape.new(@valid_scape_map) do
      {:ok, scape} ->
        assert scape != nil
        assert scape.name == "my-scape"
        inspect(scape)

      _ ->
        assert false
    end
  end
end
