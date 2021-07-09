// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:kwartracker/presentation/widgets/custom_body.dart';
import 'package:kwartracker/presentation/widgets/custom_button.dart';
import '../../widgets/header_nav.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String text = '...';

  static const MethodChannel platform =
      MethodChannel('com.danace.kwartracker/pltChannel');

  Future<void> klikBtn() async {
    String? textResult;

    try {
      final String result = await platform.invokeMethod('helloWorld');
      textResult = result;
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      text = textResult!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> actionButtons = <Widget>[
      TextButton(
          onPressed: null,
          child: Image.asset('images/users/profile_pic.png',
              width: 70, height: 85, fit: BoxFit.fill))
    ];

    Widget title() {
      return const Text(
        'My Profile',
      );
    }

    Widget content() {
      return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF1F3F6),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              topLeft: Radius.circular(50),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Center(
                child: Column(
              children: <Widget>[
                Text(
                  text,
                  style: const TextStyle(fontSize: 20),
                ),
                CustomButton(
                  text: 'check',
                  onPressed: () {
                    klikBtn();
                  },
                ),
              ],
            )),
          ));
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
          backgroundColor: const Color(0xFF03BED6),
          appBar: headerNav(title: title(), action: actionButtons),
          body: CustomBody(child: content())),
    );
  }
}
