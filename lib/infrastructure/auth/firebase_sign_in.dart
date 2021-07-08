import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kwartracker/util/my_route.dart';
import 'package:kwartracker/views/pages/home/home.dart';

class FirebaseSignIn {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late final GoogleSignIn _googleSignIn;

  Future<void> signOut() => Future.wait(<Future<dynamic>>[
    _googleSignIn.signOut(),
    _firebaseAuth.signOut(),
  ]);

  Future<void> signInWithEmailAndPassword(String email, String password) async{
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }
}