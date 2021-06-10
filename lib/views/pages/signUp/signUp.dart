import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/pages/signIn/signIn.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cButton.dart';
import 'package:kwartracker/views/widgets/cTextField.dart';

import '../../widgets/headerNav.dart';

class SignUpPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUpPage>  with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  Widget title() {
    return Transform(
        transform: Matrix4.translationValues(-30.0, 0.0, 0.0),
        child: Image.asset(
            'images/Logo.png',
            width: 180,
            height: 40,
            fit: BoxFit.fill
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? leading() {
      return Center();
    }

    Widget content() {
      return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 9, 0, 4),
                child: Text("Create\nAccount",
                  style: TextStyle(
                      color: Color(0xFF414141),
                      fontSize: 42,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              CTextField(hintText: "Enter email address", label: "Email"),
              CTextField(hintText: "Enter password", label: "Password"),
              CButton(
                  text: "Sign Up",
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MyRoute(
                        builder: (context) => SignInPage()
                    ), (route) => false);
                  }
              ),
              Align(
                alignment: Alignment.center,
                child: Text("or",
                  style: TextStyle(
                      color: Color(0xFF414141),
                      fontSize: 14
                  ),
                ),
              ),
              CButton(text:
              "Sign up with Google",
                  onPressed: () {},
                  backgroundColor: ColorConstants.blue
              ),
              CButton(text:
              "Sign up with Apple",
                  onPressed: () {},
                  backgroundColor: Colors.black
              ),
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Sign in as guest",
                          style: TextStyle(
                            color: ColorConstants.gray6,
                            decoration: TextDecoration.underline,
                            fontSize: 14
                          )
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ]
        ),
      );
    }

    return Scaffold(
      backgroundColor: ColorConstants.cyan,
      appBar: headerNav(
        title: title(),
        leading: leading(),
        titleSpacing: 0.0,
        centerTitle: false
      ),
      body: CBody(child: Column(
        children: [
          Container(
              padding: EdgeInsets.fromLTRB(30, 30, 20, 30),
              child: content()
          ),
          Expanded(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                  ),
                )
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Already have an account?',
                        style: TextStyle(
                            color: ColorConstants.black,
                            fontSize: 14
                        )
                      ),
                      TextSpan(
                        text: ' Sign In',
                        style: TextStyle(
                          color: ColorConstants.cyan,
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(context,
                                MyRoute(
                                    builder: (context) => SignInPage()
                                )
                            );
                          }
                      ),
                    ],
                  )
                ),
              ),
            )
          ),
        ],
      ))
    );
  }
}