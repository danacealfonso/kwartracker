// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:kwartracker/model/firestore_data.dart';
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/util/my_route.dart';
import 'package:kwartracker/views/pages/transactions/transaction_add_details.dart';
import 'package:kwartracker/views/widgets/custom_body.dart';
import 'package:kwartracker/views/widgets/custom_button.dart';
import 'package:kwartracker/views/widgets/custom_dropdown.dart';
import '../../widgets/header_nav.dart';

class TransactionChooseWalletPage extends StatefulWidget {
  @override
  _TransactionChooseWalletPagePageState createState() =>
      _TransactionChooseWalletPagePageState();
}

class _TransactionChooseWalletPagePageState extends
  State<TransactionChooseWalletPage> {
  String fWallet = '';
  String fWalletID = '';
  List<PopupMenuEntry<dynamic>> walletsList = <PopupMenuEntry<dynamic>>[];

  List<Widget> actionButtons = <Widget>[
    TextButton(
        onPressed: () {  },
        child: const Text(''),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget title() {
      return const Text(
        'Add Transaction',
      );
    }

    walletsList = Provider.of<FirestoreData>(context)
        .walletsList.map((Map<String, dynamic> item) {
      return PopupMenuItem<dynamic>(
          child: Text(item['name']),
          value: <dynamic>[item['id'], item['name']]
      );
    }).toList();

    Widget content() {
      return Container(
        padding: const EdgeInsets.fromLTRB(30,0,30,30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CustomDropdown(
                label: 'Which wallet do you want it to add?',
                hintText: 'Select wallet to add',
                text: fWallet,
                onChanged: (dynamic value) {
                  if(value!=null) {
                    setState(() {
                    fWallet = value[1];
                    fWalletID = value[0];
                  });
                  }
                },
                items: walletsList
            ),
            Container(
              width: double.infinity,
              child: CustomButton(
                  text: 'Next',
                  backgroundColor: ColorConstants.cyan,
                  onPressed: () {
                    Navigator.push(context,
                      MyRoute<dynamic>(
                        builder: (BuildContext context) =>
                            TransactionAddDetailsPage(fWalletID),
                        routeSettings: const RouteSettings(name:
                        '/transactionAddDetailsPage'),
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
        backgroundColor: const Color(0xFF03BED6),
        appBar: headerNav(
          title: title(),
          action: actionButtons
        ),
        body: CustomBody(child: content())
      ),
    );
  }
}
