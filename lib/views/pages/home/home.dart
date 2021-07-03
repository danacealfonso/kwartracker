// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:kwartracker/provider/firestore_data.dart';
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/util/globals.dart' as globals;
import 'package:kwartracker/util/my_route.dart';
import 'package:kwartracker/views/pages/profile/profile.dart';
import 'package:kwartracker/views/pages/signIn/sign_in.dart';
import 'package:kwartracker/views/pages/transactions/transaction_choose_wallet.dart';
import 'package:kwartracker/views/pages/transactions/transactions.dart';
import 'package:kwartracker/views/pages/wallets/wallets.dart';
import 'package:kwartracker/views/widgets/card_wallets.dart';
import 'package:kwartracker/views/widgets/custom_body.dart';
import 'package:kwartracker/views/widgets/custom_button.dart';
import 'package:kwartracker/views/widgets/custom_drawer.dart';
import 'package:kwartracker/views/widgets/custom_dropdown.dart';
import 'package:kwartracker/views/widgets/custom_progress_bar.dart';
import 'package:kwartracker/views/widgets/custom_transaction_list.dart';
import '../../widgets/header_nav.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  DrawerState drawerState = DrawerState.close;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String fDate = '';
  String fDateID = '';

  Future<void> getCurrentUser() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        globals.isLoggedIn = true;
      } else {
        Navigator.pushAndRemoveUntil(context, MyRoute<dynamic>(
          builder: (BuildContext context) => SignInPage(), routeSettings:
        const RouteSettings(name: '/signIn'),
        ), (Route<dynamic> route) => false);
      }

    } catch (e) {
      print(e);
    }
  }

  Widget title() {
    return Column(children: const <Widget>[
      Text(
        'Hello',
      ),
      Text(
        'Samantha',
      ),
    ]);
  }
  Widget button(String iconPath,VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      width: 36,
      height: 26,
      child: MaterialButton(
        padding: const EdgeInsets.all(0),
        minWidth: 0,
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFFE4EAEF), width: 1),
            borderRadius: BorderRadius.circular(8)),
        onPressed: onPressed,
        child: ImageIcon(AssetImage(iconPath),
            size: 8, color: ColorConstants.cyan),
        color: const Color(0xFFF2F4F6),
      ),
    );
  }
  Widget leading() {
    return IconButton(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
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

  List<Widget> actionButtons(BuildContext context) => <Widget>[
    TextButton(
        onPressed: () {
          Navigator.push(context,
              MyRoute<dynamic>(
                builder: (BuildContext context) => ProfilePage(), routeSettings:
              const RouteSettings(name: '/profile'),
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
            padding: const EdgeInsets
                .fromLTRB(
                30, 40, 30, 0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius
                    .only(
                    topLeft: Radius
                        .circular(
                        60.0),
                    topRight: Radius
                        .circular(
                        60.0)
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
                      children: <Widget>[
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
                CustomDropdown(
                    label: 'Select Date Range',
                    text: fDate,
                    onChanged: (dynamic value) {
                      setState(() {
                        fDate = value[1];
                        fDateID = value[0];
                      });
                    },
                    items: const <PopupMenuEntry<dynamic>>[
                      PopupMenuItem<dynamic>(
                          child: Text(
                              'This week'),
                          value: <String>[
                            'This week',
                            'This week'
                          ]),
                      PopupMenuItem<dynamic>(
                          child: Text(
                              'This month'),
                          value: <String>[
                            'This month',
                            'This month'
                          ])
                    ]
                ),
                Container(
                  width: double
                      .infinity,
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
  }

  Widget content() {
    return Consumer<FirestoreData>(
      builder: (BuildContext context,
          FirestoreData firestoreData,
          Widget? child) {
        final List<Widget> imageSliders = firestoreData
          .walletsList.map((Map<String, dynamic> item) {
          final int index = firestoreData.walletsList.indexOf(item);
          return GestureDetector(
            onTap: () {
              Navigator.push(context,
                MyRoute<dynamic>(
                  builder: (BuildContext context) => WalletsPage(cardIndex: index,),
                  routeSettings:  const RouteSettings(name: '/wallets')
                )
              );
            },
            child: Container(
              child: CardWallets(
                txtTypeWallet: item['type'],
                txtWallet: item['name'],
                availableBalance: item['amount'],
                cardSize: CardSize.small,
                cardColor: item['color'],
                currencyID: item['currencyID'],
              ),
            ),
          );
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
              padding: const EdgeInsets.fromLTRB(30, 30, 20, 20),
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
                        const Expanded(
                          child: Text(
                              'March 01 - March 30, 2020',
                              style: TextStyle(
                                  color: ColorConstants.black,
                                  fontSize: 12
                              )
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            button('images/icons/ic_date_cyan.png', () {
                              showModalBottomSheet(context: context,
                                builder: (BuildContext context) {
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
                            button('images/icons/ic_graph_cyan.png', () {}),
                          ],
                        ),
                      ]
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 8),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            Text('Total Balance'),
                            Text(
                              '₱ 40,000',
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
                            child: const VerticalDivider(
                                color: Colors.grey
                            )
                        ),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            Text('Total Expenses'),
                            Text(
                                '₱ 5,000',
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
                  const CustomProgressBar(max: 100, current: 90),
                ]
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
              child: Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                        'Wallet',
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
                          builder: (BuildContext context) => const WalletsPage(),
                          routeSettings:  const RouteSettings(name: '/wallets')
                        )
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const <Widget>[Text(
                          'View All',
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
                padding: const EdgeInsets.fromLTRB(25, 8, 25, 10),
                scrollDirection: Axis.horizontal,
                children: imageSliders,
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
                          routeSettings:  const RouteSettings(
                            name: '/transactions'
                          )
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
                        )
                      ],
                    ),
                  ),
                ]
              ),
            ),
            const Expanded(
              child: CustomTransactionList(
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
        children: <Widget>[
          AnimatedPositioned(
            top: 0,
            left: offsetLeftDrawer,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            child: Container(
              width: MediaQuery.of(context).size.width * .77,
              height: MediaQuery.of(context).size.height,
              child: CustomDrawer(drawerState: drawerState,
                drawerStateChange: (dynamic value){
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
                backgroundColor: const Color(0xFF03BED6),
                appBar: headerNav(
                  title: title(),
                  action: actionButtons(context),
                  leading: leading(),
                  toolBarHeight: 90
                ),
                body: CustomBody(child: content(),hasScrollBody: true,),
                floatingActionButton: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    Navigator.push(context,
                      MyRoute<dynamic>(
                        builder: (BuildContext context) => TransactionChooseWalletPage(),
                        routeSettings:
                      const RouteSettings(name: '/transactionAddWallet'),
                      )
                    );
                  },
                  child: const Icon(Icons.add, color: Colors.white, size: 29,),
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
