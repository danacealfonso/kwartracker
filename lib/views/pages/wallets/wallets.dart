// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:kwartracker/model/firestore_data.dart';
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/util/my_route.dart';
import 'package:kwartracker/views/pages/transactions/transaction_add_details.dart';
import 'package:kwartracker/views/pages/transactions/transactions.dart';
import 'package:kwartracker/views/pages/wallets/wallet_save.dart';
import 'package:kwartracker/views/widgets/card_wallets.dart';
import 'package:kwartracker/views/widgets/custom_body.dart';
import 'package:kwartracker/views/widgets/custom_floating_button.dart';
import 'package:kwartracker/views/widgets/custom_progress_bar.dart';
import 'package:kwartracker/views/widgets/custom_transaction_list.dart';
import '../../widgets/header_nav.dart';

class WalletsPage extends StatefulWidget {
  const WalletsPage({this.cardIndex});
  final int? cardIndex;

  @override
  _WalletsPageState createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletsPage> {
  bool overAllBalance = false;
  List<bool> showGoal = <bool>[];
  List<String> targetAmount = <String>[];

  Widget title() {
    return const Text(
      'My Wallet',
    );
  }
  int prevListCount = 0;
  int _current = 0;

  @override
  void initState() {
    if (widget.cardIndex != null) {
      _current = widget.cardIndex!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> actionButtons = <Widget>[
      CustomFloatingButton(
        icon: Image.asset(
          'images/icons/ic_add.png',
          width: 10,
          height: 10,
          fit:BoxFit.fill
        ),
        onPressed: () {
          Navigator.push(context,
            MyRoute<dynamic>(
              builder: (BuildContext context) => const WalletSavePage(),
              routeSettings: const RouteSettings(name: '/walletAdd'),
            )
          );
        }
      )
    ];

    Widget content() {
      return Consumer<FirestoreData>(
        builder: (BuildContext context, FirestoreData firestoreData, Widget? child) {
          targetAmount.clear();
          showGoal.clear();
          final List<Widget> imageSliders = firestoreData
            .walletsList.map((dynamic item) {
            showGoal.add(item['type'].toString().toLowerCase() == 'goal');
            targetAmount.add(
              item['targetAmount'] != null ?
                '${item['currencySign']} ${NumberFormat
                .currency(customPattern: '#,###.##')
                .format(item['targetAmount'])}'
                : '0.00'
            );
             return Container(
               child: Container(
                 width: 240,
                 child: CardWallets(
                   txtTypeWallet: item['type'],
                   txtWallet: item['name'],
                   availableBalance: item['amount'],
                   cardSize: CardSize.large,
                   cardColor: item['color'],
                   currencyID: item['currencyID'],
                 )
               ),
             );
          }).toList();
          return Container(
            height: 300,
            child: Column(
              children: <Widget>[
                Stack(
                    children: <Widget>[
                      CarouselSlider(
                        items: imageSliders,
                        options: CarouselOptions(
                          initialPage: _current,
                          viewportFraction: 0.6,
                          aspectRatio: 2.0,
                          onPageChanged: (int index,
                              CarouselPageChangedReason reason) {
                            if(mounted) {
                              setState(() {
                              _current = index;
                              overAllBalance = firestoreData
                                .overallBalance[index];
                            });
                            }
                          }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 180.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: firestoreData
                            .walletsList.map((dynamic item) {

                            final int index = firestoreData
                              .walletsList.indexOf(item);

                            return _current == index ? Container(
                              width: 15.0,
                              height: 10.0,
                              margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                                color : ColorConstants.cyan,
                              ),
                            ) : Container(
                              width: 10.0,
                              height: 10.0,
                              margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                                color : ColorConstants.grey1,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ]
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30,20,30,30),
                  child: Row(children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(6, 6),
                            ),
                            BoxShadow(
                              color: Color(0xFFFFFFFF),
                              blurRadius: 10,
                              offset: Offset(-6, -6),
                            ),
                          ],
                        ),
                        child: FloatingActionButton(
                          heroTag: null,
                          elevation: 0,
                          backgroundColor: ColorConstants.grey,
                          onPressed: () {
                            Navigator.push(context,
                              MyRoute<dynamic>(
                                builder: (BuildContext context) => WalletSavePage(
                                  walletID: firestoreData.walletIDs[_current]
                                ),
                                routeSettings: const RouteSettings(
                                  name: '/walletSave'
                                ),
                              )
                            );
                          },
                          child: Image.asset(
                            'images/icons/ic_edit.png',
                            width: 10,
                            height: 10,
                            fit:BoxFit.fill
                          )
                        )
                    ),
                    const Expanded(child: Text('Edit Wallet',
                        style: TextStyle(
                            color: ColorConstants.grey6,
                            fontSize: 12
                        ))),
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 30,
                        width: 30,
                        child: FloatingActionButton(
                            heroTag: null,
                            backgroundColor: ColorConstants.grey,
                            elevation: 0,
                            onPressed: () {
                              Navigator.push(context,
                                MyRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                    TransactionAddDetailsPage(
                                    firestoreData.walletIDs[_current]
                                  ),
                                  routeSettings: const RouteSettings(
                                    name: '/transactionAddDetailsPage')
                                  ,
                                )
                              );
                            },
                            child: Image.asset(
                                'images/icons/ic_add_grey.png',
                                width: 10,
                                height: 10,
                                fit:BoxFit.fill
                            )
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(6, 6),
                            ),
                            BoxShadow(
                              color: Color(0xFFFFFFFF),
                              blurRadius: 10,
                              offset: Offset(-6, -6),
                            ),
                          ],
                        )
                    ),
                    const Expanded(child: Text('Add Transaction',
                      style: TextStyle(
                          color: ColorConstants.grey6,
                          fontSize: 12
                      ),
                    ))
                  ]),
                ),
                if (showGoal.length-1 >= _current)
                if (showGoal[_current]==true) Container(
                  margin: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    bottom: 30
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                      Row(
                        children: <Widget>[
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                targetAmount[_current],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.cyan
                                ),
                              ),
                              const Text('to target amount',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ColorConstants.black1
                                )),
                            ],
                          )),
                          Container(
                              height: 40,
                              child: const VerticalDivider(
                                  color: Colors.grey
                              )
                          ),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const <Widget>[
                              Text(
                                  '1Y : 10M : 10D',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstants.cyan
                                  )
                              ),
                              Text('to target date',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorConstants.black1
                                  )),
                            ],
                          )
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: CustomProgressBar(max: 100, current: 30,
                          backgroundColor: ColorConstants.grey4,
                          progressBarColor: ColorConstants.cyan,
                        ),
                      ),
                    ]
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text(
                              'Transactions',
                              style: TextStyle(
                                  color: ColorConstants.black1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700
                              )
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                              MyRoute<dynamic>(
                                builder: (BuildContext context) => TransactionsPage(),
                                routeSettings: const RouteSettings(
                                  name: '/transactions'
                                ),
                              )
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const <Widget>[
                              Text(
                              'View All',
                              style: TextStyle(
                                color: ColorConstants.grey6,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500
                              )
                            )],
                          ),
                        )]
                  ),
                ),
                Expanded(
                  child: CustomTransactionList(
                    key: Key(firestoreData.walletIDs[_current]),
                    walletID: (firestoreData.walletIDs.isNotEmpty)?
                    firestoreData.walletIDs[_current]: '',
                    paddingItem: const EdgeInsets.only(left: 30,right: 30),
                  ),
                ),
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
          body: CustomBody(child: content(),hasScrollBody: true,)
      ),
    );
  }
}
