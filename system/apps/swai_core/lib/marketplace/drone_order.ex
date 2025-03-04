defmodule Schema.DroneOrder do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "drone_orders" do
    field(:status, :integer)
    field(:description, :string)
    field(:currency, :string)
    field(:quantity, :integer)
    field(:price_in_cents, :integer)
    belongs_to(:user, Schema.User, foreign_key: :user_id, type: :binary_id)

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(drone_order, attrs) do
    drone_order
    |> cast(attrs, [:description, :quantity, :price_in_cents, :currency, :status])
    |> validate_required([:description, :quantity, :price_in_cents, :currency, :status])
  end
end
