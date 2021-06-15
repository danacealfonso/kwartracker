import 'package:flutter/material.dart';
import 'package:kwartracker/views/pages/home/home.dart';
import 'package:flutter/rendering.dart';
import 'package:kwartracker/util/colorConstants.dart';

var homeNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(KwartrackerApp());
}

class KwartrackerApp extends StatelessWidget {
  static final RouteObserver<PageRoute> routeObserver =
  RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kwartracker App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      //TODO: Flutter Themes
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