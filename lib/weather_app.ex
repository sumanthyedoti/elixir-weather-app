defmodule WeatherApp do
  @moduledoc """
  Documentation for `WeatherApp`.
  """
  def temperatures_of(cities) do
    cooridanator_pid = spawn(WeatherApp.Coordinator, :loop, [[], Enum.count(cities)])

    cities
    |> Enum.each(fn city ->
      worker_pid = spawn(WeatherApp.Worker, :loop, [])
      send(worker_pid, {cooridanator_pid, city})
    end)
  end
end
