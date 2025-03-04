defmodule Swai.Schema.LifeTest do
    use ExUnit.Case

    alias Swai.Schema.Life


    @tag :ignore_test
    doctest Life

    @valid_test_source  %{
      name: "Bella Dekoe",
      user_id: "user-123",
      life_number: "life-12345",
      responder_id: "responder-123",
      gender: :female,
      age: 2,
      energy: 5,
      do_keep?: true,
      group_number: 7,
      birth_date: ~D[1990-04-11],
      hair_color_code: "brown",
      madame: "blah",
      use_as_sire?: false
    }

    @invalid_test_source  %{
      name: "Bella Dekoe",
      user_id: "user-123",
      gender: :female,
      age: 2,
      energy: 5,
      do_keep?: true,
      group_number: 7,
      birth_date: ~D[1990-04-11],
      hair_color_code: "brown",
      madame: "blah",
      use_as_sire?: false
    }



    @tag :ignore_test
    test "that the module exists" do
      assert is_list(Life.module_info())
    end

    @tag :ignore_test
    describe "that we can get a Life back for a valid source" do
      test "should create a life using new/1" do
        case Life.new(@valid_test_source) do

          {:ok, life} ->
            assert life != nil
            IO.inspect(life, [])

          _ ->
            assert false

          end
      end
    end

    @tag :ignore_test
    describe "that we get the changeset back for an invalid source" do
      test "should create a life using new/1" do
        case Life.new(@invalid_test_source)  do

          {:error, changeset} ->
            assert changeset != nil
            IO.inspect(changeset, [])

          _ ->
            assert false

        end
      end

    end



end
