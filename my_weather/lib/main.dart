import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide BuildContext;
import 'package:my_weather/Data.dart';
import 'package:my_weather/bloc/weather_bloc.dart';
import 'package:my_weather/screens/home.dart';
import 'package:my_weather/screens/splash.dart';
import 'bloc/weather_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_weather/styles/main_colors.dart' as clr;

void main() {
  runApp(
    BlocProvider<WeatherBloc>(
      create: (context) => WeatherBloc(WeatherRepo()),
      child: EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('ru', 'RU')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  Future<bool> showSplash() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = await Future.delayed(const Duration(seconds: 5));
    return prefs.getBool('showDialog') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Flutter Demo',
      theme: ThemeData(
        unselectedWidgetColor: Colors.white,
        primaryColor: Colors.deepPurple,
        primarySwatch: Colors.lightBlue,
      ),
      home: FutureBuilder<bool>(
          future: showSplash(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            Data.lang=context.locale.languageCode;
            if (snapshot.hasData)
              return _buildApp(snapshot.data, context);
            else
              {
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [clr.gradientSecondDay,clr.gradientFirst ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: MediaQuery.of(context).size.width/2-88,
                          top:MediaQuery.of(context).size.height/2-88,
                          child: Image.asset(
                            'assets/images/splash_logo.png',
                            height: 176,
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width/2-20,
                          top:MediaQuery.of(context).size.height/2+108,
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(),
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              }
          }),
    );
  }

  Widget _buildApp(bool showSplash, BuildContext context) {
    if (showSplash)
      return SplashPage();
    else
      return MyHomePage();
  }
}
