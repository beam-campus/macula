defmodule Edge.Status do
  @moduledoc """
  The schema module for the edge status.
  """

    def unknown, do: 0
    def edge_initializing, do: 1
    def edge_initialized, do: 2
    def edge_attached, do: 4
    def edge_detached, do: 8

    def map, do: %{
    unknown() =>  "unknown",
    edge_initializing() => "edge_initializing",
    edge_initialized() => "edge_initialized",
    edge_attached() => "edge_attached",
    edge_detached() => "edge_detached"
  }

  def flags, do: %{
      unknown: unknown(),
      edge_initializing: edge_initializing(),
      edge_initialized: edge_initialized(),
      edge_attached: edge_attached(),
      edge_detached: edge_detached()
    }
end
