defmodule Particle.Emitter do
  @moduledoc false

  alias Particle.Facts, as: ParticleFacts
  alias Particle.Init, as: Particle
  alias Edge.Client, as: EdgeClient
  alias Macula.Ringcaster, as: RingCaster

  @particle_spawned_v1 ParticleFacts.particle_spawned_v1()
  @particle_changed_v1 ParticleFacts.particle_changed_v1()
  @particle_died_v1 ParticleFacts.particle_died_v1()

  def emit_particle_spawned(%Particle{edge_id: edge_id} = particle) do
    EdgeClient.publish(
      edge_id,
      @particle_spawned_v1,
      %{particle_init: particle}
    )
  end

  def emit_particle_changed(%Particle{edge_id: edge_id} = particle) do
    EdgeClient.publish(
      edge_id,
      @particle_changed_v1,
      %{particle_init: particle}
    )
  end

 

  def emit_particle_died(%Particle{edge_id: edge_id} = particle) do
    EdgeClient.publish(
      edge_id,
      @particle_died_v1,
      %{particle_init: particle}
    )
  end
end
