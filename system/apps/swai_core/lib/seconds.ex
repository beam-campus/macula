defmodule Seconds do


  @moduledoc """
  This module provides functions to convert seconds to hh:mm:ss format
  """


  @one_minute 60
  @one_hour 3600

  def to_hh_mm_ss(0),
    do: "00h00m00s"

  def to_hh_mm_ss(seconds) when seconds >= @one_hour do
    h = div(seconds, @one_hour)

    m =
      seconds
      |> rem(@one_hour)
      |> div(@one_minute)
      |> pad_int()

    s =
      seconds
      |> rem(@one_hour)
      |> rem(@one_minute)
      |> pad_int()

    "#{h}h#{m}m#{s}s"
  end

  def to_hh_mm_ss(seconds) do
    m = div(seconds, @one_minute)
        |> pad_int()

    s =
      seconds
      |> rem(@one_minute)
      |> pad_int()

    "00h#{m}m#{s}s"
  end

  defp pad_int(int, padding \\ 2) do
    int
    |> Integer.to_string()
    |> String.pad_leading(padding, "0")
  end
end
