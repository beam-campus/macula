defmodule EdgeRepl do
  @moduledoc false

  alias Particle.Init, as: ParticleInit
  alias Particle.System, as: ParticleSystem
  alias Arena.Hexa, as: Hexa

  def particle1, do: %ParticleInit{particle_id: "particle1", hive_id: "hive1", age: 0, health: 100, energy: 100, ticks: 0, hexa: Hexa.new(0, 0)}
  def particle2, do: %ParticleInit{particle_id: "particle2", hive_id: "hive1", age: 0, health: 100, energy: 100, ticks: 0, hexa: Hexa.new(0, 0)}


  def start_particle(%{particle_id: particle_id} = particle) do
    case ParticleSystem.start(particle) do
      {:ok, _} -> IO.puts("Particle [#{particle_id}] started")
      {:error, _} -> IO.puts("Particle [#{particle_id}] failed to start")
    end
  end
  
end
