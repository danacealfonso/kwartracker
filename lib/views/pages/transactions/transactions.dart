// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:kwartracker/model/firestore_data.dart';
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/util/my_route.dart';
import 'package:kwartracker/views/pages/transactions/transaction_choose_wallet.dart';
import 'package:kwartracker/views/widgets/custom_body.dart';
import 'package:kwartracker/views/widgets/custom_button.dart';
import 'package:kwartracker/views/widgets/custom_dropdown.dart';
import 'package:kwartracker/views/widgets/custom_floating_button.dart';
import 'package:kwartracker/views/widgets/custom_text_field.dart';
import 'package:kwartracker/views/widgets/custom_transaction_list.dart';
import '../../widgets/header_nav.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
    with TickerProviderStateMixin {
  String fDate = '';
  String fDateID = '';
  List<PopupMenuEntry<dynamic>> categoryList = <PopupMenuEntry<dynamic>>[];
  List<PopupMenuEntry<dynamic>> walletTypeList = <PopupMenuEntry<dynamic>>[];
  String fCategory = '';
  String fCategoryID = '';
  String fType = '';
  String fTypeID = '';

  @override
  Widget build(BuildContext context) {
    final List<Widget> actionButtons = <Widget>[
      CustomFloatingButton(
        icon: Image.asset(
            'images/icons/ic_add.png',
            width: 10,
            height: 10,
            fit:BoxFit.fill
        ), onPressed: () {
          Navigator.push(context,
            MyRoute<dynamic>(
              builder: (BuildContext context) => TransactionChooseWalletPage(),
              routeSettings:
              const RouteSettings(name: '/transactionAddWallet')
            )
          );
        }
      )
    ];

    Widget title() {
      return const Text(
          'Transactions',
        );
    }

    Widget content() {
      return Consumer<FirestoreData>(
        builder: (BuildContext context, FirestoreData firestoreData, Widget? child) {

          categoryList = firestoreData.categoriesList.map((dynamic item) {
            return PopupMenuItem<dynamic>(
                child: Text(item['name']), value: 
            <dynamic>[item['id'],item['name']]);
          }).toList();

          walletTypeList = firestoreData.walletTypeData.map((dynamic item) {
            return PopupMenuItem<dynamic>(
                child: Text(item['name']), value: 
            <dynamic>[item['id'],item['name']]);
          }).toList();

          return Container(
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(30,0,30,10),
                  child: Row(children: <Widget>[
                    Expanded(child:
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Stack(children: <Widget>[
                        const CustomTextField(hintText: 'Search transaction',),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 25,
                            width: 25,
                            margin: const EdgeInsets.fromLTRB(0, 15, 15, 0),
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
                      margin: const EdgeInsets.only(left: 10),
                      height: 58,
                      width: 58,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onPressed: (){
                          showModalBottomSheet(context: context,
                              isScrollControlled:true,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                      child: Container(
                                          height: 500.0,
                                          child: Container(
                                              padding: const EdgeInsets.fromLTRB(30, 40, 30, 30),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(60.0),
                                                  topRight: Radius.circular(60.0)
                                                )
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      const Expanded(
                                                        child: Text(
                                                            'Default date range',
                                                            style: TextStyle(
                                                                color: ColorConstants.black,
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold
                                                            )
                                                        ),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: <Widget>[
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
                                                  CustomDropdown(
                                                      label: 'Select Date Range',
                                                      text: fDate,
                                                      onChanged: (dynamic value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            fDate = value[1];
                                                            fDateID = value[0];
                                                          });
                                                        }
                                                      },
                                                      items: const <PopupMenuEntry<dynamic>>[
                                                        PopupMenuItem<dynamic>(
                                                            child: Text('This week'),
                                                            value: <String>['This week', 'This week']),
                                                        PopupMenuItem<dynamic>(
                                                            child: Text('This month'),
                                                            value: <String>['This month', 'This month'])
                                                      ]
                                                  ),
                                                  CustomDropdown(
                                                      label: 'Wallet Type',
                                                      hintText: 'Select wallet type',
                                                      text: fType,
                                                      onChanged: (dynamic value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            fType = value[1];
                                                            fTypeID = value[0];
                                                          });
                                                        }
                                                      },
                                                      items: walletTypeList
                                                  ),
                                                  CustomDropdown(
                                                      label: 'Category',
                                                      hintText: 'Select Category',
                                                      text: fCategory.toString(),
                                                      onChanged: (dynamic value) {
                                                        if (value != null ) {
                                                          setState(() {
                                                            fCategory = value[1];
                                                            fCategoryID = value[0];
                                                          });
                                                        }
                                                      },
                                                      items: categoryList
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    child: CustomButton(
                                                        text: 'Apply',
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
                const Flexible(child:
                CustomTransactionList(paddingItem:
                EdgeInsets.fromLTRB(30, 0, 30, 0),)),
              ],
            ),
          );
        }
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
          body: CustomBody(child: content(), hasScrollBody: true)
      ),
    );
  }
}
