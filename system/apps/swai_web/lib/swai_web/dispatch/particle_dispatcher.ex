defmodule SwaiWeb.ParticleDispatcher do
  @moduledoc false

  alias Particle.Facts, as: ParticleFacts
  alias Particle.Init, as: ParticleInit
  alias Phoenix.PubSub, as: PubSub

  @particle_facts ParticleFacts.particle_facts()
  @particle_spawned_v1 ParticleFacts.particle_spawned_v1()
  @particle_changed_v1 ParticleFacts.particle_changed_v1()
  @particle_died_v1 ParticleFacts.particle_died_v1()

  def pub_particle_spawned(envelope) do
    {:ok, particle} =
      ParticleInit.from_map(%ParticleInit{}, envelope["particle_init"])

    Swai.PubSub
    |> PubSub.broadcast(@particle_facts, {:particle, @particle_spawned_v1, particle})
  end

  def pub_particle_changed(envelope) do
    particle =
      case ParticleInit.from_map(%ParticleInit{}, envelope["particle_init"]) do
        {:ok, particle} -> 
          particle
        {:error, changeset} -> 
          Logger.error("Invalid particle: #{inspect(changeset, pretty: true)}")
          nil
      end

    Swai.PubSub
    |> PubSub.broadcast(@particle_facts, {:particle, @particle_changed_v1, particle})
  end

  def pub_particle_died(envelope) do
    {:ok, particle} =
      ParticleInit.from_map(%ParticleInit{}, envelope["particle_init"])

    Swai.PubSub
    |> PubSub.broadcast(@particle_facts, {:particle, @particle_died_v1, particle})
  end
end
