defmodule WeatherApp.Worker do
  use GenServer

  @name __MODULE__
  ## API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  def get_temperature(location) do
    Process.sleep(1000)
    GenServer.call(@name, {:location, location})
  end

  def get_stats() do
    GenServer.call(@name, :get_stats)
  end

  def reset_stats() do
    GenServer.cast(@name, :reset_stats)
  end

  def stop() do
    GenServer.cast(@name, :stop)
  end

  ## Server
  @apikey "388979e008de4014a88133608221112"

  @impl GenServer
  def init(:ok) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:location, location}, _from, stats) do
    new_stats = update_states(stats, location)

    case temperature_of(location) do
      {:ok, temp} ->
        {:reply, {"#{location}", "#{temp}°C"}, new_stats}

      _ ->
        {:reply, :error, stats}
    end
  end

  @impl GenServer
  def handle_call(:get_stats, _from, stats) do
    {:reply, stats, stats}
  end

  @impl GenServer
  def handle_cast(:reset_stats, _stats) do
    {:noreply, %{}}
  end

  @impl GenServer
  def handle_cast(:stop, stats) do
    {:stop, :normal, stats}
  end

  @impl GenServer
  def handle_info(msg, stats) do
    IO.puts("Recieved #{inspect(msg)}")
    {:noreply, stats}
  end

  @impl GenServer
  def terminate(reason, _stats) do
    # can write to file or DB here, for example
    IO.puts("Server terminated because of #{inspect(reason)}")
    :ok
  end

  ## Helper funcitons

  defp temperature_of(location) do
    url_for(location) |> HTTPoison.get() |> parse_response
  end

  defp url_for(location) do
    location = URI.encode(location)

    "http://api.weatherapi.com/v1/current.json?key=#{@apikey}&q=#{location}&aqi=no"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode!() |> retrieve_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp retrieve_temperature(json) do
    try do
      temp = json["current"]["temp_c"]
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp update_states(old_stats, location) do
    case Map.has_key?(old_stats, location) do
      true -> Map.update!(old_stats, location, &(&1 + 1))
      false -> Map.put_new(old_stats, location, 1)
    end
  end
end
