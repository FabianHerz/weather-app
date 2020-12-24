import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:my_weather/helpers/size_config_helper.dart';
import 'package:my_weather/widgets/condition_image.dart';
import 'package:my_weather/styles/main_colors.dart' as clr;
import 'package:my_weather/styles/main_colors.dart' as clr;


class DailyItem extends StatelessWidget {
  final DateTime dt;
  final double minTemp;
  final double maxTemp;
  final String mainCondition;
  final double clouds;

  DailyItem({this.dt, this.minTemp, this.maxTemp, this.mainCondition, this.clouds});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: clr.view,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: Offset(0, 3),
              blurRadius: 15,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    _getDate(),
                    Text(
                      mainCondition.toLowerCase(),
                      style: TextStyle(
                        fontFamily: "Segoe",
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                        color: clr.textLight,
                      ),
                    ).tr(),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right:20.0),
                child: Row(
                  children: [
                    ConditionImage(conditionMain: mainCondition,isDayTime: true,height: 50, cloudy: clouds.toDouble(),color: clr.text,),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Text(
                            'temp',
                            style: TextStyle(
                              fontFamily: "Segoe",
                              fontWeight: FontWeight.w100,
                              fontSize: 20,
                              color: clr.text,
                            ),

                          ).tr(args:[maxTemp.toInt().toString()]),
                          Text(
                            'temp',
                            style: TextStyle(
                              fontFamily: "Segoe",
                              fontWeight: FontWeight.w100,
                              fontSize: 20,
                              color: clr.textLight,
                            ),
                          ).tr(args:[minTemp.toInt().toString()]),

                        ],
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _getDate() {

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final aDate = DateTime(dt.year, dt.month, dt.day);
    if (aDate == today) {
      return Text(
        'today',
        style: TextStyle(
          fontFamily: "Segoe",
          fontWeight: FontWeight.w100,
          fontSize: 20,
          color: clr.text,
        ),

      ).tr();
    } else {
      return Text(
        DateFormat('EEEE, d MMM').format(dt),
        style: TextStyle(
          fontFamily: "Segoe",
          fontWeight: FontWeight.w100,
          fontSize: 20,
          color: clr.text,
        ),

      );
    }

  }
}
