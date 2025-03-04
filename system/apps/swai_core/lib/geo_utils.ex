defmodule Geo do
  @earth_radius 6371.0 # Earth radius in kilometers

  def degrees_to_radians(degrees) do
    degrees * :math.pi / 180.0
  end

  def haversine_distance({lat1, lon1}, {lat2, lon2}) do
    # Convert latitude and longitude from degrees to radians
    lat1 = degrees_to_radians(lat1)
    lon1 = degrees_to_radians(lon1)
    lat2 = degrees_to_radians(lat2)
    lon2 = degrees_to_radians(lon2)

    d_lat = lat2 - lat1
    d_lon = lon2 - lon1

    a = :math.sin(d_lat / 2) * :math.sin(d_lat / 2) +
        :math.cos(lat1) * :math.cos(lat2) *
        :math.sin(d_lon / 2) * :math.sin(d_lon / 2)

    c = 2 * :math.atan2(:math.sqrt(a), :math.sqrt(1 - a))

    @earth_radius * c
  end

  def closest_points(center, points, n) do
    points
    |> Enum.map(fn point -> {point, haversine_distance(center, point)} end)
    |> Enum.sort_by(fn {_point, distance} -> distance end)
    |> Enum.take(n)
    |> Enum.map(fn {point, _distance} -> point end)
  end

  

end

# Example usage:
# Point format: {latitude_in_degrees, longitude_in_degrees}
# center_point = {40.7128, -74.0060} # New York City (latitude, longitude in degrees)
# points = [
#   {34.0522, -118.2437}, # Los Angeles
#   {41.8781, -87.6298},  # Chicago
#   {51.5074, -0.1278},   # London
#   {35.6895, 139.6917},  # Tokyo
#   {48.8566, 2.3522},    # Paris
#   {55.7558, 37.6176}    # Moscow
# ]

# n = 3
# closest_n_points = Geo.closest_points(center_point, points, n)
# IO.puts("The #{n} closest points to the center: #{inspect(closest_n_points)}")
