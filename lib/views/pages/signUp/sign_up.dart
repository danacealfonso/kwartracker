// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// Project imports:
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/util/globals.dart' as globals;
import 'package:kwartracker/util/my_route.dart';
import 'package:kwartracker/views/pages/home/home.dart';
import 'package:kwartracker/views/pages/signIn/sign_in.dart';
import 'package:kwartracker/views/widgets/custom_body.dart';
import 'package:kwartracker/views/widgets/custom_button.dart';
import 'package:kwartracker/views/widgets/custom_text_field.dart';
import '../../widgets/header_nav.dart';

class SignUpPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUpPage> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  Widget title() {
    return Transform(
        transform: Matrix4.translationValues(-30.0, 0.0, 0.0),
        child: Image.asset('images/Logo.png',
            width: 180, height: 40, fit: BoxFit.fill));
  }

  @override
  Widget build(BuildContext context) {
    Widget? leading() {
      return const Center();
    }

    Widget content() {
      return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 9, 0, 4),
                child: Text(
                  'Create\nAccount',
                  style: TextStyle(
                      color: Color(0xFF414141),
                      fontSize: 42,
                      fontWeight: FontWeight.w500),
                ),
              ),
              CustomTextField(
                hintText: 'Enter email address',
                label: 'Email',
                onChanged: (dynamic value) {
                  email = value;
                },
              ),
              CustomTextField(
                hintText: 'Enter password',
                label: 'Password',
                obscureText: true,
                onChanged: (dynamic value) {
                  password = value;
                },
              ),
              CustomButton(
                  text: 'Sign Up',
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      globals.isLoggedIn = true;
                      Navigator.pushAndRemoveUntil(
                          context,
                          MyRoute<dynamic>(
                            builder: (BuildContext context) => HomePage(),
                            routeSettings: const RouteSettings(name: '/home'),
                          ),
                          (Route<dynamic> route) => false);
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      print(e);
                    }
                  }),
            ]),
      );
    }

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorConstants.cyan,
          appBar: headerNav(
              title: title(),
              leading: leading(),
              titleSpacing: 0.0,
              centerTitle: false),
          body: CustomBody(
              child: Column(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.fromLTRB(30, 30, 20, 30),
                  child: content()),
              const Expanded(
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                      ),
                    )),
              ),
              Expanded(
                  child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: RichText(
                      text: TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                          text: 'Already have an account?',
                          style: TextStyle(
                              color: ColorConstants.black, fontSize: 14)),
                      TextSpan(
                          text: ' Sign In',
                          style: const TextStyle(
                            color: ColorConstants.cyan,
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MyRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        SignInPage(),
                                    routeSettings:
                                        const RouteSettings(name: '/signIn'),
                                  ));
                            }),
                    ],
                  )),
                ),
              )),
            ],
          ))),
    );
  }
}
