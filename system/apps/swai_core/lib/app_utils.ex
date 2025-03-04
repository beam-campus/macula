defmodule AppUtils do
  @moduledoc """
  AppUtils contains utility functions for the application.
  """
  def running_in_container?,
    do: File.exists?("/.dockerenv")

  def docker_env do
    case running_in_container?() do
      false -> {:error, "Not running in a container"}
      true -> read_docker_env()
    end
  end

  defp read_docker_env do
    File.read!("/.dockerenv")
    |> String.split("\n")
    |> Enum.map(fn line ->
      [key, value] = String.split(line, "=")
      {key, value}
    end)
  end
end
