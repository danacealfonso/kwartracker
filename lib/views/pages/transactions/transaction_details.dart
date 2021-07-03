// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:kwartracker/provider/firestore_data.dart';
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/util/my_route.dart';
import 'package:kwartracker/views/pages/transactions/transaction_edit.dart';
import 'package:kwartracker/views/widgets/confirmation_dialog.dart';
import 'package:kwartracker/views/widgets/custom_body.dart';
import 'package:kwartracker/views/widgets/custom_dialog.dart';
import '../../widgets/header_nav.dart';

class TransactionDetailsPage extends StatefulWidget {
  const TransactionDetailsPage(this.transactionID);
  final String? transactionID;

  @override
  _TransactionDetailsPageState createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Map<String, dynamic> transaction = <String, dynamic>{};
  String? fDate;
  String? photoURL;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> actionButtons = <Widget>[
      TextButton(
        onPressed: () {
          Navigator.push(context,
            MyRoute<dynamic>(
              builder: (BuildContext context) =>
                  TransactionEditPage(widget.transactionID),
              routeSettings:  const RouteSettings(name: '/transactionEdit')
            )
          );
        },
        child: const Padding(
          padding: EdgeInsets.only(right: 20),
          child: Text('Edit',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white
            )
          ),
        ),
      ),
    ];

    Widget title() {
      return const Text('Transaction');
    }

    Future<void> _showDialog(dynamic path) async {
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
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))
              ),
              content: Container(
                height: 450,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 360,
                        decoration: BoxDecoration(
                          color: ColorConstants.grey,
                          borderRadius: const BorderRadius.only(
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
                        padding: const EdgeInsets.only(top: 30,bottom: 30),
                        height: 90,
                        width: double.infinity,
                        decoration: const BoxDecoration(
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
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(6, 6),
                                  ),
                                  BoxShadow(
                                    color: Color(0x82FFFFFF),
                                    blurRadius: 10,
                                    offset: Offset(-6, -6),
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
        child: Row(children: <Widget>[
          Expanded(child: Text(left, style:
          const TextStyle(
              fontSize: 12,
              color: ColorConstants.grey6
          ),)),
          if (right.isNotEmpty) Expanded(child: Text(right, style:
          const TextStyle(
              fontSize: 12,
              color: ColorConstants.grey6
          ))),
        ],
        ),
      );
    }

    Widget info(String left, String right, {TextStyle? leftTextStyle,
      IconData? iconData}) {
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(children: <Widget>[
          Expanded(child: Row(
            children: <Widget>[
              if (iconData != null) Container(
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  color: ColorConstants.cyan,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Icon(
                  iconData,
                  color: Colors.white,
                  size: 8,
                ),
              ),
              Text(left, style:
              (leftTextStyle == null)? const TextStyle(
                fontSize: 16,
                color: ColorConstants.black,
                fontWeight: FontWeight.w700
              ): leftTextStyle),
            ],
          )),
          if (right.isNotEmpty) Expanded(child: Text(right, style:
          const TextStyle(
            fontSize: 16,
            color: ColorConstants.black,
            fontWeight: FontWeight.w700
          ))),
        ],
        ),
      );
    }

    Widget content() {
      return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF1F3F6),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              topLeft: Radius.circular(50),
            ),
          ),
          child: Container(
            height: double.infinity,
            child: Consumer<FirestoreData>(
              builder: (BuildContext context,
                  FirestoreData firestoreData,
                  Widget? child) {
                Provider.of<FirestoreData>(context,listen: true)
                    .getTransaction(widget.transactionID!).then((dynamic value) {
                  if(value['fDate'] != null) {
                    final Timestamp t = value['fDate'];
                    fDate = '${DateFormat.MMMMd().format(t.toDate())}, '
                        '${DateFormat.y().format(t.toDate())}';
                  }
                  if (mounted) {
                    setState(() {
                    transaction = value;
                  });
                  }

                });
                if(transaction.isEmpty) {
                  firestoreData.showSpinner = true;
                } else {
                  firestoreData.showSpinner = false;
                }
                return (transaction.isEmpty)? ModalProgressHUD(
                  color: Colors.transparent,
                  inAsyncCall: firestoreData.showSpinner, child: const SizedBox()
                ) :ListView(
                  padding: const EdgeInsets.fromLTRB(30,0,30,30),
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text(''),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment
                            .end,
                          children: <Widget>[
                            Container(
                              height: 30,
                              width: 30,
                              child: FloatingActionButton(
                                elevation: 0,
                                backgroundColor: ColorConstants
                                  .grey,
                                onPressed: () {
                                  confirmationDialog(context,
                                  'Are you sure you want to delete this?',
                                  () async {
                                    firestoreData.showSpinner = true;
                                    await _fireStore.collection('transactions')
                                      .doc(widget.transactionID.toString()
                                    ).delete().then((_) {
                                      firestoreData.showSpinner = false;
                                      int count = 0;
                                      Navigator.popUntil(context,
                                        (Route<dynamic> route) {
                                        return count++ == 2;
                                      });
                                      customDialog(
                                        context,
                                        'Deleted',
                                        'It has been successfully deleted.',
                                        'Exit',
                                        const Icon(
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
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(6, 6),
                                  ),
                                  BoxShadow(
                                    color: Color(0x82FFFFFF),
                                    blurRadius: 10,
                                    offset: Offset(-6, -6),
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
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4F6),
                        border: Border.all(
                          color: const Color(0x00000029),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(6, 6),
                          ),
                          BoxShadow(
                            color: Color(0xA8FFFFFF),
                            blurRadius: 10,
                            offset: Offset(-6, -6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            '${transaction['currencySign'].toString()} '
                            '${transaction['stringAmount'].toString()}', style:
                            const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.green1
                            ),
                          ),
                          Text(transaction['name'], style:
                          const TextStyle(
                            fontSize: 16
                          ),
                          ),
                        ]
                      ),
                    ),
                    labelInfo('Transaction type', 'Transaction date'),
                    info(transaction['type'], fDate!),
                    labelInfo('Category', 'Added to wallet'),
                    info(transaction['categoryName'], transaction['walletName'],
                    leftTextStyle: const TextStyle(
                        fontSize: 12,
                        color: ColorConstants.cyan,
                        fontWeight: FontWeight.bold
                    ),iconData: Icons.receipt_outlined),
                    labelInfo('Spent with', ''),
                    info(transaction['spentPerson'], ''),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: labelInfo('Transaction image', ''),
                    ),
                    if (transaction['photoURL']!=null) GestureDetector(
                      onTap: () {
                        _showDialog(transaction['photoURL']!);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 190,
                        decoration: BoxDecoration(
                          color: ColorConstants.grey,
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(transaction['photoURL']!),
                          ),
                        )
                      )
                    ),
                    labelInfo(transaction['fileName']!, ''),
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
          backgroundColor: const Color(0xFF03BED6),
          appBar: headerNav(
              title: title(),
              action: actionButtons
          ),
          body: CustomBody(child: content(), hasScrollBody: true,)
      ),
    );
  }
}
