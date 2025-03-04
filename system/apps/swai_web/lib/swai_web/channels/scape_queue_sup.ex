defmodule SwaiWeb.LicenseQueueSup do
  @moduledoc """
  The LicenseQueueSup is used to broadcast messages to all clients
  """
  use Supervisor
  alias SwaiWeb.LicenseQueue, as: LicenseQueue
  require Logger

  def start_link(_init_arg) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def start_queue(biotope_id) do
    Supervisor.start_child(
      __MODULE__,
      {SwaiWeb.LicenseQueue, biotope_id}
    )
  end

  def init(:ok) do

    children = [
      LicenseQueue
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end


end
