defmodule Swai.Marketplace do
  @moduledoc """
  The Marketplace context.
  """

  import Ecto.Query, warn: false
  alias Swai.Repo

  alias Schema.DroneOrder

  @doc """
  Returns the list of drone_orders.

  ## Examples

      iex> list_drone_orders()
      [%DroneOrder{}, ...]

  """
  def list_drone_orders do
    Repo.all(DroneOrder)
  end

  def list_drone_orders_for_user(user_id) do
    Repo.all(from d in DroneOrder, where: d.user_id == ^user_id)
  end

  def insert_drone_order(%DroneOrder{} = drone_order) do
    Repo.insert(drone_order)
  end

  def update_drone_order(%DroneOrder{} = drone_order) do
    Repo.update(drone_order)
  end

  @doc """
  Gets a single drone_order.

  Raises `Ecto.NoResultsError` if the Drone order does not exist.

  ## Examples

      iex> get_drone_order!(123)
      %DroneOrder{}

      iex> get_drone_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_drone_order!(id), do: Repo.get!(DroneOrder, id)

  @doc """
  Creates a drone_order.

  ## Examples

      iex> create_drone_order(%{field: value})
      {:ok, %DroneOrder{}}

      iex> create_drone_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_drone_order(attrs \\ %{}) do
    %DroneOrder{}
    |> DroneOrder.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a drone_order.

  ## Examples

      iex> update_drone_order(drone_order, %{field: new_value})
      {:ok, %DroneOrder{}}

      iex> update_drone_order(drone_order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_drone_order(%DroneOrder{} = drone_order, attrs) do
    drone_order
    |> DroneOrder.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a drone_order.

  ## Examples

      iex> delete_drone_order(drone_order)
      {:ok, %DroneOrder{}}

      iex> delete_drone_order(drone_order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_drone_order(%DroneOrder{} = drone_order) do
    Repo.delete(drone_order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking drone_order changes.

  ## Examples

      iex> change_drone_order(drone_order)
      %Ecto.Changeset{data: %DroneOrder{}}

  """
  def change_drone_order(%DroneOrder{} = drone_order, attrs \\ %{}) do
    DroneOrder.changeset(drone_order, attrs)
  end
end
