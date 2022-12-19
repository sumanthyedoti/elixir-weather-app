# WeatherApp

- fetches temperatures of a list of cities parallelly

### run

- cd into the project directory

```
iex -S mix
```

### API

```
WeatherApp.start
WeatherApp.temperature_of "Singapore"
WeatherApp.temperatures_of ["Bengaluru", "California"]
WeatherApp.temperatures_of WeatherApp.get_cities_list
WeatherApp.get_stats
WeatherApp.reset_stats
WeatherApp.stop
```
