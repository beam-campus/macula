defmodule Schema.Arena.Player do
  @moduledoc """
  Swai.Schema.Arena.Player contains the Ecto schema for the Player.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Schema.Arena.Player, as: Player

  @all_fields [
    :id,
    :user_id,
    :color,
    :swarm_id,
    :name,
    :image_url,
    :swarm,
    
  ]

end
