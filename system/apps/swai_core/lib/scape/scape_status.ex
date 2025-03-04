defmodule Scape.Status do
  @moduledoc """
  Status is an enum that represents the status of a Scape.
  """

  def unknown, do: 524_288
  def initializing, do: 1_048_576
  def initialized, do: 2_097_152
  def attached, do: 134_217_728
  def detached, do: 268_435_456

  def map,
    do: %{
      unknown() => "unknown",
      initializing() => "initializing",
      initialized() => "initialized",
      attached() => "attached",
      detached() => "detached"
    }

  def style,
    do: %{
      unknown() => "bg-gray-500 text-white",
      initializing() => "bg-yellow-500 text-white",
      initialized() => "bg-green-200 text-white",
      attached() => "bg-green-500 text-white",
      detached() => "bg-orange-500 text-white"
    }

  def to_list(status), do: Flags.to_list(status, map())
  def highest(status), do: Flags.highest(status, map())
  def lowest(status), do: Flags.lowest(status, map())
  def to_string(status), do: Flags.to_string(status, map())

  def decompose(status), do: Flags.decompose(status)
end
