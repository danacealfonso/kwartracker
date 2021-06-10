import 'package:flutter/material.dart';
import 'package:kwartracker/views/pages/home/home.dart';
import 'package:flutter/rendering.dart';
import 'package:kwartracker/util/colorConstants.dart';

var homeNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(KwartrackerApp());
}

class KwartrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kwartracker App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        primaryColor: ColorConstants.cyan,
        accentColor: Color(0xFF03BED6),
        primaryTextTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.white
            )
        ),
      ),
    );
  }
}