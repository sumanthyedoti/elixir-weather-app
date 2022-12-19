defmodule WeatherApp.Coordinator do
  @moduledoc """
    WeatherApp.Coordinator
  """

  @def """
    waits for 'results_expected' number of resoponses before exiting
  """
  def loop(num_of_results, results \\ []) do
    receive do
      {:result, city_temperature} ->
        new_results = [city_temperature | results]

        if num_of_results == Enum.count(new_results) do
          send(self(), :exit)
        end

        loop(num_of_results, new_results)

      :exit ->
        results
        |> Enum.sort(fn city1, city2 -> elem(city1, 0) < elem(city2, 0) end)
        |> Enum.each(fn city -> IO.puts("#{elem(city, 0)} -- #{elem(city, 1)}") end)

      _ ->
        loop(num_of_results, results)
    end
  end
end
