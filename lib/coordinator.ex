defmodule WeatherApp.Coordinator do
  @moduledoc """
    WeatherApp.Coordinator
  """

  @def """
    waits for 'results_expected' number of resoponses before exiting
  """
  def loop(results \\ [], results_expected) do
    receive do
      {:ok, result} ->
        new_results = [result | results]

        if results_expected == Enum.count(new_results) do
          send(self(), :exit)
        end

        loop(new_results, results_expected)

      :exit ->
        IO.puts(results |> Enum.sort() |> Enum.join(",\n"))

      _ ->
        loop(results, results_expected)
    end
  end
end
