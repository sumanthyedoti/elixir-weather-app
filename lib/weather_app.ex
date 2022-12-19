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
      spawn(fn ->
        city_temperature = WeatherApp.Worker.get_temperature(city)
        send(coordiantor_pid, {:result, city_temperature})
      end)
    end)

    :ok
  end

  def get_stats() do
    WeatherApp.Worker.get_stats()
  end

  def reselt() do
    WeatherApp.Worker.reset_stats()
  end

  def stop() do
    WeatherApp.Worker.stop()
  end
end
