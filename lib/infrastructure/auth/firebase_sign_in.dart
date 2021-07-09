import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseSignIn {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late final GoogleSignIn _googleSignIn;

  Future<void> signOut() => Future.wait(<Future<dynamic>>[
    _googleSignIn.signOut(),
    _firebaseAuth.signOut(),
  ]);

  Future<dynamic> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential signIn = await _firebaseAuth
        .signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return signIn;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }
}