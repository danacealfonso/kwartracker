import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/model/firestoreData.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/pages/transactions/transactionAddWallet.dart';
import 'package:kwartracker/views/widgets/cButton.dart';
import 'package:kwartracker/views/widgets/cDropdownTextField.dart';
import 'package:kwartracker/views/widgets/cTextField.dart';
import 'package:kwartracker/views/widgets/cTransactionList.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:provider/provider.dart';
import '../../widgets/headerNav.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
    with TickerProviderStateMixin {
  final _fireStore = FirebaseFirestore.instance;
  String fDate = "";
  String fDateID = "";
  List<PopupMenuEntry<dynamic>> categoryList = <PopupMenuEntry>[];
  List<PopupMenuEntry<dynamic>> walletTypeList = <PopupMenuEntry>[];
  String fCategory = "";
  String fCategoryID = "";
  String fType = "";
  String fTypeID = "";

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
      return Consumer<FirestoreData>(
        builder: (context, firestoreData, child) {

          categoryList = firestoreData.categoriesList.map((item) {
            return PopupMenuItem<List>(
                child: Text(item["name"]), value: [item["id"],item["name"]]);
          }).toList();

          walletTypeList = firestoreData.walletTypeData.map((item) {
            return PopupMenuItem<List>(
                child: Text(item["name"]), value: [item["id"],item["name"]]);
          }).toList();

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
                        onPressed: (){
                          showModalBottomSheet(context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                      child: Container(
                                          height: 500.0,
                                          child: Container(
                                              padding: EdgeInsets.fromLTRB(30, 40, 30, 30),
                                              decoration: new BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: new BorderRadius.only(
                                                  topLeft: const Radius.circular(60.0),
                                                  topRight: const Radius.circular(60.0)
                                                )
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                            "Default date range",
                                                            style: TextStyle(
                                                                color: ColorConstants.black,
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold
                                                            )
                                                        ),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            height: 30,
                                                            width: 30,
                                                            child: FloatingActionButton(
                                                              backgroundColor: ColorConstants.grey,
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              child: Image.asset(
                                                                'images/icons/ic_close.png',
                                                                width: 10,
                                                                height: 10,
                                                                fit:BoxFit.fill
                                                              )
                                                            )
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  CDropdownTextField(
                                                      label: "Select Date Range",
                                                      text: fDate,
                                                      onChanged: (value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            fDate = value[1];
                                                            fDateID = value[0];
                                                          });
                                                        }
                                                      },
                                                      items: <PopupMenuEntry>[
                                                        PopupMenuItem<List>(
                                                            child: Text('This week'), value: ['This week', 'This week']),
                                                        PopupMenuItem<List>(
                                                            child: Text('This month'), value: ['This month', 'This month'])
                                                      ]
                                                  ),
                                                  CDropdownTextField(
                                                      label: "Wallet Type",
                                                      hintText: "Select wallet type",
                                                      text: fType,
                                                      onChanged: (value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            fType = value[1];
                                                            fTypeID = value[0];
                                                          });
                                                        }
                                                      },
                                                      items: walletTypeList
                                                  ),
                                                  CDropdownTextField(
                                                      label: "Category",
                                                      hintText: "Select Category",
                                                      text: fCategory.toString(),
                                                      onChanged: (value) {
                                                        if (value != null )
                                                          setState(() {
                                                            fCategory = value[1];
                                                            fCategoryID = value[0];
                                                          });
                                                      },
                                                      items: categoryList
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    child: CButton(
                                                        text: "Apply",
                                                        onPressed: () {}
                                                    ),
                                                  ),
                                                ],
                                              )
                                          )
                                      ),
                                    );
                                  });
                            },
                            barrierColor: Colors.white.withOpacity(0),
                          );
                        },
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