import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kwartracker/model/firestoreData.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/pages/transactions/transactionAddDetails.dart';
import 'package:kwartracker/views/pages/transactions/transactions.dart';
import 'package:kwartracker/views/widgets/cProgressBar.dart';
import 'package:kwartracker/views/widgets/cTransactionList.dart';
import 'package:kwartracker/views/pages/wallets/walletSave.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kwartracker/views/widgets/cCardWallets.dart';
import 'package:provider/provider.dart';
import '../../widgets/headerNav.dart';

class WalletsPage extends StatefulWidget {
  final int? cardIndex;
  WalletsPage({this.cardIndex});

  @override
  _WalletsPageState createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletsPage> {
  bool overAllBalance = false;
  List showGoal = [];
  List targetAmount = [];
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
                        builder: (context) => WalletSavePage(),
                        routeSettings: RouteSettings(name: "/walletAdd"),
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
      "My Wallet",
    );
  }
  int prevListCount = 0;
  int _current = 0;

  @override
  void initState() {
    if (widget.cardIndex != null) _current = widget.cardIndex!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content() {
      return Consumer<FirestoreData>(
        builder: (context, firestoreData, child) {
          targetAmount.clear();
          showGoal.clear();
          final List<Widget> imageSliders = firestoreData
            .walletsList.map((item) {
            showGoal.add(
              item["type"].toString().toLowerCase() == 'goal' ?
              true : false
            );
            targetAmount.add(
              item["targetAmount"] != null ?
                "${item["currencySign"]} ${NumberFormat
                .currency(customPattern: '#,###.##')
                .format(item["targetAmount"])}"
                : 0.00
            );
             return Container(
               child: Container(
                 width: 240,
                 child: CCardWallets(
                   txtTypeWallet: item["type"],
                   txtWallet: item["name"],
                   availableBalance: item["amount"],
                   cardSize: CardSize.large,
                   cardColor: item["color"],
                   currencyID: item["currencyID"],
                 )
               ),
             );
          }).toList();
          return Container(
            height: 300,
            child: Column(
              children: [
                Stack(
                    children: [
                      CarouselSlider(
                        items: imageSliders,
                        options: CarouselOptions(
                          initialPage: _current,
                          viewportFraction: 0.6,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            if(mounted)
                            setState(() {
                              _current = index;
                              overAllBalance = firestoreData
                                .overallBalance[index];
                            });
                          }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 180.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: firestoreData
                            .walletsList.map((item) {

                            int index = firestoreData
                              .walletsList.indexOf(item);

                            return _current == index ? Container(
                              width: 15.0,
                              height: 10.0,
                              margin: EdgeInsets.symmetric(
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
                              margin: EdgeInsets.symmetric(
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
                  child: Row(children: [
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(6, 6),
                            ),
                            BoxShadow(
                              color: Color(0xFFFFFFFF),
                              blurRadius: 10,
                              offset: const Offset(-6, -6),
                            ),
                          ],
                        ),
                        child: FloatingActionButton(
                          heroTag: null,
                          elevation: 0,
                          backgroundColor: ColorConstants.grey,
                          onPressed: () {
                            Navigator.push(context,
                              MyRoute(
                                builder: (context) => WalletSavePage(
                                  walletID: firestoreData.walletIDs[_current]
                                ),
                                routeSettings: RouteSettings(
                                  name: "/walletSave"
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
                    Expanded(child: Text("Edit Wallet",
                        style: TextStyle(
                            color: ColorConstants.grey6,
                            fontSize: 12
                        ))),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 30,
                        width: 30,
                        child: FloatingActionButton(
                            heroTag: null,
                            backgroundColor: ColorConstants.grey,
                            elevation: 0,
                            onPressed: () {
                              Navigator.push(context,
                                MyRoute(
                                  builder: (context) =>
                                    TransactionAddDetailsPage(
                                    firestoreData.walletIDs[_current]
                                  ),
                                  routeSettings: RouteSettings(
                                    name: "/transactionAddDetailsPage")
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(6, 6),
                            ),
                            BoxShadow(
                              color: Color(0xFFFFFFFF),
                              blurRadius: 10,
                              offset: const Offset(-6, -6),
                            ),
                          ],
                        )
                    ),
                    Expanded(child: Text("Add Transaction",
                      style: TextStyle(
                          color: ColorConstants.grey6,
                          fontSize: 12
                      ),
                    ))
                  ]),
                ),
                (showGoal[_current]==true)? Container(
                  margin: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    bottom: 30
                  ),
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                      Row(
                        children: [
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                targetAmount[_current],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.cyan
                                ),
                              ),
                              Text("to target amount",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ColorConstants.black1
                                )),
                            ],
                          )),
                          Container(
                              height: 40,
                              child: VerticalDivider(
                                  color: Colors.grey
                              )
                          ),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "1Y : 10M : 10D",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstants.cyan
                                  )
                              ),
                              Text("to target date",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorConstants.black1
                                  )),
                            ],
                          )
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: CProgressBar(max: 100, current: 30,
                          backgroundColor: ColorConstants.grey4,
                          progressBarColor: ColorConstants.cyan,
                        ),
                      ),
                    ]
                  ),
                ):SizedBox(),
                Container(
                  margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                  padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Row(
                      children: [
                        Expanded(
                          child: Text(
                              "Transactions",
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
                              MyRoute(
                                builder: (context) => TransactionsPage(),
                                routeSettings: RouteSettings(
                                  name: "/transactions"
                                ),
                              )
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [Text(
                              "View All",
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
                  child: CTransactionList(
                    key: Key(firestoreData.walletIDs[_current]),
                    walletID: (firestoreData.walletIDs.length > 0)?
                    firestoreData.walletIDs[_current]: "",
                    paddingItem: EdgeInsets.only(left: 30,right: 30),
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
          backgroundColor: Color(0xFF03BED6),
          appBar: headerNav(
              title: title(),
              action: actionButtons
          ),
          body: CBody(child: content(),hasScrollBody: true,)
      ),
    );
  }
}