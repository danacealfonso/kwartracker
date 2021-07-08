import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:kwartracker/infrastructure/auth/firebase_sign_in.dart';
import 'package:kwartracker/util/my_route.dart';
import 'package:kwartracker/views/pages/home/home.dart';

class AuthController extends GetxController{
  final FirebaseSignIn _firebaseSignIn = FirebaseSignIn();

  Future<void> signInWithEmailAndPassword(
    BuildContext context, String email, String password) async{

    try {
      await _firebaseSignIn.signInWithEmailAndPassword(email, password);
      Navigator.pushAndRemoveUntil(
          context,
          MyRoute<dynamic>(
            builder: (BuildContext context) => HomePage(),
            routeSettings: const RouteSettings(name: '/home'),
          ),
              (Route<dynamic> route) => false);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}