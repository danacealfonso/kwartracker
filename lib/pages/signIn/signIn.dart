import 'package:flutter/material.dart';
import 'package:kwartracker/util/components.dart';
import 'package:kwartracker/util/myRoute.dart';
import '../../appBar.dart';

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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    void navPush(page) {
      Navigator.push(context,
          MyRoute(
              builder: (context) => page
          )
      );
    }
    Widget? leading() {
      return Center();
    }

    Widget content() {
      return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Welcome\nBack"),
              customTextField(hintText: "Enter email address", label: "Email"),
              customTextField(hintText: "Enter password", label: "Password")
            ]
        ),
        );
    }

    return Scaffold(
      backgroundColor: Color(0xFF03BED6),
      appBar: headerNav(
        title: title(),
        leading: leading(),
        titleSpacing: 0.0,
        centerTitle: false
      ),
      body: SlideTransition(
        position: _animation,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 45, 20, 20),
          decoration: BoxDecoration(
            color: Color(0xFFF1F3F6),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              topLeft: Radius.circular(50),
            ),
          ),
          child: content(),
        )
      ),
    );
  }
}