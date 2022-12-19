# WeatherApp

- Fetches temperatures of a list of cities parallelly

### run

- `cd` into the project directory

```
iex -S mix
```

### API

- Start the server

```
WeatherApp.start
```

- Temperature of a city

```
WeatherApp.temperature_of "Singapore"
```

- Temperature of a list of cities

```
WeatherApp.temperatures_of ["Bengaluru", "California"]
```

- Temperature of predefined cities

```
WeatherApp.temperatures_of WeatherApp.get_cities_list
```

- Get statistics, number of hits for a place

```
WeatherApp.get_stats
```

- Reset stats

```
WeatherApp.reset_stats
```

- Stop the server

```
WeatherApp.stop
```
