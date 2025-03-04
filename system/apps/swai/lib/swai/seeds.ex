# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Swai.Repo.insert!(%Swai.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule Swai.Seeds do
  @moduledoc """
  Seeds the database with initial data.
  """
  alias Swai.Repo, as: Repo
  alias Schema.Biotope, as: Biotope
  alias Schema.AlgorithmId, as: AlgorithmId

  @aco_algorithm_id AlgorithmId.aco_algorithm_id()
  @bfo_algorithm_id AlgorithmId.bfo_algorithm_id()
  @neat_algorithm_id AlgorithmId.neat_algorithm_id()
  @bso_algorithm_id AlgorithmId.bso_algorithm_id()
  @pso_algorithm_id AlgorithmId.pso_algorithm_id()
  @cuso_algorithm_id AlgorithmId.cuso_algorithm_id()
  @caho_algorithm_id AlgorithmId.caho_algorithm_id()
  @ico_algorithm_id AlgorithmId.ico_algorithm_id()

  @planet_of_ants_id    "b105f59e-42ce-4e85-833e-d123e36ce943"
  @traders_of_macao_id  "b206f68e-21da-3d85-833e-a234e47ba025"
  @milk_factory_id      "db1563be-b269-4f6c-8ae9-daed364a8624"

  @algorithms [
    %Schema.Algorithm{
      id: @aco_algorithm_id,
      acronym: "ACO",
      name: "Ant Colony Optimization",
      description: "
        Ant Colony Optimization (ACO) is inspired by the foraging behavior of ants, particularly how they find the shortest path between their nest and a food source.
        Ants use pheromones to communicate and mark favorable paths, which helps the colony converge on efficient routes.
        ",
      image_url: "/images/planet_of_ants.jpg",
      definition: "
        # Mechanisms
        Pheromone Trail: Ants deposit pheromones on paths they travel. Other ants are more likely to follow paths with stronger pheromone concentrations.
        Exploration and Exploitation: Ants balance between exploring new paths and exploiting known good paths.
        Pheromone Evaporation: Over time, pheromones evaporate, which helps prevent convergence to suboptimal solutions and encourages exploration.
        Positive Feedback: Paths that lead to good solutions get reinforced by more pheromone deposits, guiding more ants to follow these paths.
        # Process
        Initialization: Initialize the pheromone levels on all possible paths.
        Ant Movement: Each ant moves from the nest to the food source, choosing paths probabilistically based on pheromone levels and path quality.
        Pheromone Update: After finding a food source, ants return to the nest, depositing pheromones on the paths they took.
        The amount of pheromone deposited is proportional to the quality of the path (e.g., shorter paths get more pheromones).
        Evaporation: Periodically reduce the pheromone levels on all paths to simulate evaporation.
        Iteration: Repeat the process for a number of iterations, allowing the colony to gradually converge on the shortest path.
        # Key Components:
        Pheromone Matrix: A matrix that keeps track of the pheromone levels on all possible paths.
        Probability Function: A function that determines the probability of an ant choosing a specific path based on pheromone levels and path quality.
        Pheromone Update Rule: A rule that specifies how much pheromone to deposit on paths based on the quality of the solution found.
        Evaporation Rate: A parameter that controls how quickly pheromones evaporate, balancing exploration and exploitation.
        ",
      tags: "optimization, ants, foraging, combinatorial optimization"
    },
    %Schema.Algorithm{
      id: @bfo_algorithm_id,
      acronym: "BFO",
      name: "Bacterial Foraging Optimization",
      description:
        "Bacterial Foraging Optimization (BFO) is a metaheuristic optimization algorithm inspired by the foraging behavior of bacteria.
        BFO is used to solve optimization problems.",
      image_url: "/images/bfo.jpg",
      definition:
        "Bacterial Foraging Optimization (BFO) is a metaheuristic optimization algorithm inspired by the foraging behavior of bacteria.
        BFO is used to solve optimization problems.",
      tags: "optimization, bacteria, foraging"
    },
    %Schema.Algorithm{
      id: @neat_algorithm_id,
      acronym: "NEAT",
      name: "NeuroEvolution of Augmenting Topologies",
      description:
        "NeuroEvolution of Augmenting Topologies (NEAT) is a genetic algorithm used to evolve artificial neural networks. NEAT is used to solve optimization problems.",
      image_url: "/images/neat.jpg",
      definition:
        "NeuroEvolution of Augmenting Topologies (NEAT) is a genetic algorithm used to evolve artificial neural networks. NEAT is used to solve optimization problems.",
      tags: "optimization, neural networks, genetic algorithm"
    },
    %Schema.Algorithm{
      id: @bso_algorithm_id,
      acronym: "BSO",
      name: "Bee Swarm Optimization",
      description:
        "Bee Swarm Optimization (BSO) is a metaheuristic optimization algorithm inspired by the foraging behavior of bees. BSO is used to solve optimization problems.",
      image_url: "/images/bso.jpg",
      definition:
        "Bee Swarm Optimization (BSO) is a metaheuristic optimization algorithm inspired by the foraging behavior of bees. BSO is used to solve optimization problems.",
      tags: "optimization, bees, foraging"
    },
    %Schema.Algorithm{
      id: @pso_algorithm_id,
      acronym: "PSO",
      name: "Particle Swarm Optimization",
      description:
        "Particle Swarm Optimization (PSO) is a metaheuristic optimization algorithm inspired by the foraging behavior of birds. PSO is used to solve optimization problems.",
      image_url: "/images/pso.jpg",
      definition:
        "Particle Swarm Optimization (PSO) is a metaheuristic optimization algorithm inspired by the foraging behavior of birds. PSO is used to solve optimization problems.",
      tags: "optimization, birds, foraging"
    },
     %Schema.Algorithm{
      id: @cuso_algorithm_id,
      acronym: "CuSO",
      name: "Cuckoo Search Optimization",
      description:
        "Cuckoo Search Optimization (CHO) is a metaheuristic optimization algorithm inspired by the brood parasitism of some cuckoo species. CHO is used to solve optimization problems.",
      image_url: "/images/cho.jpg",
      definition:
        "Cuckoo Search Optimization (CHO) is a metaheuristic optimization algorithm inspired by the brood parasitism of some cuckoo species. CHO is used to solve optimization problems.",
      tags: "optimization, cuckoo, brood parasitism"
    },
   %Schema.Algorithm{
      id: @ico_algorithm_id,
      acronym: "ICO",
      name: "Investor's Club Optimization",
      description: "
        Investor's Club Optimization (ICO) is inspired by the behavior of investors in the stock market.
        The algorithm seeks to optimize the Return on Investment of the interactions between investors, their decisions, and the overall performance of the club's investments.
        Participants in the club can buy, sell, and hold stocks based on their strategies and the market conditions.
        In order for the particles deemed fit, they must be able to generate a  minimum profit for the club.
        ",
      image_url: "/images/trade_wars1.jpg",
      definition:
        "Investor's Club Optimization (CHO) is a metaheuristic optimization algorithm inspired by the behavior of an investment club. ICO is used train a swarm to optimize the return on investment.",
      tags: "optimization, money, investment, stocks, finance"
    },
    %Schema.Algorithm{
      id: @caho_algorithm_id,
      acronym: "CaHO",
      name: "Cattle Herding Optimization",
      description:
        "The algorithm is inspired by the behaviors of a herd of cows and bulls, including procreation, foraging for grass, and milk production.",
      image_url: "/images/gso.jpg",
      definition: "# Mechanism
            Foraging: Cows and bulls move around the pasture to find the best grass. This could be similar to the chemotaxis in BFO, where they move towards areas with richer grass.
            Procreation: Healthier and well-nourished cows and bulls reproduce, introducing new members to the herd. This mimics the reproduction step in BFO.
            Milk Production: The quality of grass eaten affects milk production, which can be seen as a measure of fitness.
            Swarming: Cows and bulls tend to move in groups (herding behavior), which is similar to the swarming behavior in BFO.
            Communication: Cows might have some basic form of communication to indicate good grazing spots, similar to the waggle dance in BSO.
            # Process
            Initialization: Start with an initial population of cows and bulls with random positions in the pasture.
            Foraging Behavior: Each member of the herd moves in the pasture to find the best grass. The movement could be influenced by local grass quality (akin to chemotaxis).
            Fitness Evaluation: Evaluate the fitness of each cow and bull based on the grass quality and amount of milk produced.
            Reproduction: Select the healthiest cows and bulls to reproduce, introducing new calves to the herd.
            Herding: Introduce herding behavior where groups of cows and bulls move together to explore new areas of the pasture.
            Elimination and Dispersal: Occasionally, some members of the herd might move to entirely new areas of the pasture to prevent local overgrazing and introduce diversity.
            # Key Components
            Fitness Function: A function that evaluates the fitness of each cow and bull based on the grass consumed and milk produced.
            Movement Strategy: A strategy that determines how cows and bulls move in the pasture, influenced by local grass quality.
            Reproduction Mechanism: A mechanism that selects the best cows and bulls for reproduction based on their fitness.
            Herding Behavior: A behavior that ensures cows and bulls move in groups to find the best grazing spots efficiently.
            Diversity Introduction: Occasionally move some members of the herd to new areas to explore different parts of the pasture.
            ",
      tags: "optimization, gravity, celestial bodies"
    }
  ]

  @biotopes [
    %Biotope{
      id: @planet_of_ants_id,
      algorithm_id: @aco_algorithm_id,
      algorithm_acronym: "ACO",
      algorithm_name: "Ant Colony Optimization",
      name: "Planet of Ants",
      description:
        "Planet of Ants is a simulation of an ant colony.
        The ecosystem is fed by weather data and the ants can forage for food and reproduce.
        Each virtual colony generates a stream of foraging data that can be used for downstream applications.",
      image_url: "/images/planet_of_ants.jpg",
      theme: "nature",
      tags: "ants, colony, foraging, insects, nature",
      objectives: "The objective is to forage for food and keep the colony healthy.",
      environment: "The environment is an ant colony.",
      challenges: "The challenges are to keep the ants healthy and productive.",
      is_active?: true,
      is_realistic?: true
    },
     %Biotope{
      id: @traders_of_macao_id,
      algorithm_id: @ico_algorithm_id,
      algorithm_acronym: "ICO",
      algorithm_name: "Investor's Club Optimization",
      name: "Traders of Macao",
      description:
        "Traders of Macao is a simulation of an investment club.",
      image_url: "/images/trade_wars1.jpg",
      theme: "MONEY",
      tags: "stocks, investment, finance, money",
      objectives:
        "The objective is to optimize the return on investment of the club's portfolio.",
      environment: "The environment is the real world. This ecosystem will get its input data in near-real time from a number of trading systems.",
      challenges: "The challenges are to make the right investment decisions and manage the club's portfolio.",
      is_active?: false,
      is_realistic?: true
    },
   %Biotope{
      id: @milk_factory_id,
      algorithm_id: @caho_algorithm_id,
      algorithm_acronym: "CaHO",
      algorithm_name: "Cattle Herding Optimization",
      name: "The Milk Factory",
      description:
        "The Milk Factory is a simulation of a dairy farm.
        The ecosystem is fed by weather data and the cows can be milked and reproduce.
        Each virtual farm generates a stream of milking data that can be used for downstream applications.",
      image_url: "/images/dairy_wars1.jpg",
      theme: "agriculture",
      tags: "dairy, cows, milk, farm, agriculture",
      objectives:
        "The objective is to produce as much milk as possible, while keeping a healthy herd.",
      environment: "The environment is a dairy farm.",
      challenges: "The challenges are to keep the cows healthy and productive.",
      is_active?: false,
      is_realistic?: true
    }
  ]

  def run do
    seed_algorithms()
    seed_biotopes()
  end

  defp seed_algorithm(%Schema.Algorithm{} = algorithm) do
    case Repo.get_by(Schema.Algorithm, acronym: algorithm.acronym) do
      nil ->
        Repo.insert!(algorithm)

      _ ->
        :ok
    end
  end

  defp seed_algorithms() do
    @algorithms
    |> Enum.each(&seed_algorithm/1)
  end

  ############################# BIOTOPES ########################################

  def seed_biotopes do
    @biotopes
    |> Enum.each(&seed_biotope/1)
  end

  defp seed_biotope(%Biotope{} = biotope) do
    case Repo.get_by(Biotope, name: biotope.name) do
      nil ->
        Repo.insert!(biotope)

      _ ->
        :ok
    end
  end
end
