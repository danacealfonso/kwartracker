// Flutter imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/presentation/pages/home/home.dart';
import 'provider/firestore_data.dart';

GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(KwartrackerApp());
}

class KwartrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FirestoreData>(
      create: (_) => FirestoreData(),
      child: GetMaterialApp(
        title: 'Kwartracker App',
        home: HomePage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: ColorConstants.cyan,
          accentColor: const Color(0xFF03BED6),
          primaryTextTheme:
              const TextTheme(headline6: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
