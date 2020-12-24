import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide BuildContext;
import 'package:my_weather/Data.dart';
import 'package:my_weather/bloc/weather_bloc.dart';
import 'package:my_weather/widgets/details_Item.dart';
import 'package:my_weather/styles/main_colors.dart' as clr;

class MoreDetailsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
      if (state is WeatherIsLoaded || state is WeatherIsLoading)
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(0, 2),
                    blurRadius: 15,
                  ),
                ],
                color: clr.view),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'more_details',
                    style: TextStyle(
                      fontFamily: "Segoe",
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: clr.text,
                    ),
                  ).tr(),
                ),
                // DetailsItem(itemName:'Восход',itemValue:'5:03AM',iconName:'sunrise.png'),
                Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      DetailsItem(itemName: 'sunrise', itemValue: DateFormat('h:${(Data.weather.sunrise.minute < 10) ? "0" : ''}m a').format(Data.weather.sunrise), iconName: 'sunrise.png'),
                      DetailsItem(itemName: 'sunset', itemValue: DateFormat('h:${(Data.weather.sunset.minute < 10) ? "0" : ''}m a').format(Data.weather.sunset), iconName: 'sunset.png'),
                    ]),
                    SizedBox(
                      height: 15,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      DetailsItem(itemName: 'pressure', itemValue: '${Data.weather.pressure}hPA', iconName: 'pressure.png'),
                      DetailsItem(itemName: 'humidity', itemValue: '${Data.weather.humidity.toInt()}%', iconName: 'humidity.png'),
                    ]),
                    SizedBox(
                      height: 15,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      DetailsItem(itemName: 'visibility', itemValue: '${Data.weather.visibility}m', iconName: 'visibility.png'),
                      DetailsItem(itemName: 'cloudy_t', itemValue: '${Data.weather.cloudiness.toInt()}%', iconName: 'broken_clouds.png'),
                    ]),
                    SizedBox(
                      height: 15,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      DetailsItem(itemName: 'uv', itemValue: '${Data.weather.uv}', iconName: 'uv_${context.locale.languageCode}.png'),
                      DetailsItem(itemName: 'wind_speed', itemValue: '${Data.weather.windSpeed.toInt()} m/s', iconName: 'wind_speed.png'),
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      return Container();
    });
  }
}
