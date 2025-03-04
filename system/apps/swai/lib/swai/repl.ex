defmodule Repl do
  @moduledoc """
  Swai.ReplInspector contains the REPL inspector.
  """

  alias Farms.Service, as: Farms
  alias Lives.Service, as: Lives
  alias Cells.Service, as: Cells

  require Logger

  def get_lives_for_random_mng_farm_id() do
    [%{id: mng_farm_id} = _mng_farm | _rest] =
      Farms.get_all()
      |> Enum.take(1)

    Logger.info("get_lives_for_random_mng_farm_id: mng_farm_id: #{mng_farm_id}")

    Lives.get_by_mng_farm_id(mng_farm_id)
  end

  def build_fields_for_random_farm() do
    farm =
      Farms.get_all()
      |> Enum.random()

    Farms.build_fields(farm)
  end

  def get_cell_states_for_random_farm() do
    farm =
      Farms.get_all()
      |> Enum.random()

    Cells.get_cell_states(farm.id)
  end

  def get_all_farms() do
    Farms.get_all()
  end

  def get_all_lives() do
    Lives.get_all()
  end
end
