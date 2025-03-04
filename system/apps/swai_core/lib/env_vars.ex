defmodule EnvVars do
  @moduledoc """
  The EnvVars module is used to define environment variables
  """

  def swai_edge_api_key, do: "SWAI_EDGE_API_KEY"
  def swai_edge_biotope_id, do: "SWAI_EDGE_BIOTOPE_ID"
  def swai_edge_algorithm_acronym, do: "SWAI_EDGE_ALGORITHM_ACRONYM"
  def swai_edge_lat, do: "SWAI_EDGE_LAT"
  def swai_edge_lon, do: "SWAI_EDGE_LON"
  def swai_edge_is_container, do: "SWAI_EDGE_IS_CONTAINER"
  def swai_edge_is_root, do: "SWAI_EDGE_IS_ROOT"
  def swai_edge_country, do: "SWAI_EDGE_COUNTRY"
  def swai_edge_country_code, do: "SWAI_EDGE_COUNTRY_CODE"
  def swai_edge_cca2, do: "SWAI_EDGE_CCA2"
  def swai_edge_city, do: "SWAI_EDGE_CITY"
  def swai_edge_scape_description, do: "SWAI_SCAPE_DESCRIPTION"
  def swai_edge_scape_theme, do: "SWAI_SCAPE_THEME"
  def swai_edge_scape_image_url, do: "SWAI_SCAPE_IMAGE_URL"
  def swai_edge_scapes_cap, do: "SWAI_EDGE_SCAPES_CAP"

  def get_env_var_as_integer(var_name, default \\ 0) do
    case System.get_env(var_name) do
      nil ->
        default

      value ->
        case Integer.parse(value) do
          :error -> default
          {int_value, _} -> int_value
        end
    end
  end

  def get_env_var_as_float(var_name, default \\ 0.0) do
    case System.get_env(var_name) do
      nil ->
        default

      value ->
        case Float.parse(value) do
          :error -> default
          {float_value, _} -> float_value
        end
    end
  end

  def get_env_var_as_boolean(var_name, default \\ false) do
    case System.get_env(var_name) do
      nil ->
        default

      value ->
        do_to_bool(value, default)
    end
  end

  defp do_to_bool(nil, default), do: default
  defp do_to_bool("1", _), do: true
  defp do_to_bool("0", _), do: false
  defp do_to_bool("true", _), do: true
  defp do_to_bool("false", _), do: false
  defp do_to_bool(1, _), do: true
  defp do_to_bool(0, _), do: false
  defp do_to_bool(_, default), do: default
end
