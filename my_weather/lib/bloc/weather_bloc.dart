import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide BuildContext;
import 'package:my_weather/Data.dart';
import 'package:my_weather/bloc/weather_model.dart';
import 'package:my_weather/bloc/weather_repo.dart';
import 'package:my_weather/helpers/internet.dart';

class WeatherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherEvent {
  final lat;
  final lon;

  FetchWeather(this.lat, this.lon);

  @override
  List<Object> get props => [lat, lon];
}

class FetchLocalWeather extends WeatherEvent {
  final BuildContext context;

  FetchLocalWeather({ this.context});

  @override
  List<Object> get props => [];
}

class WeatherState extends Equatable {
  @override
  List<Object> get props => [];
}

class WeatherIsLoaded extends WeatherState {
  final _weather;

  WeatherIsLoaded(this._weather) {
    Data.weather = _weather;

  }

  WeatherModel get getWeather => _weather;

  @override
  List<Object> get props => [_weather];
}

class WeatherIsNotLoaded extends WeatherState {
  WeatherIsNotLoaded();

  WeatherModel get getWeather => null;
}

class WeatherIsLoading extends WeatherState {
  WeatherIsLoading();
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {

  WeatherRepo weatherRepo;

  WeatherBloc(this.weatherRepo) : super(WeatherIsNotLoaded());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    print(StackTrace.current.toString().split('#1')[0]);

    if (event is FetchWeather) {
      yield WeatherIsLoading();

      try {
        WeatherModel weather = await weatherRepo.getWeather(event.lat, event.lon);
        Data.cityName=await getLocationName(weather.location.split('/')[1]);

        yield WeatherIsLoaded(weather);
      } catch (_) {
        yield WeatherIsNotLoaded();
      }
    } else if (event is FetchLocalWeather) {
      WeatherModel weather = await weatherRepo.getLocalWeather(event.context);
        Data.cityName=await getLocationName(weather.location.split('/')[1]);
      yield WeatherIsLoaded(weather);
    }
  }
}
