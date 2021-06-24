import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String fWallet = "";
  String fWalletID = "";
  final walletsList = <PopupMenuEntry>[];

  var actionButtons = [
    TextButton(
        onPressed: () {  },
        child: Text(""),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<Null> _getData() async {
    walletsList.clear();
    var walletsStream = _fireStore.collection("wallets")
        .where("uID", isEqualTo: _auth.currentUser!.uid)
        .orderBy("name")
        .snapshots();

    walletsStream.listen((snapshot) {
      for (var wallet in snapshot.docs) {
        String walletName = wallet.data()["name"];
        String walletID = wallet.id;

        List value = [walletID, walletName];

        walletsList.add(PopupMenuItem<List>(
            child: Text(walletName), value: value)
        );
      }
    });
    return null;
  }

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
                label: "Which wallet do you want it to add?",
                hintText: "Select wallet to add",
                text: fWallet,
                onChanged: (value) {
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