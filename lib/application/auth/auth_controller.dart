import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwartracker/infrastructure/auth/firebase_sign_in.dart';

class AuthController extends GetxController{
  final FirebaseSignIn _firebaseSignIn = FirebaseSignIn();

  Future<void> signInWithEmailAndPassword(
    BuildContext context, String email, String password) async{

    try {
      var user = await _firebaseSignIn.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      print(user);
    } catch (e) {
      print(e);
    }
  }
}