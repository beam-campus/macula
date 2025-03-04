defmodule Swai.WorkspaceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Swai.Workspace` context.
  """

  @doc """
  Generate a swarm_license.
  """
  def swarm_license_fixture(attrs \\ %{}) do
    {:ok, swarm_license} =
      attrs
      |> Enum.into(%{
        budget_in_tokens: 42,
        cost_in_tokens: 42,
        drone_depth: 42,
        generation_epoch_in_minutes: 42,
        nbr_of_generations: 42,
        select_best_count: 42,
        status: 42,
        swarm_size: 42,
        tokens_used: 42,
        total_run_time_in_seconds: 42
      })
      |> Swai.Workspace.create_swarm_license()

    swarm_license
  end
end
