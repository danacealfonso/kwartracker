import 'package:flutter/material.dart';
import 'package:kwartracker/model/firestoreData.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:provider/provider.dart';

import '../../widgets/headerNav.dart';

class TransactionEditPage extends StatefulWidget {
  final String? transactionID;
  TransactionEditPage(this.transactionID);

  @override
  _TransactionEditPageState createState() => _TransactionEditPageState();
}

class _TransactionEditPageState extends State<TransactionEditPage> {
  bool enableSaveButton = false;
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
        onPressed: () {
          if (enableSaveButton == true) {
            Provider.of<FirestoreData>(context, listen: false)
                .saveWallet(
                context: context,
                /*walletID: widget.walletID,
                targetAmount: (targetAmount.isNotEmpty) ?
                double.parse(targetAmount):0.00,
                walletName: walletName,
                walletTypeID: walletTypeID,
                overAllBalance: fOverallBalance,
                walletCurrency: walletCurrencyID,
                savedTo: savedTo*/
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text("Save",
              style: TextStyle(
                  fontSize: 16,
                  color: (enableSaveButton == true)? Colors.white
                      : ColorConstants.grey2
              )
          ),
        ),
      ),
    ];

    Widget title() {
      return Text(
          "Edit Transaction",
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