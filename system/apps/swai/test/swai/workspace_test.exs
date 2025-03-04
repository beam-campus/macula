defmodule Swai.WorkspaceTest do
  use Swai.DataCase

  alias Swai.Workspace

  describe "swarm_licenses" do
    alias Schema.SwarmLicense

    import Swai.WorkspaceFixtures

    @invalid_attrs %{status: nil, swarm_size: nil, nbr_of_generations: nil, drone_depth: nil, generation_epoch_in_minutes: nil, select_best_count: nil, cost_in_tokens: nil, tokens_used: nil, total_run_time_in_seconds: nil, budget_in_tokens: nil}

    test "list_swarm_licenses/0 returns all swarm_licenses" do
      swarm_license = swarm_license_fixture()
      assert Workspace.list_swarm_licenses() == [swarm_license]
    end

    test "get_swarm_license!/1 returns the swarm_license with given id" do
      swarm_license = swarm_license_fixture()
      assert Workspace.get_swarm_license!(swarm_license.id) == swarm_license
    end

    test "create_swarm_license/1 with valid data creates a swarm_license" do
      valid_attrs = %{status: 42, swarm_size: 42, nbr_of_generations: 42, drone_depth: 42, generation_epoch_in_minutes: 42, select_best_count: 42, cost_in_tokens: 42, tokens_used: 42, total_run_time_in_seconds: 42, budget_in_tokens: 42}

      assert {:ok, %SwarmLicense{} = swarm_license} = Workspace.create_swarm_license(valid_attrs)
      assert swarm_license.status == 42
      assert swarm_license.swarm_size == 42
      assert swarm_license.nbr_of_generations == 42
      assert swarm_license.drone_depth == 42
      assert swarm_license.generation_epoch_in_minutes == 42
      assert swarm_license.select_best_count == 42
      assert swarm_license.cost_in_tokens == 42
      assert swarm_license.tokens_used == 42
      assert swarm_license.total_run_time_in_seconds == 42
      assert swarm_license.budget_in_tokens == 42
    end

    test "create_swarm_license/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workspace.create_swarm_license(@invalid_attrs)
    end

    test "update_swarm_license/2 with valid data updates the swarm_license" do
      swarm_license = swarm_license_fixture()
      update_attrs = %{status: 43, swarm_size: 43, nbr_of_generations: 43, drone_depth: 43, generation_epoch_in_minutes: 43, select_best_count: 43, cost_in_tokens: 43, tokens_used: 43, total_run_time_in_seconds: 43, budget_in_tokens: 43}

      assert {:ok, %SwarmLicense{} = swarm_license} = Workspace.update_swarm_license(swarm_license, update_attrs)
      assert swarm_license.status == 43
      assert swarm_license.swarm_size == 43
      assert swarm_license.nbr_of_generations == 43
      assert swarm_license.drone_depth == 43
      assert swarm_license.generation_epoch_in_minutes == 43
      assert swarm_license.select_best_count == 43
      assert swarm_license.cost_in_tokens == 43
      assert swarm_license.tokens_used == 43
      assert swarm_license.total_run_time_in_seconds == 43
      assert swarm_license.budget_in_tokens == 43
    end

    test "update_swarm_license/2 with invalid data returns error changeset" do
      swarm_license = swarm_license_fixture()
      assert {:error, %Ecto.Changeset{}} = Workspace.update_swarm_license(swarm_license, @invalid_attrs)
      assert swarm_license == Workspace.get_swarm_license!(swarm_license.id)
    end

    test "delete_swarm_license/1 deletes the swarm_license" do
      swarm_license = swarm_license_fixture()
      assert {:ok, %SwarmLicense{}} = Workspace.delete_swarm_license(swarm_license)
      assert_raise Ecto.NoResultsError, fn -> Workspace.get_swarm_license!(swarm_license.id) end
    end

    test "change_swarm_license/1 returns a swarm_license changeset" do
      swarm_license = swarm_license_fixture()
      assert %Ecto.Changeset{} = Workspace.change_swarm_license(swarm_license)
    end
  end
end
SwarmLicenseSwarmLicense
