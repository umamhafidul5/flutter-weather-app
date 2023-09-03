import 'package:flutter/material.dart';
import 'package:fluttersimple/util/util.dart' as util;

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(fontSize: 17),
        )
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: util.routes,
    );
  }
}