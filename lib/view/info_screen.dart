import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/data.dart';
import '../util/util.dart' as util;

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final Data data = ModalRoute.of(context)?.settings.arguments as Data;
    final DateTime dt = DateTime.fromMillisecondsSinceEpoch((data.dt*1000).toInt());

    GlobalKey key = GlobalKey();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xDD5B46AF),
        onPressed: () {
          util.getScreen(key).then((value) {
            util.shareInfoImage(value);
          });
        },
        child: const Icon(Icons.share),
      ),
      body: Stack(
        children: [
          RepaintBoundary(
            key: key,
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xDD5B46AF),
                      Color(0xBB6D54D1),
                      Color(0x997A5EEB),
                      Color(0x778566FF),
                    ],
                  )
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 25),
                    child: Column(
                      children: [
                        Text(data.name, style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,),),

                        const SizedBox(height: 25,),

                        Text(DateFormat("HH:mm").format(dt),
                            style: const TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,)
                        ),

                        Text(DateFormat("EEE, MMM d").format(dt),
                            style: const TextStyle(fontSize: 15, color: Colors.white)
                        ),

                        const SizedBox(height: 30,),

                        Text("${(data.main.temp - 273.15).toStringAsFixed(1)}°C",
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,)
                        ),

                        Text("Feels like ${(data.main.feelsLike - 273.15).toStringAsFixed(1)}°C",
                            style: const TextStyle(fontSize: 15, color: Colors.white)
                        ),

                        const SizedBox(height: 40,),

                        Text("${(data.main.tempMax - 273.15).toStringAsFixed(1)}°C",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,)
                        ),

                        Divider(
                          thickness: 5,
                          color: Colors.white,
                          indent: MediaQuery.of(context).size.width*0.4,
                          endIndent: MediaQuery.of(context).size.width*0.4,
                        ),

                        Text("${(data.main.tempMin - 273.15).toStringAsFixed(1)}°C",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,)
                        ),

                        const SizedBox(height:75,),

                        Container(
                            padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 30),
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xAAFFFFFF),
                                    Color(0xFFFFFFFF)
                                  ],
                                ),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))

                            ),

                            child: Column(
                              children: [
                                RowDataView(
                                  label1: "SUNRISE",
                                  data1: DateFormat("HH:mm").format(DateTime.fromMillisecondsSinceEpoch(((data.sys.sunrise)*1000).toInt())),
                                  label2: "SUNSET",
                                  data2: DateFormat("HH:mm").format(DateTime.fromMillisecondsSinceEpoch(((data.sys.sunset)*1000).toInt())),
                                ),

                                const Divider(height: 35, thickness: 2.5,),

                                RowDataView(
                                  label1: "PRESSURE",
                                  data1: "${data.main.pressure} hPa",
                                  label2: "HUMIDITY",
                                  data2: "${data.main.humidity}%",
                                ),

                                const Divider(height: 35, thickness: 2.5,),

                                RowDataView(
                                  label1: "SPEED",
                                  data1: "${data.wind.speed} m/s",
                                  label2: "DEGREES",
                                  data2: "${data.wind.deg}°",
                                ),
                              ],
                            )
                        ),
                      ],
                    )
                ),
              ),
            ),
          ),

          Positioned(
            top: 45,
            left: 17,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RowDataView extends StatelessWidget {
  final String label1;
  final String data1;
  final String label2;
  final String data2;

  const RowDataView({super.key, required this.label1, required this.data1, required this.label2, required this.data2});

  const RowDataView.name(this.label1, this.data1, this.label2, this.data2, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 13,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label1,
                  style: const TextStyle(fontSize: 12, color: Colors.black)
              ),

              const SizedBox(height: 12,),

              Text(data1,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,)
              ),
            ],
          ),
        ),

        Flexible(
          flex: 10,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label2,
                  style: const TextStyle(fontSize: 12, color: Colors.black)
              ),

              const SizedBox(height: 12,),

              Text(data2,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,)
              ),
            ],
          )
        )
      ],
    );
  }
}

