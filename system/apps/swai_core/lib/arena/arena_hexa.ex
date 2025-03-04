defmodule Arena.Hexa do
  @moduledoc """
  Swai.Schema.Arena.Hexa contains the Ecto schema for the Hexa.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Arena.Hexa, as: Hexa
  alias Swai.Defaults, as: Defaults

  require Logger
  require Jason.Encoder

  @hexa_directions Defaults.hexa_directions()
  @hexa_reverse_directions Defaults.hexa_reverse_directions()

  @all_fields [:q, :r]

  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:q, :integer, default: 0)
    field(:r, :integer, default: 0)
  end

  def directive(from, to),
    do: @hexa_reverse_directions[{to.q - from.q, to.r - from.r}]

  def changeset(seed, nil),
    do: {:ok, seed}

  def changeset(hexa, attrs)
      when is_struct(attrs),
      do: changeset(hexa, Map.from_struct(attrs))

  def changeset(hexa, attrs)
      when is_map(attrs) do
    hexa
    |> cast(attrs, @all_fields)
    |> validate_required(@all_fields)
  end

  def from_map(seed, attrs) do
    case changeset(seed, attrs) do
      %{valid?: true} = changes ->
        {:ok, apply_changes(changes)}

      changeset ->
        Logger.error("Failed to create hexa: #{inspect(changeset)}")
        {:error, changeset}
    end
  end

  def new(q, r), do: %Hexa{q: q, r: r}
  def cartesian_to_axial(nil, _), do: nil

  def cartesian_to_axial(%{x: x, y: y}, hexagon_size),
    do: %{q: x_to_q(x, hexagon_size), r: y_to_r(y, hexagon_size)}

  def axial_to_cartesian(nil), do: nil

  def axial_to_cartesian(%{q: q, r: r}, hexagon_size),
    do: %{x: q_to_x(q, hexagon_size), y: r_to_y(r, hexagon_size), z: 0.0}

  def distance({q1, r1}, {q2, r2}), do: (abs(q1 - q2) + abs(q1 + r1 - q2 - r2) + abs(r1 - r2)) / 2
  def x_to_q(x, hexagon_size), do: round(x / (hexagon_size * 3 / 2))
  def y_to_r(y, hexagon_size), do: round(y / (hexagon_size * :math.sqrt(3)))
  def q_to_x(q, hexagon_size), do: q * hexagon_size * 3 / 2
  def r_to_y(r, hexagon_size), do: r * hexagon_size * :math.sqrt(3)

  def move_hexa(%Hexa{q: q, r: r}, direction, steps \\ 1)
      when is_integer(steps) and steps >= 0 do
    {dq, dr} = @hexa_directions[direction]
    new_q = q + dq * steps
    new_r = r + dr * steps
    %Hexa{q: new_q, r: new_r}
  end

  def move_multiple_hexa({q, r}, directions, steps)
      when is_integer(steps) and steps >= 0 do
    Enum.reduce(directions, {q, r}, fn direction, {current_q, current_r} ->
      move_hexa({current_q, current_r}, direction, steps)
    end)
  end
end
