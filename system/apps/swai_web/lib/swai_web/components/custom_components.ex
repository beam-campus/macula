defmodule SwaiWeb.CustomComponents do
  use Phoenix.Component

  @moduledoc """
  This module is used to define custom components
  """
  alias Seconds


  attr :now, :any, required: true
  attr :connected_since, :any, required: true
  def duration_stamp(assigns) do
    ~H"""
    <%= td = DateTime.diff(@now, DateTime.from_naive!(@connected_since, "Etc/UTC"), :second)  %>
    <span class="text-xs text-gray-500">
      <%= Seconds.to_hh_mm_ss(td) %>
    </span>
    """
  end






end
