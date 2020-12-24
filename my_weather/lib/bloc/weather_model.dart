class WeatherModel {
  double temp;
  double pressure;
  double humidity;
  double tempMax;
  double tempMin;
  DateTime dt;
  String mainCondition;
  double feelsLike;
  double cloudiness;
  DateTime sunrise;
  DateTime sunset;
  double visibility;
  List<WeatherModel> horly;
  List<WeatherModel> daily;
  bool isDayTime;
  String location;
  double windSpeed;
  double uv;


  WeatherModel({
    this.temp,
    this.pressure,
    this.humidity,
    this.tempMax,
    this.tempMin,
    this.dt,
    this.mainCondition,
    this.feelsLike,
    this.cloudiness,
    this.sunrise,
    this.sunset,
    this.visibility,
    this.windSpeed,
    this.uv,
    this.isDayTime,
    this.daily,
    this.horly,
    this.location
  }
  );
  factory WeatherModel.fromDailyJson(Map<String, dynamic> daily,int tzOffset){

    int cloudiness = daily['clouds'];

      return WeatherModel(
          cloudiness: cloudiness.toDouble(),
          tempMax: daily['temp']['max'].toDouble(),
          tempMin: daily['temp']['min'].toDouble(),
          mainCondition: daily['weather'][0]['main'],
          dt: DateTime.fromMillisecondsSinceEpoch((daily['dt']+tzOffset) * 1000,
              isUtc: true),
          );

  }
  factory WeatherModel.fromHourlyJson(Map<String, dynamic> daily,DateTime sunrise,DateTime sunset,int tzOffset){
    var date=DateTime.fromMillisecondsSinceEpoch((daily['dt']+tzOffset) * 1000,
        isUtc: true);
        bool isDayTime = date.isAfter(sunrise) && date.isBefore(sunset);
   int cloudiness = daily['clouds'];
    return WeatherModel(
      cloudiness: cloudiness.toDouble(),
      temp: daily['temp'].toDouble(),
      mainCondition: daily['weather'][0]['main'],
      dt:date,
      isDayTime: isDayTime
    );

  }

  factory WeatherModel.fromJson(Map<String, dynamic> json){

    var date = DateTime.fromMillisecondsSinceEpoch((json['current']['dt']+json['timezone_offset']) * 1000,
        isUtc: true);
    var sunrise = DateTime.fromMillisecondsSinceEpoch(
        (json['current']['sunrise']+json['timezone_offset']) * 1000,
        isUtc: true);
    var sunset = DateTime.fromMillisecondsSinceEpoch(
        (json['current']['sunset']+json['timezone_offset']) * 1000,
        isUtc: true);

    bool isDayTime = date.isAfter(sunrise) && date.isBefore(sunset);

    bool hasDaily = json['daily'] != null;
    List<WeatherModel>tempDaily = [];
    if (hasDaily) {
      print(StackTrace.current.toString().split('#1')[0]);

      List items = json['daily'];

      tempDaily = items
          .map((item) {
            print(item.runtimeType);
           return  WeatherModel.fromDailyJson(item,json['timezone_offset']);
          })
          .toList();


    }
    // print(tempDaily);
    bool hasHourly = json['hourly'] != null;
    List<WeatherModel>tempHourly = [];
    if (hasHourly) {

      List items = json['hourly'];
      tempHourly = items
          .map((item) => WeatherModel.fromHourlyJson(item,sunrise,sunset,json['timezone_offset']))
          .toList();


    }
    print('7');

    var weather=WeatherModel(
          temp: json['current']['temp'].toDouble(),
          pressure: json['current']['pressure'].toDouble(),
          humidity: json['current']['humidity'].toDouble(),
          dt: date,
          mainCondition: json['current']['weather'][0]['main'],
          feelsLike: json['current']['feels_like'].toDouble(),
          cloudiness: json['current']['clouds'].toDouble(),
          sunrise: sunrise,
          sunset: sunset,
          visibility: json['current']['visibility'].toDouble(),
          windSpeed: json['current']['wind_speed'].toDouble(),
          uv: json['current']['uvi'].toDouble(),
          isDayTime: isDayTime,
          daily: tempDaily,
          horly: tempHourly,
          location: json['timezone']
      );
    print(StackTrace.current.toString().split('#1')[0]);

    return weather;
    // ignore: missing_return
  }
}
