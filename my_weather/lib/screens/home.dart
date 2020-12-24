import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide BuildContext;
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:my_weather/Data.dart';
import 'package:my_weather/bloc/weather_bloc.dart';
import 'package:my_weather/bloc/weather_model.dart';
import 'package:my_weather/helpers/size_config_helper.dart';
import 'package:my_weather/widgets/daily_item.dart';
import 'package:my_weather/widgets/hourly_item.dart';
import 'package:my_weather/widgets/more_details.dart';
import 'package:my_weather/widgets/weather_summary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_weather/styles/main_colors.dart' as clr;
import 'package:my_weather/styles/colors_dark.dart' as dark;
import 'package:easy_localization/easy_localization.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.weather}) : super(key: key);
  final WeatherModel weather;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  var cityController;
  Completer<void> _refreshCompleter;

  setNight() {
    clr.text = dark.text;
    clr.textLight = dark.textLight;
    clr.gradientFirst = dark.gradientFirst;
    clr.gradientSecondDay = dark.gradientSecondDay;
    clr.gradientSecondNight = dark.gradientSecondNight;
    clr.view = dark.view;
    clr.view2 = dark.view2;
  }

  @override
  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    (darkModeOn) ? setNight() : null;

    _animationContentController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animationContent = Tween<double>(begin: 100, end: 0).animate(_animationContentController)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          // print(_animationContent.value);
        } else if (state == AnimationStatus.dismissed) {
          print("dismissed");
        }
      })
      ..addListener(() {
        setState(() {});
      });
    _animationDaysController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animationDaysContent = Tween<double>(begin: 100, end: 0).animate(_animationDaysController)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
        } else if (state == AnimationStatus.dismissed) {
          print("dismissed");
        }
      })
      ..addListener(() {
        setState(() {});
      });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _isCurrentScreen = true;
      _animationContentController.forward().whenComplete(() {
        print(_animationContent.value);
      });
    });
  }

  bool isDayTime = false;
  AnimationController _animationContentController;
  Animation<double> _animationContent;
  AnimationController _animationDaysController;
  Animation<double> _animationDaysContent;
  bool _isCurrentScreen = false;
  bool _isDaysScreen = false;
  String contry = 'Zaporizhzhia';
  String time = 'December 20,1:45 PM';
  DateTime now;

  @override
  Widget build(BuildContext context) {
    SizeConfigHelper.init(context);
    return WillPopScope(
      onWillPop: _onBackPresset,
      child: Scaffold(
        body: Center(
          child: BlocConsumer<WeatherBloc, WeatherState>(listener: (context, state) {
            if (state is WeatherIsLoaded) {
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            }
          }, builder: (context, state) {
             if (state is WeatherIsLoaded|| state is WeatherIsLoading) {
              return RefreshIndicator(
                backgroundColor: clr.view2,
                onRefresh: () async {
                  print(StackTrace.current.toString().split('#1')[0] + 'onRefresh');

                  SharedPreferences prefs = await SharedPreferences.getInstance();

                  double lat = prefs.get('lat');
                  double lon = prefs.get('lon');
                  BlocProvider.of<WeatherBloc>(context).add(FetchWeather(lat, lon));
                  return _refreshCompleter.future;
                },
                child: Center(
                    child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [clr.gradientSecondNight, clr.gradientFirst],
                    ),
                  ),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              Data.cityName,
                              style: TextStyle(
                                fontFamily: "Segoe",
                                fontWeight: FontWeight.w100,
                                fontSize: 30,
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0.0, 1.0),
                                    blurRadius: 6.0,
                                    color: Colors.black.withOpacity(0.34),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Bounce(
                              duration: Duration(milliseconds: 250),
                              onPressed: () {
                                if (_animationContent.value < 100) {
                                  _animationContentController.reverse().whenComplete(() {
                                    setState(() {
                                      _isCurrentScreen = false;
                                      _isDaysScreen = true;
                                      _animationDaysController.forward().whenComplete(() {});
                                    });
                                    print(_animationContent.value);
                                  });
                                } else {
                                  _animationDaysController.reverse().whenComplete(() {
                                    _isDaysScreen = false;
                                    _isCurrentScreen = true;

                                    _animationContentController.forward().whenComplete(() {
                                      print(_animationContent.value);
                                    });
                                  });
                                }
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                              },
                              child: Container(
                                  height: 38,
                                  width: 95,
                                  decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: Colors.white, width: 1)),
                                  child: Center(
                                    child: Text(
                                      (_isCurrentScreen) ? 'by_days' : 'today',
                                      style: TextStyle(
                                        fontFamily: "Segoe",
                                        fontWeight: FontWeight.w400,
                                        height: 0.8,
                                        fontSize: 18,
                                        color: Colors.white,
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(0.0, 1.0),
                                            blurRadius: 6.0,
                                            color: Colors.black.withOpacity(0.34),
                                          ),
                                        ],
                                      ),
                                    ).tr(),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: _isCurrentScreen,
                        child: Column(
                          children: [
                            SizedBox(
                              height: _animationContent.value / 2,
                            ),
                            Opacity(
                              opacity: 1 - _animationContent.value / 100,
                              child: Column(
                                children: [
                                  WeatherSummary(
                                      conditionMain: Data.weather.mainCondition,
                                      dt: Data.weather.dt,
                                      temp: Data.weather.temp,
                                      feelsLike: Data.weather.feelsLike,
                                      isdayTime: Data.weather.isDayTime),
                                  SizedBox(
                                    height: 80,
                                  ),
                                  Container(
                                    height: 100,
                                    child: ListView(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        (Data.weather.horly.length==48)?
                                        Row(
                                            children: List.generate(Data.weather.horly.length~/2, (index) {
                                          return Row(
                                            children: [
                                              HourlyItem(
                                                  conditionMain: Data.weather.horly[index].mainCondition,
                                                  time: Data.weather.horly[index].dt,
                                                  temp: Data.weather.horly[index].temp,
                                                  isDayTime: Data.weather.horly[index].isDayTime,
                                                  cloudy: Data.weather.horly[index].cloudiness),
                                              (index != Data.weather.horly.length~/2-1)
                                                  ? Container(
                                                      height: 200,
                                                      width: 1,
                                                      color: Colors.white,
                                                    )
                                                  : Container(),
                                            ],
                                          );
                                        })):Container,
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  MoreDetailsWidget(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _isDaysScreen,
                        child: Opacity(
                          opacity: 1 - _animationDaysContent.value / 100,
                          child: Column(
                            children: [
                              SizedBox(
                                height: _animationDaysContent.value * 3,
                              ),

                              Column(
                                children: List.generate(Data.weather.daily.length, (index) {
                                  return DailyItem(
                                      dt: Data.weather.daily[index].dt,
                                      minTemp: Data.weather.daily[index].tempMin,
                                      maxTemp: Data.weather.daily[index].tempMax,
                                      mainCondition: Data.weather.daily[index].mainCondition,
                                      clouds: Data.weather.daily[index].cloudiness);
                                }),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )),
              );
            }
             return Center(
               child: CircularProgressIndicator(),
             );
            // else if (state is WeatherIsNotLoaded) {
            //   print(StackTrace.current.toString().split('#1')[0]);
            //
            //   return Container(
            //     color: Colors.green,
            //     child: Center(
            //       child: Text('пизда рулю'),
            //
            //     ),
            //   );
            // }
            // return Container(
            //   color: Colors.greenAccent,
            // );
          }),
        ),
      ),
    );
  }

  Future<bool> _onBackPresset() {
    if (_isDaysScreen) {
      _animationDaysController.reverse().whenComplete(() {
        _isDaysScreen = false;
        _isCurrentScreen = true;

        _animationContentController.forward();
      });
    } else {
      Navigator.of(context).pop(true);
    }
  }
}
