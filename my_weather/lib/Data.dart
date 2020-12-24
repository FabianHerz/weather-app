
import 'bloc/weather_model.dart';

class Data{
  static WeatherModel weather=WeatherModel(
    temp: 0,
    pressure: 0,
    humidity: 0,
    tempMax: 0,
    tempMin: 0,
    dt: DateTime(0,0,0),
    isDayTime: true,
    feelsLike: 0,
    cloudiness: 0,
    sunrise: DateTime(0,0,0),
    sunset: DateTime(0,0,0),
    visibility: 0,
    windSpeed: 0,
    uv: 0,
    daily: [],
    horly: []
  );
  static String cityName;

  static String lang;
}