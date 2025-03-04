defmodule Scape.Facts do
  @moduledoc """
  Scape.Facts contains the facts for the Scape subsystem.`
  """
  def scape_facts, do: "scape_facts"

  def scape_initializing_v1, do: "scape_initializing:v1"
  def scape_initialized_v1, do: "scape_initialized:v1"
  def scape_attached_v1, do: "scape_attached:v1"
  def scape_detached_v1, do: "scape_detached:v1"

  def scapes_cache_facts, do: "scapes_cache_facts:v1"
  def scapes_presence_changed_v1, do: "scapes_presence_changed:v1"
end
