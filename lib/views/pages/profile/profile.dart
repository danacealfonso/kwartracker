import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cButton.dart';
import '../../widgets/headerNav.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String text = "...";

  static const platform =
  const MethodChannel("com.danace.kwartracker/pltChannel");

  Future<void> klikBtn() async {
    String? textResult;

    try{
      final String result = await platform.invokeMethod("helloWorld");
      textResult = result;
    }on PlatformException catch(e){
      print(e);
    }

    setState(() {
      text = textResult!;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      return Text(
          "My Profile",
        );
    }
    Widget content() {
      return Container(
          decoration: BoxDecoration(
            color: Color(0xFFF1F3F6),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              topLeft: Radius.circular(50),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: CButton(text: 'batt', onPressed: () {
                klikBtn();
              },
              )
            ),
          )
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
          backgroundColor: Color(0xFF03BED6),
          appBar: headerNav(
              title: title(),
              action: actionButtons
          ),
          body: CBody(child: content())
      ),
    );
  }
}