import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/pages/transactions/transactionAddWallet.dart';
import 'package:kwartracker/views/widgets/cButton.dart';
import 'package:kwartracker/views/widgets/cTextField.dart';
import 'package:kwartracker/views/widgets/cTransactionList.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import '../../widgets/headerNav.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
    with TickerProviderStateMixin {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

    var actionButtons = [
      Builder(
        builder: (BuildContext context) {
          return Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.all(20),
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: ColorConstants.grey,
              onPressed: () {
                Navigator.push(context,
                  MyRoute(
                    builder: (context) => TransactionAddWalletPage(),
                    routeSettings: RouteSettings(name: "/transactionAddWallet"),
                  )
                );
              },
              child: Image.asset(
                  'images/icons/ic_add.png',
                  width: 10,
                  height: 10,
                  fit:BoxFit.fill
              )
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(6, 6),
                ),
                BoxShadow(
                  color: Color(0x82FFFFFF),
                  blurRadius: 8,
                  offset: const Offset(-4, -2),
                ),
              ],
            )
          );
        },
      )
    ];

    Widget title() {
      return Text(
          "Transactions",
        );
    }

    Widget content() {
      return Container(
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30,0,30,10),
              child: Row(children: [
                Expanded(child:
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Stack(children: [
                      CTextField(hintText: "Search transaction",),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 25,
                          width: 25,
                          margin: EdgeInsets.fromLTRB(0, 15, 15, 0),
                          child: Image.asset(
                            'images/icons/ic_search.png',
                            width: 16,
                            height: 16,
                            fit:BoxFit.fill
                          ),
                        ),
                      ),
                    ]),
                  )
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  height: 58,
                  width: 58,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15)),
                    onPressed: (){},
                    child: Image.asset(
                        'images/icons/ic_filter.png',
                        width: 16,
                        height: 16,
                        fit:BoxFit.fill
                    ),
                    color: ColorConstants.cyan,
                  ),
                )
              ],),
            ),
            Flexible(child: CTransactionList(paddingItem: EdgeInsets.fromLTRB(30, 0, 30, 0),)),
          ],
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
          body: CBody(child: content(), hasScrollBody: true)
      ),
    );
  }
}