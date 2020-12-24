import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:my_weather/widgets/condition_image.dart';

class HourlyItem extends StatelessWidget {


  final DateTime time;
  final String conditionMain;
  final double temp;
  final double cloudy;
  final bool isDayTime;

  HourlyItem({this.conditionMain,this.time,this.temp,this.isDayTime,this.cloudy});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'temp',
            style: TextStyle(
              fontFamily: "Segoe",
              fontWeight: FontWeight.w100,
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
          ).tr(args: [temp.toInt().toString()]),
          ConditionImage(conditionMain: conditionMain,isDayTime: isDayTime,height: 40, cloudy: cloudy.toDouble()),
          SizedBox(
            height: 5,
          ),
          Text(
            time.hour.toString()+':00',
            style: TextStyle(
              fontFamily: "Segoe",
              fontWeight: FontWeight.w400,
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
          ),
        ],
      ),
    );
  }
}
