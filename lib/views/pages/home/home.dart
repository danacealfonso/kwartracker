import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kwartracker/model/firestoreData.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/pages/profile/profile.dart';
import 'package:kwartracker/views/pages/transactions/transactionChooseWallet.dart';
import 'package:kwartracker/views/pages/transactions/transactions.dart';
import 'package:kwartracker/views/pages/wallets/wallets.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cButton.dart';
import 'package:kwartracker/views/widgets/cCardWallets.dart';
import 'package:kwartracker/views/widgets/cDrawer.dart';
import 'package:kwartracker/views/widgets/cDropdownTextField.dart';
import 'package:kwartracker/views/widgets/cProgressBar.dart';
import 'package:kwartracker/views/widgets/cTransactionList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kwartracker/util/globals.dart' as globals;
import 'package:provider/provider.dart';
import '../../widgets/headerNav.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  DrawerState drawerState = DrawerState.close;
  final _auth = FirebaseAuth.instance;
  String fDate = "";
  String fDateID = "";

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null)
        globals.isLoggedIn = true;

    } catch (e) {
      print(e);
    }
  }

  Widget title() {
    return Column(children: [
      Text(
        "Hello",
      ),
      Text(
        "Samantha",
      ),
    ]);
  }
  Widget button(String iconPath,VoidCallback onPressed) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      width: 36,
      height: 26,
      child: MaterialButton(
        padding: EdgeInsets.all(0),
        minWidth: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xFFE4EAEF), width: 1),
            borderRadius: new BorderRadius.circular(8)),
        onPressed: onPressed,
        child: ImageIcon(AssetImage(iconPath),
            size: 8, color: ColorConstants.cyan),
        color: Color(0xFFF2F4F6),
      ),
    );
  }
  Widget leading() {
    return IconButton(
      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      icon: Image.asset(
          'images/icons/ic_menu.ico',
          width: 28,
          height: 20,
          fit:BoxFit.fill
      ),
      onPressed: () {
        setState(() {
          drawerState = (drawerState == DrawerState.open) ?
          DrawerState.close : drawerState = DrawerState.open;
        });
      },
      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
    );
  }

  List<Widget> actionButtons(BuildContext context) => [
    TextButton(
        onPressed: () {
          Navigator.push(context,
              MyRoute(
                builder: (context) => ProfilePage(), routeSettings:
              RouteSettings(name: "/profile"),
              )
          );
        },
        child: Image.asset(
            'images/users/profile_pic.png',
            width: 70,
            height: 85,
            fit:BoxFit.fill
        )
    )
  ];

  Widget pageDefault(BuildContext context,
  StateSetter setState) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 20, sigmaY: 20),
      child: Container(
        height: 350.0,
        child: Container(
            padding: EdgeInsets
                .fromLTRB(
                30, 40, 30, 0),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius
                    .only(
                    topLeft: const Radius
                        .circular(
                        60.0),
                    topRight: const Radius
                        .circular(
                        60.0)
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
                              color: ColorConstants
                                  .black,
                              fontSize: 18,
                              fontWeight: FontWeight
                                  .bold
                          )
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .end,
                      children: [
                        Container(
                            height: 30,
                            width: 30,
                            child: FloatingActionButton(
                                backgroundColor: ColorConstants
                                    .grey,
                                onPressed: () {
                                  Navigator
                                      .pop(
                                      context);
                                },
                                child: Image
                                    .asset(
                                    'images/icons/ic_close.png',
                                    width: 10,
                                    height: 10,
                                    fit: BoxFit
                                        .fill
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
                    onChanged: (
                        value) {
                      setState(() {
                        fDate =
                        value[1];
                        fDateID =
                        value[0];
                      });
                    },
                    items: <
                        PopupMenuEntry>[
                      PopupMenuItem<
                          List>(
                          child: Text(
                              'This week'),
                          value: [
                            'This week',
                            'This week'
                          ]),
                      PopupMenuItem<
                          List>(
                          child: Text(
                              'This month'),
                          value: [
                            'This month',
                            'This month'
                          ])
                    ]
                ),
                Container(
                  width: double
                      .infinity,
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
  }

  Widget content() {
    return Consumer<FirestoreData>(
      builder: (context, firestoreData, child) {
        final List<Widget> imageSliders = firestoreData
          .walletsList.map((item) {
          int index = firestoreData.walletsList.indexOf(item);
          return GestureDetector(
            onTap: () {
              Navigator.push(context,
                MyRoute(
                  builder: (context) => WalletsPage(cardIndex: index,),
                  routeSettings:  RouteSettings(name: '/wallets')
                )
              );
            },
            child: Container(
              child: CCardWallets(
                txtTypeWallet: item["type"],
                txtWallet: item["name"],
                availableBalance: item["amount"],
                cardSize: CardSize.small,
                cardColor: item["color"],
                currencyID: item["currencyID"],
              ),
            ),
          );
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
              padding: EdgeInsets.fromLTRB(30, 30, 20, 20),
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
                        Expanded(
                          child: Text(
                              "March 01 - March 30, 2020",
                              style: TextStyle(
                                  color: ColorConstants.black,
                                  fontSize: 12
                              )
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            button("images/icons/ic_date_cyan.png", () {
                              showModalBottomSheet(context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return pageDefault(context,
                                            setState);
                                      });
                                },
                                barrierColor: Colors.white.withOpacity(0),
                              );
                            }),
                            button(
                                "images/icons/ic_graph_cyan.png", () {}),
                          ],
                        ),
                      ]
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 8),
                    child: Row(
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total Balance"),
                            Text(
                              "₱ 40,000",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.cyan6
                              ),
                            ),
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
                            Text("Total Expenses"),
                            Text(
                                "₱ 5,000",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.red
                                )
                            ),
                          ],
                        )
                        ),
                      ],
                    ),
                  ),
                  CProgressBar(max: 100, current: 90),
                ]
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
              padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                        "Wallet",
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
                          builder: (context) => WalletsPage(),
                          routeSettings:  RouteSettings(name: '/wallets')
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
                      )
                      ],
                    ),
                  ),
                ]
              ),
            ),
            Container(
              height: 140,
              child: ListView(
                padding: EdgeInsets.fromLTRB(25, 8, 25, 10),
                scrollDirection: Axis.horizontal,
                children: imageSliders,
              ),
            ),
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
                          routeSettings:  RouteSettings(
                            name: '/transactions'
                          )
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
                      )
                      ],
                    ),
                  ),
                ]
              ),
            ),
            Expanded(
              child: CTransactionList(
                buttonToTop: false,
                paddingItem: EdgeInsets.only(left: 30, right: 30),
              ),
            ),
          ]
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    double offsetLeftDrawer = -MediaQuery.of(context).size.width * .77;
    double offsetLeftContent = 0;
    if(drawerState == DrawerState.open) {
      offsetLeftDrawer = 0;
      offsetLeftContent = MediaQuery.of(context).size.width * .77;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          AnimatedPositioned(
            top: 0,
            left: offsetLeftDrawer,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            child: Container(
              width: MediaQuery.of(context).size.width * .77,
              height: MediaQuery.of(context).size.height,
              child: CDrawer(drawerState: drawerState,
                drawerStateChange: (value){
                  setState(() {
                    drawerState = value;
                  });
                },
              ),
            ),
          ),
          AnimatedPositioned(
            top: 0,
            left: offsetLeftContent,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Scaffold(
                backgroundColor: Color(0xFF03BED6),
                appBar: headerNav(
                  title: title(),
                  action: actionButtons(context),
                  leading: leading(),
                  toolBarHeight: 90
                ),
                body: CBody(child: content(),hasScrollBody: true,),
                floatingActionButton: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    Navigator.push(context,
                      MyRoute(
                        builder: (context) => TransactionChooseWalletPage(),
                        routeSettings:
                      RouteSettings(name: "/transactionAddWallet"),
                      )
                    );
                  },
                  child: Icon(Icons.add, color: Colors.white, size: 29,),
                  backgroundColor: ColorConstants.cyan,
                  tooltip: 'Capture Picture',
                  elevation: 5,
                  splashColor: Colors.grey,
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation
                  .centerFloat,
              ),
            ),
          ),
        ],
      ),
    );

  }
}