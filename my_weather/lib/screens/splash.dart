import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide BuildContext;
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:location/location.dart';
import 'package:my_weather/bloc/weather_bloc.dart';
import 'package:my_weather/helpers/internet.dart';
import 'package:my_weather/helpers/sign_in.dart';
import 'package:my_weather/helpers/size_config_helper.dart';
import 'package:my_weather/screens/home.dart';
import 'package:my_weather/widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:easy_localization/easy_localization.dart';
import 'package:my_weather/styles/main_colors.dart' as clr;
import 'package:my_weather/styles/colors_dark.dart' as dark;

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _MySplashPageState createState() => _MySplashPageState();
}

class _MySplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController _animationLogoController;
  Animation<double> _animationLogo;
  AnimationController _animationContentController;
  Animation<double> _animationContent;
  AnimationController _animationBounceController;
  Animation<double> _animationBounce;
  AnimationController _animationColorController;
  Animation<Color> _animationColor;
  AnimationController _animationColorController1;
  Animation<Color> _animationColor1;
  bool _showHelpersBanner = true;
  bool _showSelectedLocality = false;
  String selectedLocality = '';
  String userName;
  bool checkedValue = false;

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
  void initState() {
    super.initState();
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    (darkModeOn) ? setNight() : null;
    _animationBounceController = AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _animationBounce = Tween<double>(begin: 0, end: 10).chain(new CurveTween(curve: Curves.easeInOut)).animate(_animationBounceController)
      ..addListener(() {
        setState(() {});
      });
    _animationColorController = AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _animationColor = ColorTween(begin: Color(0xffFF0AFF), end: clr.gradientFirst).chain(new CurveTween(curve: Curves.easeInOut)).animate(_animationColorController)
      ..addListener(() {
        setState(() {});
      });
    _animationColorController1 = AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _animationColor1 = ColorTween(begin: Color(0xff75A3FF), end: clr.gradientSecondNight).chain(new CurveTween(curve: Curves.easeInOut)).animate(_animationColorController1)
      ..addListener(() {
        setState(() {});
      });

    _animationContentController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _animationContent = Tween<double>(begin: 100, end: 0).animate(_animationContentController)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _animationBounceController.repeat(reverse: true);
        } else if (state == AnimationStatus.dismissed) {
          print("dismissed");
        }
      })
      ..addListener(() {
        setState(() {});
      });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getData();
      Location location = new Location();
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService().whenComplete(() {
          if (!_serviceEnabled) {
            //return;
          }
        });
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      _locationData = await location.getLocation();
      List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(_locationData.latitude, _locationData.longitude, localeIdentifier: 'ru');
      _animationLogoController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
      final double height = MediaQuery.of(context).size.height;
      print(height);
      _animationLogo = Tween<double>(begin: height / 2 - 88 - MediaQuery.of(context).padding.top, end: 100).animate(_animationLogoController)
        ..addStatusListener((state) {
          if (state == AnimationStatus.completed) {
            _animationContentController.forward();

            print("completed");
          } else if (state == AnimationStatus.dismissed) {
            print("dismissed");
          }
        })
        ..addListener(() {
          setState(() {});
        });
      ;

      _animationLogoController.forward();
      _animationColorController.forward();
      _animationColorController1.forward();
      setState(() {
        print(_animationLogo.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // getData();
    print("*****************" + (MediaQuery.of(context).size.height / 2 - 88).toString());

    SizeConfigHelper.init(context);
    return Scaffold(
      body: BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
        return RefreshIndicator(
          backgroundColor: clr.view,
          onRefresh: () async {
            setState(() {
              _showHelpersBanner = false;
            });
            Location location = new Location();
            bool _serviceEnabled;
            PermissionStatus _permissionGranted;
            LocationData _locationData;
            _serviceEnabled = await location.serviceEnabled();
            if (!_serviceEnabled) {
              _serviceEnabled = await location.requestService();
              if (!_serviceEnabled) {
                print(_serviceEnabled);
                return;
              }
            }
            _permissionGranted = await location.hasPermission();
            if (_permissionGranted == PermissionStatus.denied) {
              _permissionGranted = await location.requestPermission();
              if (_permissionGranted != PermissionStatus.granted) {
                return;
              }
            }
            print(context.locale.languageCode);
            _locationData = await location.getLocation();
            List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(_locationData.latitude, _locationData.longitude, localeIdentifier: 'en');
            final translator = GoogleTranslator();
            String str = '${placemarks.first.locality} , ${placemarks.first.administrativeArea} , ${placemarks.first.country}';
            print(str);
            if (context.locale.languageCode == 'ru')
              str = (await translator.translate('${placemarks.first.locality} , ${placemarks.first.administrativeArea} , ${placemarks.first.country}', from: 'en', to: 'ru')).toString();

            showDialog(
                barrierDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(
                    positiveText: 'yes',
                    negativeText: 'no',
                    title: 'location_found',
                    content: 'location_is',
                    contentParams: [str],
                    positive: () {
                      selectedLocality = str.split(',')[0];
                      _showSelectedLocality = true;
                      Navigator.pop(context);
                    },
                    negative: () {
                      _showSelectedLocality = false;
                      _showHelpersBanner = true;
                      Navigator.pop(context);
                    },
                  );
                });
            print(placemarks.first.locality);
          },
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [_animationColor1.value, _animationColor.value],
                ),
              ),
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10 + _animationBounce.value,
                            child: Opacity(
                              opacity: 1 - _animationContent.value / 100,
                              child: Visibility(
                                visible: _showHelpersBanner,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'pull_down_to_locate',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "Segoe",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
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
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            child: Opacity(
                              opacity: 1 - _animationContent.value / 100,
                              child: Visibility(
                                visible: _showSelectedLocality,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        selectedLocality,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "Segoe",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 26,
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
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: (_animationLogo == null) ? MediaQuery.of(context).size.height / 2 - 88 - MediaQuery.of(context).padding.top : _animationLogo.value,
                            left: MediaQuery.of(context).size.width / 2 - 88,
                            // duration: Duration(milliseconds: 800),
                            child: Image.asset(
                              'assets/images/splash_logo.png',
                              height: 176,
                            ),
                          ),
                          Positioned(
                            top: 328,
                            left: 0,
                            // duration: Duration(milliseconds: 800),
                            child: Opacity(
                              opacity: 1 - _animationContent.value / 100,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'welcome',
                                      style: TextStyle(
                                        fontFamily: "Segoe",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 35,
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
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 180,
                              left: 0,
                              child: Opacity(
                                opacity: 1 - _animationContent.value / 100,
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Bounce(
                                        duration: Duration(milliseconds: 100),
                                        onPressed: () {
                                          signInWithGoogle();
                                        },
                                        child: Container(
                                            height: 60,
                                            width: 250,
                                            decoration: BoxDecoration(
                                              color: clr.view,
                                              borderRadius: BorderRadius.all(Radius.circular(35)),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                    top: 10,
                                                    left: 10,
                                                    child: Image.asset(
                                                      'assets/images/google.png',
                                                      height: 40,
                                                    )),
                                                Center(
                                                  child: (userName != null)
                                                      ? Text(
                                                          (userName == '') ? 'log_in' : userName,
                                                          style: TextStyle(
                                                            fontFamily: "Segoe",
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 18,
                                                            color: clr.textLight,
                                                          ),
                                                        ).tr()
                                                      : CircularProgressIndicator(),
                                                ),
                                              ],
                                            )),
                                      ),
                                    )),
                              )),
                          Positioned(
                              bottom: 100,
                              left: 0,
                              child: Opacity(
                                opacity: 1 - _animationContent.value / 100,
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Bounce(
                                        duration: Duration(milliseconds: 100),
                                        onPressed: () {
                                          //BlocProvider.of<WeatherBloc>(context).add(FetchLocalWeather());
                                          print(StackTrace.current.toString().split('#')[0] + state.toString());
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => MyHomePage()),
                                            // ModalRoute.withName('/home'),
                                          );
                                        },
                                        child: Container(
                                            height: 60,
                                            width: 250,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.all(Radius.circular(35)),
                                              border: Border.all(color: Colors.white, width: 2),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'get_started',
                                                style: TextStyle(
                                                  fontFamily: "Segoe",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 24,
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
                                    )),
                              )),
                          Positioned(
                              bottom: 20,
                              left: 20,
                              child: Opacity(
                                opacity: 1 - _animationContent.value / 100,
                                child: Container(
                                    width: MediaQuery.of(context).size.width - 40,
                                    child: CheckboxListTile(
                                      checkColor: clr.gradientFirst,
                                      activeColor: Colors.white,

                                      title: Text(
                                        "dont_open",
                                        style: TextStyle(
                                          fontFamily: "Segoe",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
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
                                      value: checkedValue,
                                      onChanged: (newValue) async {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setBool('showDialog', !newValue).whenComplete(() {
                                          setState(() {
                                            checkedValue = newValue;
                                          });
                                        });
                                      },
                                      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                                    )),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<String> getLocationName(double lat, double lon) async {
    List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(lat, lon, localeIdentifier: 'en');
    String str = '${placemarks.first.locality} , ${placemarks.first.administrativeArea} , ${placemarks.first.country}';
    print(str);
    if (context.locale.languageCode == 'ru') {
      var translator = GoogleTranslator();

      str = (await translator.translate('${placemarks.first.locality} , ${placemarks.first.administrativeArea} , ${placemarks.first.country}', from: 'en', to: 'ru')).toString();
    }
    return str;
  }

  Future<LocationData> getLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {}
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {}
    }
    return await location.getLocation();

    // print(context.locale.languageCode);
  }

  Future<bool> getData() async {
    //String data = await DefaultAssetBundle.of(context).loadString("assets/data.json");
    print(StackTrace.current.toString().split('#1')[0]);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("CAll");
    if (await check()) {
      print(StackTrace.current.toString().split('#1')[0]);

      userName = await checkSignIn();
      if (userName != null) {
        print(StackTrace.current.toString().split('#1')[0]);

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('users').doc(uid).get().then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            double lat = documentSnapshot.data()['lat'];
            double lon = documentSnapshot.data()['lon'];
            prefs.setDouble('lat', lat);
            prefs.setDouble('lon', lon);
            String location = await getLocationName(lat, lon);
            prefs.setString('location', location);
            selectedLocality = location.split(',')[0];
            _showSelectedLocality = true;
            _showHelpersBanner = false;

            setState(() {});
            BlocProvider.of<WeatherBloc>(context).add(FetchWeather(lat, lon));
          } else {
            LocationData _locationData = await getLocation();
            prefs.setDouble('lat', _locationData.latitude);
            prefs.setDouble('lon', _locationData.longitude);
            String location = await getLocationName(_locationData.latitude, _locationData.longitude);
            prefs.setString('location', location);
            selectedLocality = location.split(',')[0];
            _showSelectedLocality = true;
            _showHelpersBanner = false;
            setState(() {});
            // BlocProvider.of<WeatherBloc>(context).add(FetchWeather(lat, lon));

            print('Document not exists on the database');
            await firestore.collection('users').doc(uid).set({'lat': _locationData.latitude, 'lon': _locationData.longitude});
          }
        });
      } else {
        userName = '';
        LocationData _locationData = await getLocation();
        prefs.setDouble('lat', _locationData.latitude);
        prefs.setDouble('lon', _locationData.longitude);
        String location = await getLocationName(_locationData.latitude, _locationData.longitude);
        prefs.setString('location', location);
        selectedLocality = location.split(',')[0];
        _showSelectedLocality = true;
        _showHelpersBanner = false;
        BlocProvider.of<WeatherBloc>(context).add(FetchWeather(_locationData.latitude, _locationData.longitude));

        setState(() {});
      }
    } else {
      userName = '';
      _showSelectedLocality = true;
      _showHelpersBanner = true;
      BlocProvider.of<WeatherBloc>(context).add(FetchLocalWeather(context: context));
      setState(() {});
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                backgroundColor: clr.view,
                title: new Text(
                  "No internet connection!",
                  style: TextStyle(fontFamily: 'Segoe', color: clr.text, fontSize: 24),
                ),
                content: new Text(
                  "Please check the connection",
                  style: TextStyle(
                    fontFamily: 'Segoe',
                    color: clr.textLight,
                    fontSize: 18,
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
    return true;
  }

  @override
  void dispose() {
    _animationColorController.dispose();
    _animationColorController1.dispose();
    _animationContentController.dispose();
    _animationBounceController.dispose();
    _animationLogoController.dispose();

    super.dispose();
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
