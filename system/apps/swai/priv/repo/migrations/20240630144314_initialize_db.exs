defmodule Swai.Repo.Migrations.InitializeDb do
  use Ecto.Migration

  def change do
    create table(:algorithms, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:acronym, :string)
      add(:name, :string)
      add(:description, :text)
      add(:image_url, :string)
      add(:definition, :text)
      add(:tags, :string)
      timestamps(type: :utc_datetime_usec)
    end

    create table(:biotopes, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:algorithm_id, :binary_id)
      add(:algorithm_name, :string)
      add(:algorithm_acronym, :string)
      add(:name, :string)
      add(:description, :text)
      add(:image_url, :string)
      add(:theme, :string)
      add(:tags, :string)
      add(:objectives, :string)
      add(:challenges, :string)
      add(:environment, :text)
      add(:is_active?, :boolean, default: false)
      add(:is_realistic?, :boolean, default: false)
      timestamps(type: :utc_datetime_usec)
    end

    create table(:biotope_maps, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:biotope_id, :binary_id)
      add(:biotope_name, :string)
      add(:map_id, :binary_id)
      add(:map_name, :string)
      add(:map_url, :string)
      add(:map_image_url, :string)
      add(:map_description, :text)
      add(:map_tags, :string)
      add(:is_active?, :boolean, default: false)
      timestamps(type: :utc_datetime_usec)
    end

    create table(:swarm_licenses, primary_key: false) do
      add(:license_id, :binary_id, primary_key: true)
      add(:status, :integer)
      add(:user_id, :binary_id)

      add(:algorithm_id, :binary_id)
      add(:algorithm_name, :string)
      add(:algorithm_acronym, :string)

      add(:biotope_id, :binary_id)
      add(:biotope_name, :string)

      add(:swarm_id, :binary_id)
      add(:swarm_name, :string)
      add(:swarm_size, :integer)
      add(:swarm_time_min, :integer)
      add(:cost_in_tokens, :integer)

      add(:tokens_used, :integer)
      add(:run_time_sec, :integer)
      add(:available_tokens, :integer)

      add(:tokens_balance, :integer, default: 0)
      timestamps(type: :utc_datetime_usec)
    end

    # a Scape is the session of a swarm
    create table(:scapes, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:license_id, :binary_id)
      add(:status, :integer)
      add(:user_id, :binary_id)
      add(:edge_id, :binary_id)

      add(:algorithm_id, :binary_id)
      add(:algorithm_name, :string)
      add(:algorithm_acronym, :string)

      add(:biotope_id, :binary_id)
      add(:biotope_name, :string)

      add(:map_id, :binary_id)
      add(:map_name, :string)
      add(:map_url, :string)
      add(:map_image_url, :string)

      add(:swarm_id, :binary_id)
      add(:swarm_name, :string)
      add(:swarm_size, :integer)
      add(:swarm_time_min, :integer)
      add(:cost_in_tokens, :integer)

      add(:tokens_used, :integer)
      add(:run_time_sec, :integer)
      add(:available_tokens, :integer)

      timestamps(type: :utc_datetime_usec)
    end

    create(index(:swarm_licenses, [:user_id]))
    create(index(:swarm_licenses, [:biotope_id]))

    create table(:swarms, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:user_id, :string)
      add(:name, :string)
      add(:description, :text)

      add(:status, :integer)
      add(:biotope_id, :string)
      add(:size, :integer, default: 10)
      timestamps(type: :utc_datetime_usec)
    end

    create table(:drone_orders, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:description, :string)
      add(:quantity, :integer)
      add(:price_in_cents, :integer)
      add(:currency, :string)
      add(:status, :integer)
      add(:user_id, references(:users, on_delete: :nothing, type: :binary_id))

      timestamps(type: :utc_datetime_usec)
    end

    create(index(:drone_orders, [:user_id]))
  end
end
