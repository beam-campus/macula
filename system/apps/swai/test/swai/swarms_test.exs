defmodule Swai.SwarmsTest do
  use Swai.DataCase

  alias Swai.Swarms

  describe "swarms" do
    alias Schema.Swarm

    import Swai.SwarmsFixtures

    @invalid_attrs %{name: nil, status: nil, description: nil, edge_id: nil, user_id: nil, biotope_id: nil}

    test "list_swarms/0 returns all swarms" do
      swarm = swarm_fixture()
      assert Swarms.list_swarms() == [swarm]
    end

    test "get_swarm!/1 returns the swarm with given id" do
      swarm = swarm_fixture()
      assert Swarms.get_swarm!(swarm.id) == swarm
    end

    test "create_swarm/1 with valid data creates a swarm" do
      valid_attrs = %{name: "some name", status: 42, description: "some description", edge_id: "some edge_id", user_id: "some user_id", biotope_id: "some biotope_id"}

      assert {:ok, %Swarm{} = swarm} = Swarms.create_swarm(valid_attrs)
      assert swarm.name == "some name"
      assert swarm.status == 42
      assert swarm.description == "some description"
      assert swarm.edge_id == "some edge_id"
      assert swarm.user_id == "some user_id"
      assert swarm.biotope_id == "some biotope_id"
    end

    test "create_swarm/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Swarms.create_swarm(@invalid_attrs)
    end

    test "update_swarm/2 with valid data updates the swarm" do
      swarm = swarm_fixture()
      update_attrs = %{name: "some updated name", status: 43, description: "some updated description", edge_id: "some updated edge_id", user_id: "some updated user_id", biotope_id: "some updated biotope_id"}

      assert {:ok, %Swarm{} = swarm} = Swarms.update_swarm(swarm, update_attrs)
      assert swarm.name == "some updated name"
      assert swarm.status == 43
      assert swarm.description == "some updated description"
      assert swarm.edge_id == "some updated edge_id"
      assert swarm.user_id == "some updated user_id"
      assert swarm.biotope_id == "some updated biotope_id"
    end

    test "update_swarm/2 with invalid data returns error changeset" do
      swarm = swarm_fixture()
      assert {:error, %Ecto.Changeset{}} = Swarms.update_swarm(swarm, @invalid_attrs)
      assert swarm == Swarms.get_swarm!(swarm.id)
    end

    test "delete_swarm/1 deletes the swarm" do
      swarm = swarm_fixture()
      assert {:ok, %Swarm{}} = Swarms.delete_swarm(swarm)
      assert_raise Ecto.NoResultsError, fn -> Swarms.get_swarm!(swarm.id) end
    end

    test "change_swarm/1 returns a swarm changeset" do
      swarm = swarm_fixture()
      assert %Ecto.Changeset{} = Swarms.change_swarm(swarm)
    end
  end
end
