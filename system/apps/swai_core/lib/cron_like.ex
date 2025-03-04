##########################################################################################################
#  Leeched from https://stackoverflow.com/questions/69839878/how-to-create-periodical-timer-with-elixir  #
##########################################################################################################
defmodule Cronlike do
  use GenServer

  @moduledoc """
  Cronlike is the module that contains the cronlike functionality
  """
  @allowed_units [:second, :minute, :hour, :day]

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  @impl true
  def init(%{interval: interval, unit: unit} = state)
      when is_integer(interval) and interval > 0 and unit in @allowed_units do
    # wait, bang:
    Process.send_after(self(), :tick, to_ms(interval, unit))
    # bang, wait:
    # send(self(), :tick, to_ms(interval, unit))

    {:ok, state}
  end

  @impl true
  def handle_info(
        :tick,
        %{interval: interval, unit: unit, callback_function: callback_function, caller_state: caller_state} = state
      ) do
    case callback_function.(caller_state) do
      :cancel -> send(self(), :quit)
      _ -> nil
    end

    Process.send_after(self(), :tick, to_ms(interval, unit))
    {:noreply, state}
  end

  def handle_info(:quit, state) do
    {:stop, :normal, state}
  end

  defp to_ms(interval, :second), do: interval * 1000
  defp to_ms(interval, :minute), do: to_ms(interval, :second) * 60
  defp to_ms(interval, :hour), do: to_ms(interval, :minute) * 60
  defp to_ms(interval, :day), do: to_ms(interval, :hour) * 24
end
