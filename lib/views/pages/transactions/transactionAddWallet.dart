import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/pages/transactions/transactionAddDetails.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cButton.dart';
import 'package:kwartracker/views/widgets/cDropdownTextField.dart';
import '../../widgets/headerNav.dart';

class TransactionAddWalletPage extends StatefulWidget {
  @override
  _TransactionAddWalletPageState createState() => _TransactionAddWalletPageState();
}

class _TransactionAddWalletPageState extends State<TransactionAddWalletPage> {
  late final String fName;
  late final String fType;
  late final String fCategory;
  late final String fDate;
  late final String fPerson;
  late final String fPhoto;
  var actionButtons = [
    TextButton(
        onPressed: () {  },
        child: Text(""),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Widget title() {
      return Text(
        "Add Transaction",
      );
    }

    Widget content() {
      return Container(
        padding: const EdgeInsets.fromLTRB(30,0,30,30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CDropdownTextField(
                hintText: "Select wallet to add",
                label: "Which wallet do you want it to add?",
                onChanged: (value) {
                  fType = value;
                },
                items: [
                  PopupMenuItem<String>(
                      child: const Text('Salary'), value: 'Salary'),
                  PopupMenuItem<String>(
                      child: const Text('Bills'), value: 'Bills'),
                  PopupMenuItem<String>(
                      child: const Text('Shopping'), value: 'Shopping'),
                ]
            ),
            Container(
              width: double.infinity,
              child: CButton(
                  text: "Next",
                  backgroundColor: ColorConstants.cyan,
                  onPressed: () {
                    Navigator.push(context,
                        MyRoute(
                            builder: (context) => TransactionAddDetailsPage()
                        )
                    );
                  }
              ),
            ),
          ]
        ),
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