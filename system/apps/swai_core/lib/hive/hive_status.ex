defmodule Hive.Status do

  require Flags
  def unknown, do: 0
  def hive_initialized, do: 1
  def hive_configured, do: 2
  def hive_active, do: 4
  def hive_inactive, do: 8
  def hive_vacant, do: 16
  def hive_occupied, do: 32
  def hive_available, do: 64
  def hive_reserved, do: 128

  def map,
    do: %{
      unknown() => "unknown",
      hive_initialized() => "initialized",
      hive_configured() => "configured",
      hive_active() => "active",
      hive_inactive() => "inactive",
      hive_vacant() => "vacant",
      hive_occupied() => "occupied",
      hive_available() => "available",
      hive_reserved() => "reserved"
    }

    def to_list(status) do
      Flags.to_list(status, map())
    end

    def to_string(status) do
      Flags.to_string(status, map())
    end


end
