defmodule Swai.MarketplaceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Swai.Marketplace` context.
  """

  @doc """
  Generate a drone_order.
  """
  def drone_order_fixture(attrs \\ %{}) do
    {:ok, drone_order} =
      attrs
      |> Enum.into(%{
        currency: "some currency",
        description: "some description",
        price_in_cents: 42,
        quantity: 42,
        status: 42,
        user_id: "some user_id"
      })
      |> Swai.Marketplace.create_drone_order()

    drone_order
  end


end
