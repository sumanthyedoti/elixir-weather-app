defmodule WeatherApp.Worker do
  @apikey "388979e008de4014a88133608221112"

  def loop do
    receive do
      {sender_pid, location} ->
        send(sender_pid, {:ok, temperature_of(location)})

      _ ->
        IO.puts("don't know how to process this message")
    end

    loop()
  end

  def temperature_of(location) do
    result = url_for(location) |> HTTPoison.get() |> parse_response

    case result do
      {:ok, temp} ->
        "#{location}: #{temp}°C"

      :error ->
        "#{location} not found"
    end
  end

  defp url_for(location) do
    location = URI.encode(location)

    "http://api.weatherapi.com/v1/current.json?key=#{@apikey}&q=#{location}&aqi=no"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode!() |> get_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp get_temperature(json) do
    try do
      temp = json["current"]["temp_c"]
      {:ok, temp}
    rescue
      _ -> :error
    end
  end
end
