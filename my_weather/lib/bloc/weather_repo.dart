import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_weather/bloc/weather_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherRepo {
  Future<WeatherModel> getWeather(double lat, double lon) async {
    final result = await http.Client().get("https://api.openweathermap.org/data/2.5/onecall?lat=${lat}&lon=${lon}&units=metric&exclude=minutely&appid=d75cc92fcfc211718b6d4cd0721d3062");
    if (result.statusCode != 200) throw Exception();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('weather', result.body);
    return WeatherModel.fromJson(json.decode(result.body));
  }

  Future<WeatherModel> getLocalWeather(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('weather') != null)
      return WeatherModel.fromJson(json.decode(prefs.getString('weather')));
    else {
      String data = await DefaultAssetBundle.of(context).loadString("assets/data.json");
      return WeatherModel.fromJson(json.decode(data));
    }
  }
}
