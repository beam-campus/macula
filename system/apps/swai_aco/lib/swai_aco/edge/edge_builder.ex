defmodule Edge.Builder do
  @moduledoc """
  Edge.Builder is a GenServer that manages a channel to a scape,
  """
  use GenServer

  @impl true
  def init(edge_init) do
    
    {:ok, edge_init}
  end



end
