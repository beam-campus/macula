defmodule Schema.SwarmLicense.Status do
  @moduledoc """
  The status flags for the swarm licenses.
  """
  require Flags

  def unknown, do: 0

  def license_initialized, do: 1
  def license_configured, do: 2
  def license_active, do: 4
  def license_inactive, do: 8
  def license_paid, do: 16
  def license_blocked, do: 32
  def license_reserved, do: 64
  def license_queued, do: 128
  def license_started, do: 256
  def license_paused, do: 512
  def license_cancelled, do: 1024
  def license_completed, do: 2048

  def map,
    do: %{
      unknown() => "unknown",
      license_initialized() => "initialized",
      license_configured() => "configured",
      license_active() => "active",
      license_inactive() => "inactive",
      license_paid() => "paid",
      license_blocked() => "blocked",
      license_queued() => "queued",
      license_reserved() => "reserved",
      license_started() => "started",
      license_paused() => "paused",
      license_cancelled() => "cancelled",
      license_completed() => "completed"
    }

  def style,
    do: %{
      unknown() => "bg-gray-500 text-white",
      license_initialized() => "bg-yellow-500 text-white",
      license_configured() => "bg-green-200 text-white",
      license_paid() => "bg-green-500 text-white",
      license_blocked() => "bg-orange-500 text-white",
      license_queued() => "bg-blue-200 text-white",
      license_reserved() => "bg-orange-500 text-white",
      license_started() => "bg-blue-500 text-white",
      license_paused() => "bg-orange-200 text-white",
      license_cancelled() => "bg-red-500 text-white",
      license_completed() => "bg-blue-800 text-white"
    }

  def to_list(status), do: Flags.to_list(status, map())
  def highest(status), do: Flags.highest(status, map())
  def lowest(status), do: Flags.lowest(status, map())
  def to_string(status), do: Flags.to_string(status, map())

  def decompose(status), do: Flags.decompose(status)
end
