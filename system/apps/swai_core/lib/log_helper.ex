defmodule LogHelper do
  require Logger

  def log(result) do
    case result do
      {:ok, _} ->
        Logger.info("\e[32m#{inspect(result)}\e[0m")

      {:error, _} ->
        Logger.error("\e[31m#{inspect(result)}\e[0m")
    end

    result
  end

  defmacro log_reg(key) do
    quote do
      Logger.debug("\e[33m #{inspect(unquote(key))}")
      unquote(key)
    end
  end

  defmacro log_res(result) do
    quote do
      case unquote(result) do
        {:ok, _} ->
          Logger.info("\e[32m#{inspect(unquote(result))}\e[0m")
          unquote(result)

        {:error, _} ->
          Logger.error("\e[31m#{inspect(unquote(result))}\e[0m")
          unquote(result)

        _ ->
          unquote(result)
      end
    end
  end

  defmacro log_spec(spec) do
    quote do
      Logger.info("\e[35m#{inspect(unquote(spec))}\e[0m")
      unquote(spec)
    end
  end

  defmacro to_snake(name) when is_bitstring(name) do
    quote do
      unquote(name)
      |> String.replace(" ", "_")
      |> String.downcase()
    end
  end
end
