defmodule Swai.Born2Died.Die.PayloadV1Test do
  use ExUnit.Case

  doctest Swai.Born2Died.Die.PayloadV1

  alias Swai.Born2Died.Die.PayloadV1

  @tag :life_die_test
  test "new/2" do
    life_id = "life_id"
    age = 1
    cause = :unknown

    payload = PayloadV1.new(life_id, age, cause)

    assert payload.life_id == life_id
    assert payload.age == age
    assert payload.cause == cause
  end
end
