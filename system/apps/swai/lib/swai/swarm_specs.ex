defmodule Swai.SwarmSpecs do

  
  alias Schema.RequestToSwarm, as: SwarmSpec


  def with_biotope(%SwarmSpec{} = seed, biotope) do
    %SwarmSpec{ seed |
      biotope_id: biotope.id,
    }
  end

  def with_edge(%SwarmSpec{} = seed, edge) do
    %SwarmSpec{ seed |
      edge_id: edge.id,
    }
  end

  def with_license(%SwarmSpec{} = seed, license) do
    %SwarmSpec{ seed |
      license_id: license.id,
    }
  end

  def with_user(%SwarmSpec{} = seed, user) do
    %SwarmSpec{ seed |
      user_id: user.id,
    }
  end





end
