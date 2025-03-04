defmodule Edge.Facts do
  @moduledoc """
  Edge.Facts contains the facts for the Edge subsystem.
  """
  def edge_facts, do: "edge_facts"
  def edges_cache_facts, do: "edges_cache_facts"

  def initializing_edge_v1, do: "initializing_edge:v1"

  def edge_initialized_v1, do: "edge_initialized:v1"

  def edge_attached_v1, do: "edge_attached:v1"

  def edge_detached_v1, do: "edge_detached:v1"

  def presence_changed_v1, do: "presence_changed:v1"

  def license_presented_v1, do: "license_presented:v1"

  def hive_vacancy_requested_v1, do: "hive_vacancy_requested:v1"
end
