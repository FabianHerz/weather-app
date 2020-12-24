import 'package:flutter/material.dart';
import 'package:my_weather/widgets/condition_image.dart';
import 'package:easy_localization/easy_localization.dart';

class WeatherSummary extends StatelessWidget {
  final String conditionMain;
  final DateTime dt;
  final double temp;
  final double feelsLike;
  final bool isdayTime;

  WeatherSummary({Key key, @required this.conditionMain, @required this.dt, @required this.temp, @required this.feelsLike, @required this.isdayTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(DateFormat('MMMM').format(dt).toLowerCase());
    return  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    DateFormat('d MMMM, h:${(dt.minute<10)?"0":''}m a').format(dt),
                    style: TextStyle(
                      fontFamily: "Segoe",
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
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
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'temp',
                    style: TextStyle(
                      fontFamily: "Segoe",
                      fontWeight: FontWeight.w100,
                      height: 0.7,
                      fontSize: 103,
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
                ),

                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'feels_like',
                    style: TextStyle(
                      fontFamily: "Segoe",
                      fontWeight: FontWeight.w100,
                      height: 0,
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
                  ).tr(args: [feelsLike.toInt().toString()]),

                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ConditionImage(conditionMain: this.conditionMain, isDayTime: this.isdayTime, height: 120,cloudy: 30,),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    conditionMain.toLowerCase(),
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
                  ).tr(),
                ],
              ),
            )
          ],
        );
  }

  String _formatTemperature(double t) {
    var temp = (t == null ? '' : t.round().toString());
    return temp;
  }
}
