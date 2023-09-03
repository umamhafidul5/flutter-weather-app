import 'dart:io';

import 'package:flutter/material.dart';

import '../model/data.dart';
import '../util/util.dart' as util;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainState();
  }
}

class _MainState extends State<MainScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App", style: TextStyle(fontSize: 17),),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 51, 51, 51),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 17, right: 12, bottom: 7),
            child: SizedBox(
              width: 150,
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: _textEditingController,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(fontSize: 15),
                onSubmitted: (value) {
                  setState(() {
                    util.searchText = value;
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Transform.flip(
                      flipX: true,
                      child: const Icon(Icons.search),
                    ),
                    onPressed: () {
                      setState(() {
                        util.searchText = _textEditingController.text;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          )
        ],
      ),

      body: FutureBuilder<Data>(
        future: util.isFirst
            ? util.fetchDataByPosition(util.getLocation())
            : util.fetchDataByName(util.searchText),
        builder: (BuildContext context, AsyncSnapshot<Data> snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {

            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(milliseconds: 500),
                  backgroundColor: Colors.amber,
                  content: Text('Loading...'),
                ),
              );
            });

          } else {

            if (snapshot.hasData) {
              final Data data = snapshot.data!;
              bool isExist = false;
              for (var element in util.dataList) {
                isExist = element.name == data.name;
                if (isExist) {
                  break;
                }
              }

              if (isExist) {
                Data sameData = util.dataList.firstWhere((element) => element.name == data.name);
                util.dataList.remove(sameData);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Updated: ${data.name} has been updated'),
                    ),
                  );
                });

              }

              util.dataList.add(data);

            } else if (snapshot.hasError) {

              WidgetsBinding.instance.addPostFrameCallback((_) {

                String message = snapshot.error.toString();
                if (snapshot.error is SocketException) {
                  message = "No connection";
                } else if (snapshot.error is Exception) {
                  message = message.replaceAll("Exception: ", "");
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Error: $message'),
                  ),
                );
              });
            }
          }

          return ListView(
            children: util.dataList.reversed.indexed.map((element) {
              print(util.getString().$3);
              return ListTile(
                selected: element.$1 == 0,
                selectedTileColor: Colors.green[100],
                leading: CircleAvatar(
                  child: Image.network(util.getIcon(element.$2.weatherList.first.icon)),
                ),
                title: Text(element.$2.name),
                subtitle: Text("${element.$2.weatherList.first.main} - ${element.$2.weatherList.first.description}"),
                trailing: Text("${(element.$2.main.temp - 273.15).toStringAsFixed(1)}°C"),
                onTap: () {
                  Navigator.pushNamed(context, "/info",
                      arguments: element
                  );
                },
              );
            }).toList(),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          if (index == 1) {
            Navigator.pushNamed(context, "/setting");
          }
        },

        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Setting"
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    util.isFirst = true;
    util.checkLocationPermission();
  }
}