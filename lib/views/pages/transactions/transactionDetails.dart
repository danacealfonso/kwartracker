import 'package:flutter/material.dart';
import 'package:kwartracker/views/widgets/cBody.dart';

import '../../widgets/headerNav.dart';

class TransactionDetailsPage extends StatefulWidget {
  final String? walletID;
  TransactionDetailsPage(this.walletID);

  @override
  _TransactionDetailsPageState createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
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
      return Column(children: [
        Text(
          "Hello",
        ),
        Text(
          "Samantha",
        ),
      ]);
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
                child: Text("Settings")
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