import 'package:flutter/material.dart';
import 'package:kwartracker/model/firestoreData.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/pages/transactions/transactionAddDetails.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cButton.dart';
import 'package:kwartracker/views/widgets/cDropdownTextField.dart';
import 'package:provider/provider.dart';
import '../../widgets/headerNav.dart';

class TransactionChooseWalletPage extends StatefulWidget {
  @override
  _TransactionChooseWalletPagePageState createState() =>
      _TransactionChooseWalletPagePageState();
}

class _TransactionChooseWalletPagePageState extends
  State<TransactionChooseWalletPage> {
  String fWallet = "";
  String fWalletID = "";
  List<PopupMenuEntry<dynamic>> walletsList = <PopupMenuEntry>[];

  var actionButtons = [
    TextButton(
        onPressed: () {  },
        child: Text(""),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget title() {
      return Text(
        "Add Transaction",
      );
    }

    walletsList = Provider.of<FirestoreData>(context)
        .walletsList.map((item) {
      return PopupMenuItem<List>(
          child: Text(item["name"]),
          value: [item["id"], item["name"]]
      );
    }).toList();

    Widget content() {
      return Container(
        padding: const EdgeInsets.fromLTRB(30,0,30,30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CDropdownTextField(
                label: "Which wallet do you want it to add?",
                hintText: "Select wallet to add",
                text: fWallet,
                onChanged: (value) {
                  if(value!=null)
                  setState(() {
                    fWallet = value[1];
                    fWalletID = value[0];
                  });
                },
                items: walletsList
            ),
            Container(
              width: double.infinity,
              child: CButton(
                  text: "Next",
                  backgroundColor: ColorConstants.cyan,
                  onPressed: () {
                    Navigator.push(context,
                      MyRoute(
                        builder: (context) => TransactionAddDetailsPage(fWalletID),
                        routeSettings: RouteSettings(name: "/transactionAddDetailsPage"),
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