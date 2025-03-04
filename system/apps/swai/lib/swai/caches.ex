defmodule Caches do
  def licenses, do: :licenses_cache
  def edges, do: :edges_cache
  def scapes, do: :scapes_cache
  def arenas, do: :arenas_cache
  def hives, do: :hives_cache
  def swarms, do: :swarms_cache
  def particles, do: :particles_cache
  def rings, do: :rings_cache

  def licenses_path, do: "/volume/caches/swai_licenses.cache"
  def edges_path, do: "/volume/caches/swai_edges.cache"
  def scapes_path, do: "/volume/caches/swai_scapes.cache"
  def arenas_path, do: "/volume/caches/swai_arenas.cache"
  def hives_path, do: "/volume/caches/swai_hives.cache"
  def swarms_path, do: "/volume/caches/swai_swarms.cache"
  def particles_path, do: "/volume/caches/swai_particles.cache"

end
