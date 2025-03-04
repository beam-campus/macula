defmodule Swai.Schema.BloodLineTest do
  alias Swai.Schema.BloodLine
  use ExUnit.Case

  @valid_bloodline_attrs %{
    life_number: "life-number-123",
    blood_type_code: "blood-type-123",
    percentage: 20.35
  }

  @invalid_bloodline_attrs %{
    life_number: 1234,
    blood_type: "some_blood_type",
    pct: 8
  }

  @tag :ignore_test
  describe "that we get a valid BloodLine back from valid source" do
    test "should create a BloodLine using new/1 with a valid source" do
      case BloodLine.new(@valid_bloodline_attrs) do
        {:ok, bloodline} ->
          IO.inspect(bloodline, [])
          assert bloodline != nil

        {:error, changeset} ->
            assert changeset != nil
            IO.inspect(changeset, [])
      end
    end
  end

  @tag :ignore_test
  describe "that we get a changeset with an invalid source" do
    test "should return a changeset using new/1 with an invalid source" do
      case BloodLine.new(@invalid_bloodline_attrs) do
        {:ok, bloodline} ->
          IO.inspect(bloodline, [])
          assert bloodline != nil

        {:error, changeset} ->
            assert changeset != nil
            IO.inspect(changeset, [])
      end
    end

  end

end
