import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttersimple/view/setting_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../model/data.dart';
import '../view/info_screen.dart';
import '../view/main_screen.dart';

Map<String, WidgetBuilder> routes = {
  "/": (context) => const MainScreen(),
  "/info": (context) => const InfoScreen(),
  "/setting": (context) => const SettingScreen(),
};

List<Data> dataList = [];
String searchText = "";
bool isAccessiblePosition = false;
bool isFirst = false;

Future<Data> fetchDataByName(String kota) async {
  var url =
  Uri.https(
      "api.openweathermap.org",
      "/data/2.5/weather",
      {"q": kota,
        "APPID": "233b047387921da67d2ba3f5eff1b512"
      },
  );

  var response = await http.get(url);

  if (response.statusCode == 200) {

    return Data.fromJSON(jsonDecode(response.body));
  } else {

    throw Exception("No Data");
  }
}

Future<Data> fetchDataByPosition(Future<Position> location) async {
  String lat = "";
  String lon = "";

  print("1111");
  print("lat $lat");

  await location.then((value) {
    lat = value.latitude.toString();
    print("2222");
    print("lat $lat");
    lon = value.longitude.toString();
  });

  print("3333");
  print("lat $lat");

  var url =
  Uri.https(
    "api.openweathermap.org",
    "/data/2.5/weather",
    {"lat": lat,
      "lon": lon,
      "APPID": "233b047387921da67d2ba3f5eff1b512"
    },
  );

  var response = await http.get(url);

  if (response.statusCode == 200) {

    return Data.fromJSON(jsonDecode(response.body));
  } else {

    throw Exception("No Data");
  }
}

void openAppSettings() async {
  await GeolocatorPlatform.instance.openAppSettings();
}

Future<bool> checkLocationPermission() async {
  LocationPermission permission = await GeolocatorPlatform.instance.checkPermission();

  return isAccessiblePosition = permission != LocationPermission.denied;
}

Future<Position> getLocation() async {
  isFirst = false;

  return await GeolocatorPlatform.instance.getCurrentPosition();
}

String getIcon(String iconCode) {
  return "https://openweathermap.org/img/wn/$iconCode@2x.png";
}

String getFlag(String countryId) {
  return "https://openweathermap.org/images/flags/${countryId.toLowerCase()}.png";
}