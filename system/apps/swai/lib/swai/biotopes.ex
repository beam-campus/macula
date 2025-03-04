defmodule Swai.Biotopes do
  @moduledoc """
  The Biotopes context.
  """

  import Ecto.Query, warn: false

  alias Swai.Repo, as: Repo

  alias Schema.Biotope, as: Biotope

  @doc """
  Returns the list of biotopes.

  ## Examples

      iex> list_biotopes()
      [%Biotope{}, ...]

  """
  def list_biotopes do
    Repo.all(Biotope)
  end

  @doc """
  Gets a single biotope.

  Raises `Ecto.NoResultsError` if the Biotope does not exist.

  ## Examples

      iex> get_biotope!(123)
      %Biotope{}

      iex> get_biotope!(456)
      ** (Ecto.NoResultsError)

  """
  def get_biotope!(id), do: Repo.get!(Biotope, id)

  @doc """
  Creates a biotope.

  ## Examples

      iex> create_biotope(%{field: value})
      {:ok, %Biotope{}}

      iex> create_biotope(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_biotope(attrs \\ %{}) do
    %Biotope{}
    |> Biotope.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a biotope.

  ## Examples

      iex> update_biotope(biotope, %{field: new_value})
      {:ok, %Biotope{}}

      iex> update_biotope(biotope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_biotope(%Biotope{} = biotope, attrs) do
    biotope
    |> Biotope.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a biotope.

  ## Examples

      iex> delete_biotope(biotope)
      {:ok, %Biotope{}}

      iex> delete_biotope(biotope)
      {:error, %Ecto.Changeset{}}

  """
  def delete_biotope(%Biotope{} = biotope) do
    Repo.delete(biotope)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking biotope changes.

  ## Examples

      iex> change_biotope(biotope)
      %Ecto.Changeset{data: %Biotope{}}

  """
  def change_biotope(%Biotope{} = biotope, attrs \\ %{}) do
    Biotope.changeset(biotope, attrs)
  end
end
