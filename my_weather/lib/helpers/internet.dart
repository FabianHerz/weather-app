import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';
import 'package:my_weather/Data.dart';
import 'package:translator/translator.dart';

Future<bool> check() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}
Future<String> getLocationName(String location) async {
  String str = location;
  if (Data.lang == 'ru') {
    var translator = GoogleTranslator();
    str = (await translator.translate(location, from: 'en', to: 'ru')).toString();
  }
  return str;
}
