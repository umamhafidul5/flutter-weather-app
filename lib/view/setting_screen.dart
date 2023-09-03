import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

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
                PopupMenuItem(
                  onTap: () async {
                    util.isAccessiblePosition
                        ? await ph.openAppSettings()
                        : await ph.Permission.location.request();

                    setState(() {
                      util.checkLocationPermission();
                    });
                  },
                  child: const Text("Open App Settings"),
                )
              ];
            },
          ),
        ],
      ),

      body: FutureBuilder<bool>(
        future: util.checkLocationPermission(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Location is permitted", style: TextStyle(fontSize: 17),),
                const SizedBox(width: 10,),
                Switch(
                  value: util.isAccessiblePosition,
                  onChanged: (bool value) async {
                    await ph.Permission.location.request();

                    setState(() {
                      util.checkLocationPermission();
                    });

                    if (!value) {
                      if (!context.mounted) return;
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Location is "
                                "${util.isAccessiblePosition ? "Permitted" : "Prohibited"}"
                            ),
                          )
                      );
                    }
                  },
                ),
              ],
            ),
          );
        }
      )
    );
  }

  @override
  void initState() {
    super.initState();
    util.checkLocationPermission();
  }
}