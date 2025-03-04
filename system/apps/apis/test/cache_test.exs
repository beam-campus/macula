defmodule Apis.CountriesTest do
  use ExUnit.Case

  @moduledoc """
  Tests for the Apis.Countries module.
  """

  alias Apis.Countries, as: Cache

  @tag :ignore_test
  doctest Cache

  @tag :ignore_test
  test "that the Apis.RestCountries.Client module exists" do
    assert is_list(Cache.module_info())
  end

  @tag :ignore_test
  test "that we can get the countries" do
    res = Cache.all_countries()
    assert res != nil
  end

  @tag :ignore_test
  test "that we can start the Countries Cache" do
    res = Cache.start_link([])
    assert res != nil
  end

  test "that we can get the regions" do
    res = Cache.all_regions()
    assert res != nil
  end

end
