import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:fluttersimple/view/setting_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

  await location.then((value) {
    lat = value.latitude.toString();
    lon = value.longitude.toString();
  });

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

  return isAccessiblePosition = await Permission.location.status.isGranted;
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

Future<Uint8List> getScreen (GlobalKey key) async {
  try {
    RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    Uint8List uint8list = byteData!.buffer.asUint8List();

    return uint8list;
  } catch (e) {
    return Uint8List(0);
  }
}

void shareInfoImage(Uint8List uint8list) async {
  try {
    final tempDir = await getTemporaryDirectory();
    final file = await File("${tempDir.path}/screenshot.png").create();
    await file.writeAsBytes(uint8list);

    await FlutterShareMe().shareToWhatsApp(
      imagePath: file.path,
    );

  } catch (e) {
    throw Exception(e.toString());
  }
}