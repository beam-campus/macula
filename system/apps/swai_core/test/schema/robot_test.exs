defmodule Swai.Schema.RobotTest do
  use ExUnit.Case
  alias Swai.Schema.Robot
  alias Swai.Schema.Life

  @tag :ignore_test
  doctest Robot

  @valid_input %{
    name: "Robby"
  }

  @invalid_input %{
    some_name: "BlahBlah"
  }


  @tag :ignore_test
  test "that the module exists" do
    assert is_list(Swai.Schema.Robot.module_info())
  end

  @tag :ignore_test
  test "that we return {:ok, robot} from a valid input map using new/1" do
    case Robot.new(@valid_input) do

      {:ok, robot} ->
        assert robot != nil
        assert robot.name == "Robby"
        IO.inspect(robot, [])

      _ ->
        assert false

    end
  end

  @tag :ignore_test
  test "that we return an {:error, changeset} for an invalid input map, using new/1" do
    case Robot.new(@invalid_input) do

      {:error, changeset} ->
        assert changeset != nil
        IO.inspect(changeset, [])

      _ ->
        assert false

    end
  end

  @tag :ignore_test
  test "that start_milking/2 changes the status of the robot and sets a life_number" do
    # GIVEN
    {:ok,life} = Life.new(%{
        life_number: "123",
        responder_id: "responder-524",
        gender: :female})

    {:ok, robot} = Robot.new(%{name: "robot1"})
    # WHEN
    {:ok, new_robot} = Robot.start_milking(robot, life)
    IO.inspect(new_robot, [])
    # THEN
    assert new_robot != nil
    assert new_robot.status == Robot.robot_status().milking
  end


end
