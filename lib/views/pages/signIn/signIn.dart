import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/views/pages/home/home.dart';
import 'package:kwartracker/views/pages/signUp/signUp.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/widgets/cButton.dart';
import 'package:kwartracker/views/widgets/cTextField.dart';
import 'package:kwartracker/util/myRoute.dart';
import '../../widgets/appBar.dart';

class SignInPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignInPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<Offset> _animation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));
  }

  var actionButtons = [
    TextButton(
        onPressed: null,
        child: Image.asset(
            'images/users/profile_pic.png',
            width: 70,
            height: 85,
            fit:BoxFit.fill
        )
    )
  ];

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
      return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 29, 0, 4),
                child: Text("Welcome\nBack",
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
                text: "Sign In",
                onPressed: (){
                  Navigator.pushAndRemoveUntil(context, MyRoute(
                      builder: (context) => HomePage()
                  ), (route) => false);
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
                            color: ColorConstants.gray6,
                            decoration: TextDecoration.underline,
                            fontSize: 12
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
                            color: ColorConstants.gray6,
                            decoration: TextDecoration.underline,
                            fontSize: 12
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
      body: SlideTransition(
        position: _animation,
        child: Container(

          decoration: BoxDecoration(
            color: ColorConstants.gray,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              topLeft: Radius.circular(50),
            ),
          ),
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
                    padding: const EdgeInsets.fromLTRB(0,0,0,20),
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
                    padding: const EdgeInsets.fromLTRB(0,0,0,40),
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
                          TextSpan(text: ' Sign Up',
                              style: TextStyle(
                                color: ColorConstants.cyan,
                                decoration: TextDecoration.underline,
                                fontSize: 14,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                Navigator.push(context,
                                    MyRoute(
                                        builder: (context) => SignUpPage()
                                    )
                                );
                              }
                          ),
                        ],
                      ),
                    ),
                  )
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}