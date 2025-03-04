defmodule Swai.SwarmsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Swai.Swarms` context.
  """

  @doc """
  Generate a swarm.
  """
  def swarm_fixture(attrs \\ %{}) do
    {:ok, swarm} =
      attrs
      |> Enum.into(%{
        biotope_id: "some biotope_id",
        description: "some description",
        edge_id: "some edge_id",
        name: "some name",
        status: 42,
        user_id: "some user_id"
      })
      |> Swai.Swarms.create_swarm()

    swarm
  end
end
