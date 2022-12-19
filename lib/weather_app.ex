defmodule WeatherApp do
  @moduledoc """
  Documentation for `WeatherApp`.
  """

  def start() do
    WeatherApp.Worker.start_link()
  end

  def temperature_of(city) do
    WeatherApp.Worker.get_temperature(city)
  end

  def temperatures_of(cities) do
    coordiantor_pid = spawn(WeatherApp.Coordinator, :loop, [Enum.count(cities)])

    cities
    |> Enum.map(fn city ->
      # spawn, not to block
      spawn(fn ->
        city_temperature = WeatherApp.Worker.get_temperature(city)
        send(coordiantor_pid, {:result, city_temperature})
      end)
    end)

    :ok
  end

  @large_list_cities [
    "London",
    "New York",
    "Bengaluru",
    "Singapore",
    "Hyderabad",
    "Tirupati",
    "California",
    "Mumbai",
    "Pune",
    "Chennai",
    "Delhi",
    "Sydney",
    "Melborne",
    "Tokyo",
    "Mexico City",
    "Cairo",
    "Lisbon",
    "Romes",
    "Jakarta",
    "Budapest",
    "Paris",
    "Beijing",
    "Brasilia",
    "Dhaka",
    "Kabul",
    "Kolkata",
    "Jaipur",
    "Srinagar",
    "Puri"
  ]

  def get_cities_list(), do: @large_list_cities

  def get_stats() do
    WeatherApp.Worker.get_stats()
  end

  def reset_stats() do
    WeatherApp.Worker.reset_stats()
  end

  def stop() do
    WeatherApp.Worker.stop()
  end
end
