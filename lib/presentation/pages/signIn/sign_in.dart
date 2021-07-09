// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:kwartracker/application/auth/auth_controller.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// Project imports:
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/util/globals.dart' as globals;
import 'package:kwartracker/util/my_route.dart';
import 'package:kwartracker/presentation/pages/home/home.dart';
import 'package:kwartracker/presentation/pages/signUp/sign_up.dart';
import 'package:kwartracker/presentation/widgets/custom_body.dart';
import 'package:kwartracker/presentation/widgets/custom_button.dart';
import 'package:kwartracker/presentation/widgets/custom_text_field.dart';
import '../../widgets/header_nav.dart';

class SignInPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignInPage> with TickerProviderStateMixin {
  bool showSpinner = false;
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
    final AuthController authC = Get.put(AuthController());

    Widget? leading() {
      return const Center();
    }

    Widget content() {
      final TextEditingController controller = TextEditingController();
      controller.text = 'test1234@gmail.com';
      email = 'test1234@gmail.com';

      final TextEditingController controllerPass = TextEditingController();
      controllerPass.text = 'test123';
      password = 'test123';

      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 9, 0, 4),
              child: Text(
                'Welcome\nBack',
                style: TextStyle(
                    color: Color(0xFF414141),
                    fontSize: 42,
                    fontWeight: FontWeight.w500),
              ),
            ),
            CustomTextField(
              hintText: 'Enter email address',
              label: 'Email',
              controller: controller,
              onChanged: (dynamic value) {
                email = value;
              },
            ),
            CustomTextField(
              hintText: 'Enter password',
              label: 'Password',
              initialValue: 'test123',
              controller: controllerPass,
              obscureText: true,
              onChanged: (dynamic value) {
                password = value;
              },
            ),
            CustomButton(
                text: 'Sign In',
                onPressed: () {
                  authC.signInWithEmailAndPassword(context, email, password);
                }),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'or',
                style: TextStyle(color: Color(0xFF414141), fontSize: 14),
              ),
            ),
            CustomButton(
              text: 'Sign in with Google',
              onPressed: () {},
              backgroundColor: ColorConstants.blue,
              leadingIconPath: 'images/icons/ic_google.png',
            ),
            CustomButton(
              text: 'Sign in with Apple',
              onPressed: () {},
              backgroundColor: Colors.black,
              leadingIconPath: 'images/icons/ic_apple.png',
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Recover Password',
                              style: TextStyle(
                                  color: ColorConstants.grey6,
                                  decoration: TextDecoration.underline,
                                  fontSize: 14)),
                        ))),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Sign in as guest',
                          style: TextStyle(
                              color: ColorConstants.grey6,
                              decoration: TextDecoration.underline,
                              fontSize: 14)),
                    ),
                  ),
                )
              ],
            ),
          ]);
    }

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
          backgroundColor: ColorConstants.cyan,
          appBar: headerNav(
              title: title(),
              leading: leading(),
              titleSpacing: 0.0,
              centerTitle: false),
          body: CustomBody(
              hasScrollBody: false,
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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: RichText(
                          text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'No account yet?',
                              style: TextStyle(
                                  color: ColorConstants.black, fontSize: 14)),
                          TextSpan(
                              text: ' Sign Up',
                              style: const TextStyle(
                                color: ColorConstants.cyan,
                                decoration: TextDecoration.underline,
                                fontSize: 14,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(SignUpPage());
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
