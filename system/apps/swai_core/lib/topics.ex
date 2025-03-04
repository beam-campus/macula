defmodule Life.Topics do
  @moduledoc """
  Topics is a collection of all topics used in the system.
  """

@life_born_v1 "life:born:v1"
@life_died_v1 "life:died:v1"
@life_sanitized_v1 "life:sanitized:v1"
@life_infected_v1 "life:infected:v1"
@life_healed_v1 "life:healed:v1"
@life_moved_v1 "life:moved:v1"
@life_inseminated_v1 "life:inseminated:v1"
@life_slaughtered_v1 "life:slaughtered:v1"
@life_milked_v1 "life:milked:v1"


  ############# LIFE FACTS ################
  def born_v1, do: @life_born_v1
  def died_v1, do: @life_died_v1
  def sanitized_v1, do: @life_sanitized_v1
  def infected_v1, do:  @life_infected_v1
  def healed_v1, do: @life_healed_v1
  def moved_v1, do: @life_moved_v1
  def inseminated_v1, do: @life_inseminated_v1
  def slaughtered_v1, do: @life_slaughtered_v1
  def milked_v1, do: @life_milked_v1
end
