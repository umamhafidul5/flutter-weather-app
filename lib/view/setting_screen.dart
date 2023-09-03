import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../util/util.dart' as util;

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting", style: TextStyle(fontSize: 17),),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 51, 51, 51),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  onTap: util.openAppSettings,
                  child: Text("Open App Settings"),
                )
              ];
            },)
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Location is permitted", style: TextStyle(fontSize: 17),),
            const SizedBox(width: 10,),
            Switch(
              value: util.isAccessiblePosition,
              onChanged: (bool value) {  },
            ),
          ],
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    util.checkLocationPermission();
  }
}