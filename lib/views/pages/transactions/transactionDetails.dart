import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kwartracker/model/firestoreData.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/pages/transactions/transactionEdit.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cConfirmationDialog.dart';
import 'package:kwartracker/views/widgets/cDialog.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../widgets/headerNav.dart';

class TransactionDetailsPage extends StatefulWidget {
  final String? transactionID;
  TransactionDetailsPage(this.transactionID);

  @override
  _TransactionDetailsPageState createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  final _fireStore = FirebaseFirestore.instance;
  Map<String, dynamic> transaction = Map<String, dynamic>();
  String? fDate;
  String? photoURL;
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
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var actionButtons = [
      TextButton(
        onPressed: () {
          Navigator.push(context,
            MyRoute(
              builder: (context) => TransactionEditPage(widget.transactionID),
              routeSettings:  RouteSettings(name: "/transactionEdit")
            )
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text("Edit",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white
            )
          ),
        ),
      ),
    ];

    Widget title() {
      return Text("Transaction");
    }

    Future<void> _showDialog(path) async {
      return showDialog<void>(
        barrierColor: Colors.transparent,
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20, sigmaY: 20),
            child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              backgroundColor: ColorConstants.grey7,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))
              ),
              content: Container(
                height: 450,
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 360,
                        decoration: BoxDecoration(
                          color: ColorConstants.grey,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30)
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(path),
                          ),
                        )
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 30,bottom: 30),
                        height: 90,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ColorConstants.grey,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)
                          )
                        ),
                        child: Center(
                          child: Container(
                            width: 30,
                            height: 30,
                            child: FloatingActionButton(
                              elevation: 0,
                              backgroundColor: ColorConstants
                                  .grey,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Image
                                  .asset(
                                  'images/icons/ic_close.png',
                                  width: 10,
                                  height: 10,
                                  fit: BoxFit
                                      .fill
                              )
                            ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: const Offset(6, 6),
                                  ),
                                  BoxShadow(
                                    color: Color(0x82FFFFFF),
                                    blurRadius: 10,
                                    offset: const Offset(-6, -6),
                                  ),
                                ],
                              )
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    Widget labelInfo(String left, String right) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(children: [
          Expanded(child: Text(left, style:
          TextStyle(
              fontSize: 12,
              color: ColorConstants.grey6
          ),)),
          (right.isNotEmpty)? Expanded(child: Text(right, style:
          TextStyle(
              fontSize: 12,
              color: ColorConstants.grey6
          ))):SizedBox(),
        ],
        ),
      );
    }

    Widget info(String left, String right, {TextStyle? leftTextStyle,
      IconData? iconData}) {
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(children: [
          Expanded(child: Row(
            children: [
              (iconData != null)? Container(
                padding: EdgeInsets.all(2),
                margin: EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  color: ColorConstants.cyan,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Icon(
                  iconData,
                  color: Colors.white,
                  size: 8,
                ),
              ):SizedBox(),
              Text(left, style:
              (leftTextStyle == null)? TextStyle(
                fontSize: 16,
                color: ColorConstants.black,
                fontWeight: FontWeight.w700
              ): leftTextStyle),
            ],
          )),
          (right.isNotEmpty)? Expanded(child: Text(right, style:
          TextStyle(
            fontSize: 16,
            color: ColorConstants.black,
            fontWeight: FontWeight.w700
          ))):SizedBox(),
        ],
        ),
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
            height: double.infinity,
            child: Consumer<FirestoreData>(
              builder: (context, firestoreData, child) {
                Provider.of<FirestoreData>(context,listen: true)
                    .getTransaction(widget.transactionID!).then((value) {
                  if(value["fDate"] != null) {
                    Timestamp t = value["fDate"];
                    fDate = "${DateFormat.MMMMd().format(t.toDate())}, "
                        "${DateFormat.y().format(t.toDate())}";
                  }
                  if (mounted) setState(() {
                    transaction = value;
                  });

                });
                if(transaction.isEmpty)
                firestoreData.showSpinner = true;
                else
                  firestoreData.showSpinner = false;
                return (transaction.isEmpty)? ModalProgressHUD(
                  color: Colors.transparent,
                  inAsyncCall: firestoreData.showSpinner, child: SizedBox()
                ) :ListView(
                  padding: const EdgeInsets.fromLTRB(30,0,30,30),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(""),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment
                            .end,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              child: FloatingActionButton(
                                elevation: 0,
                                backgroundColor: ColorConstants
                                  .grey,
                                onPressed: () {
                                  cConfirmationDialog(context,
                                  "Are you sure you want to delete this?",
                                  () async {
                                    await _fireStore.collection('transactions').doc(
                                      widget.transactionID.toString()
                                    ).delete().then((_) {
                                      var count = 0;
                                      Navigator.popUntil(context, (route) {
                                        return count++ == 2;
                                      });
                                      cDialog(
                                        context,
                                        "Deleted",
                                        "It has been successfully deleted.",
                                        "Exit",
                                        Icon(
                                          Icons.delete_outline, size: 80,
                                          color: ColorConstants.red,
                                        )
                                      );
                                    });
                                  }
                                  );
                                },
                                child: Image
                                  .asset(
                                  'images/icons/ic_delete.png',
                                  width: 10,
                                  height: 10,
                                  fit: BoxFit
                                      .fill
                                )
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: const Offset(6, 6),
                                  ),
                                  BoxShadow(
                                    color: Color(0x82FFFFFF),
                                    blurRadius: 10,
                                    offset: const Offset(-6, -6),
                                  ),
                                ],
                              )
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 30.0,bottom: 20),
                      padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                      decoration: BoxDecoration(
                        color: Color(0xFFF2F4F6),
                        border: Border.all(
                          color: Color(0x00000029),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(6, 6),
                          ),
                          BoxShadow(
                            color: Color(0xA8FFFFFF),
                            blurRadius: 10,
                            offset: const Offset(-6, -6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "${transaction["currencySign"].toString()} "
                            "${transaction["stringAmount"].toString()}", style:
                            TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.green1
                            ),
                          ),
                          Text(transaction["name"], style:
                          TextStyle(
                            fontSize: 16
                          ),
                          ),
                        ]
                      ),
                    ),
                    labelInfo("Transaction type", "Transaction date"),
                    info(transaction["type"], fDate!),
                    labelInfo("Category", "Added to wallet"),
                    info(transaction["categoryName"], transaction["walletName"],
                    leftTextStyle: TextStyle(
                        fontSize: 12,
                        color: ColorConstants.cyan,
                        fontWeight: FontWeight.bold
                    ),iconData: Icons.receipt_outlined),
                    labelInfo("Spent with", ""),
                    info(transaction["spentPerson"], ""),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: labelInfo("Transaction image", ""),
                    ),
                    (transaction["photoURL"]!=null)?
                    GestureDetector(
                      onTap: () {
                        _showDialog(transaction["photoURL"]!);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 190,
                        decoration: BoxDecoration(
                          color: ColorConstants.grey,
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(transaction["photoURL"]!),
                          ),
                        )
                      )
                    ): Text(""),
                    labelInfo(transaction["fileName"]!, ""),
                  ],
                );
              }
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