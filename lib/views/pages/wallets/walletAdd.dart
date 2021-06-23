import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cCardWallets.dart';
import 'package:kwartracker/views/widgets/cDropdownTextField.dart';
import 'package:kwartracker/views/widgets/cSwitch.dart';
import 'package:kwartracker/views/widgets/cTextField.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../widgets/headerNav.dart';

class WalletAddPage extends StatefulWidget {
  @override
  _WalletAddPageState createState() => _WalletAddPageState();
}

class _WalletAddPageState extends State<WalletAddPage> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String fName = "";
  String fType = "";
  String fTypeID = "";
  String fCurrency = "";
  String fCurrencyID = "";
  bool showSpinner = false;
  bool fOverallBalance = true;
  Color enableSaveColor = ColorConstants.grey2;
  CardColor cardColor = CardColor.cyan;
  final walletTypeList = <PopupMenuEntry>[];
  final currencyList = <PopupMenuEntry>[];
  var walletTypeListFS = {};

  void getLists() async {
    walletTypeList.clear();
    currencyList.clear();
    walletTypeListFS.clear();

    currencyList.add(PopupMenuItem<List>(
        child: Text('Peso'), value: ['Peso', 'Peso']));
    currencyList.add(PopupMenuItem<List>(
        child: Text('Dollar'), value: ['Dollar', 'Dollar']));

    await for (var snapshot in _fireStore
      .collection("walletType").snapshots()) {
      for (var walletType in snapshot.docs) {
        String walletName = walletType.data()["name"];
        String walletId = walletType.id;
        String walletColor = walletType.data()["colorName"];
        List value = [walletId, walletName];
        walletTypeList.add(PopupMenuItem<List>(
          child: Text(walletName), value: value));

        walletTypeListFS.putIfAbsent(walletId, () => walletColor);
      }
      for (CardColor cColor in CardColor.values) {
        if(cardColor != cColor) {
          var cColorLast = cColor.toString().split('.').last;
          if (cColorLast == walletTypeListFS[fTypeID]) {
            setState(() {
              cardColor = cColor;
            });
            break;
          }
        }
      }
    }
  }

  bool validateFields () {
    var validate = true;
    if (fName.isEmpty) validate = false;
    if (fType.isEmpty) validate = false;
    if (fCurrency.isEmpty) validate = false;

    if (validate == true)
      enableSaveColor = ColorConstants.grey;

    return validate;
  }

  @override
  Widget build(BuildContext context) {
    getLists();
    validateFields();

    Widget title() {
      return Text(
        "Add Wallet",
      );
    }
    var actionButtons = [
      TextButton(
        onPressed: () {
          if (validateFields() == true) {
            setState(() => showSpinner = true);
            try{
              _fireStore.collection("wallets").add({
                'uID': _auth.currentUser!.uid,
                'name': fName,
                'currency': fCurrency,
                'type': fTypeID,
                'overallBalance': fOverallBalance,
                'created_at': FieldValue.serverTimestamp()
              }).then((value) {
                setState(() => showSpinner = false);
                Navigator.pop(context);
              });
            } catch (e) {
              setState(() => showSpinner = false);
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text("Save",
            style: TextStyle(
              fontSize: 16,
              color: enableSaveColor
            )
          ),
        ),
      ),
    ];
    Widget content() {
      return Container(
        padding: const EdgeInsets.fromLTRB(30,30,30,0),
        child: ListView(
          padding: EdgeInsets.only(bottom: 30),
          children: <Widget>[
            Center(child: CCardWallets(
              txtWallet: fName.toString(),
              txtTypeWallet: fType,
              currency: fCurrency,
              cardSize: CardSize.large,
              cardColor: cardColor,)
            ),
            CTextField(
              label: "Wallet Name",
              hintText: "Enter wallet name",
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  fName = value;
                });
              },
            ),
            CDropdownTextField(
                label: "Currency",
                hintText: "Select wallet currency",
                text: fCurrency,
                onChanged: (value) {
                  setState(() {
                    fCurrency = value[1];
                    fCurrencyID = value[0];
                  });
                },
                items: currencyList
            ),
            CDropdownTextField(
                label: "Wallet Type",
                hintText: "Select wallet type",
                text: fType,
                onChanged: (value) {
                  setState(() {
                    fType = value[1];
                    fTypeID = value[0];
                  });
                },
                items: walletTypeList
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 7),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      "Include in overall total balance?",
                      style: TextStyle(
                          color: ColorConstants.grey6,
                          fontSize: 12
                      ),
                    ),
                  )
              ),
            ),
            Row(children: [
              Text("Yes"),
              RotatedBox(
                quarterTurns: 2,
                child: Container(
                  margin: EdgeInsets.only(right: 10, left: 10),
                  child: CSwitch(
                    value: fOverallBalance,
                    onChanged: (bool val){
                      setState(() {
                        fOverallBalance = val;
                      });
                    },
                  ),
                ),
              ),
              Text("No"),
            ],)

          ]
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
            backgroundColor: Color(0xFF03BED6),
            appBar: headerNav(
                title: title(),
                action: actionButtons
            ),
            body: CBody(child: content(),hasScrollBody: true,)
        ),
      ),
    );
  }
}