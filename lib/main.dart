import 'package:flutter/material.dart';
import 'package:kwartracker/pages/home/home.dart';
import 'package:flutter/rendering.dart';

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
      theme:  ThemeData(
        primaryColor: Color(0xFF03BED6),
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