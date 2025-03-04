defmodule NameUtils do
  @moduledoc """
  NameUtils contains utility functions for generating names.
  """
  def random_name(n) do
    MnemonicSlugs.generate_slug(n)
    |> String.split("-")
    |> Enum.map_join(" ", &String.capitalize/1)
  end
end
