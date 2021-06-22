import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/views/pages/home/home.dart';
import 'package:kwartracker/views/pages/signUp/signUp.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/globals.dart' as globals;
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cButton.dart';
import 'package:kwartracker/views/widgets/cTextField.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../widgets/headerNav.dart';

class SignInPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

//TODO: Authenticating Users with FirebaseAuth
class _LoginPageState extends State<SignInPage> with TickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;

  Widget title() {
    return Transform(
      transform:  Matrix4.translationValues(-30.0, 0.0, 0.0),
      child: Image.asset(
        'images/Logo.png',
        width: 180,
        height: 40,
        fit:BoxFit.fill
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? leading() {
      return Center();
    }

    Widget content() {
      var controller = TextEditingController();
      controller.text = "test1234@gmail.com";
      email = "test1234@gmail.com";

      var controllerPass = TextEditingController();
      controllerPass.text = "test123";
      password = "test123";
      
      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 9, 0, 4),
              child: Text("Welcome\nBack",
                style: TextStyle(
                    color: Color(0xFF414141),
                    fontSize: 42,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
            CTextField(hintText: "Enter email address", label: "Email",
              controller: controller,
              onChanged: (value) {
                email = value;
              },
            ),
            CTextField(hintText: "Enter password", label: "Password",
              initialValue: "test123",
              controller: controllerPass,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
            ),
            CButton(
              text: "Sign In",
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });
                try {
                  await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password
                  );
                  globals.isLoggedIn = true;
                  Navigator.pushAndRemoveUntil(context, MyRoute(
                      builder: (context) => HomePage(), routeSettings:
                  RouteSettings(name: "/home"),
                  ), (route) => false);
                  setState(() {
                    showSpinner = false;
                  });
                } catch (e) {
                  setState(() {
                    showSpinner = false;
                  });
                  Fluttertoast.showToast(
                      msg: e.toString(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
              }
            ),
            Align(
              alignment: Alignment.center,
              child:Text("or",
                style: TextStyle(
                    color: Color(0xFF414141),
                    fontSize: 14
                ),
              ),
            ),
            CButton(text:
              "Sign in with Google",
              onPressed: (){},
              backgroundColor: ColorConstants.blue
            ),
            CButton(text:
              "Sign in with Apple",
              onPressed: (){},
              backgroundColor: Colors.black
            ),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () { },
                      child: Text(
                        "Recover Password",
                        style: TextStyle(
                          color: ColorConstants.grey6,
                          decoration: TextDecoration.underline,
                          fontSize: 14
                        )
                      ),
                    )
                  )
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () { },
                      child: Text(
                        "Sign in as guest",
                        style: TextStyle(
                          color: ColorConstants.grey6,
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
      );
    }

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: ColorConstants.cyan,
        appBar: headerNav(
          title: title(),
          leading: leading(),
          titleSpacing: 0.0,
          centerTitle: false
        ),
        body: CBody(
          child: Column(
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
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'No account yet?',
                            style: TextStyle(
                                color: ColorConstants.black,
                                fontSize: 14
                            )
                          ),
                          TextSpan(
                            text: ' Sign Up',
                            style: TextStyle(
                              color: ColorConstants.cyan,
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context,
                                  MyRoute(
                                    builder: (context) => SignUpPage(), routeSettings:
                                  RouteSettings(name: "/signUp"),
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
          )
        )
      ),
    );
  }
}