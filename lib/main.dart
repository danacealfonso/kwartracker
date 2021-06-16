import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/views/pages/home/home.dart';
import 'package:flutter/rendering.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/globals.dart' as globals;
import 'package:kwartracker/views/pages/signIn/signIn.dart';

var homeNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: (globals.isLoggedIn) ? HomePage(): SignInPage(),
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