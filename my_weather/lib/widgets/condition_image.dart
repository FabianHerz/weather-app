import 'dart:ui';

import 'package:flutter/material.dart';

class ConditionImage extends StatelessWidget {
  final String conditionMain;
  final double cloudy;
  final bool isDayTime;
  final double height;
  final Color color;

  ConditionImage({this.conditionMain, this.isDayTime, this.height,this.cloudy, this.color=Colors.white});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
            child: Image.asset(
              _getImagePathByCondition(),
              color: Colors.black,
              height: height,
            ),
            opacity: 0.3),
        ClipRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Image.asset(
                  _getImagePathByCondition(),
                  color: color,
                  height: height,
                )))
      ],
    );
  }

  String _getImagePathByCondition() {
    String imagePath;
    switch (conditionMain) {
      case 'Thunderstorm':
        imagePath = 'assets/images/thunderstorm.png';
        break;
      case 'Drizzle':
        imagePath = 'assets/images/shower_rain.png';
        break;
      case 'Rain':
        isDayTime ?
        imagePath = 'assets/images/rain_day.png' :
        imagePath = 'assets/images/rain_night.png';

        break;
      case 'Snow':
        imagePath = 'assets/images/snow.png';
        break;
      case 'Mist':
        imagePath = 'assets/images/mist.png';
        break;
      case 'Smoke':
        imagePath = 'assets/images/mist.png';
        break;
      case 'Haze':
        imagePath = 'assets/images/mist.png';
        break;
      case 'Dust':
        imagePath = 'assets/images/mist.png';
        break;
      case 'Fog':
        imagePath = 'assets/images/mist.png';
        break;
      case 'Sand':
        imagePath = 'assets/images/mist.png';
        break;
      case 'Ash':
        imagePath = 'assets/images/mist.png';
        break;
      case 'Squall':
        imagePath = 'assets/images/mist.png';
        break;
      case 'Tornado':
        imagePath = 'assets/images/mist.png';
        break;
      case 'Clear':
        isDayTime ?
        imagePath = 'assets/images/sun.png' :
        imagePath = 'assets/images/night.png';
        break;
      case 'Clouds':
        (11<=cloudy&&cloudy<25)?
        isDayTime ?
        imagePath = 'assets/images/few_clouds_day.png' :
        imagePath = 'assets/images/few_clouds_night.png':
        (25<=cloudy&&cloudy<=50)?
        imagePath = 'assets/images/scattered_clouds.png':
        imagePath = 'assets/images/broken_clouds.png';
        break;
    }

    return imagePath;
  }
}
