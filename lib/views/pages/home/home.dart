import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cCardWallets.dart';
import 'package:kwartracker/views/widgets/cDrawer.dart';
import 'package:kwartracker/views/widgets/cTransactionListItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kwartracker/util/globals.dart' as globals;
import '../../widgets/headerNav.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DrawerState drawerState = DrawerState.close;
  final _auth = FirebaseAuth.instance;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null)
        globals.isLoggedIn = true;

    } catch (e) {
      print(e);
    }
  }

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
          child: Column(
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
                                button("images/icons/ic_date_cyan.png", (){}),
                                button("images/icons/ic_graph_cyan.png", (){}),
                              ],
                            ),
                          ]
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0,10,0,8),
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
                        ProgressBar(max: 100, current: 90),
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
                      Row(
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
                    ]
                  ),
                ),
                Container(
                  height: 130,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      CCardWallets(
                        txtTypeWallet: "Savings",
                        txtWallet: "BPI Savings",
                        availableBalance: 10000.00,
                        cardColor: CardColor.cyan,
                      ),
                      CCardWallets(
                        txtTypeWallet: "Savings",
                        txtWallet: "BPI Savings",
                        availableBalance: 10000.00,
                        cardColor: CardColor.red,
                      ),
                      CCardWallets(
                        txtTypeWallet: "Savings",
                        txtWallet: "BPI Savings",
                        availableBalance: 10000.00,
                        cardColor: CardColor.green,
                      ),
                      CCardWallets(
                        txtTypeWallet: "Savings",
                        txtWallet: "BPI Savings",
                        availableBalance: 10000.00,
                        cardColor: CardColor.cyan,
                      ),
                      CCardWallets(
                        txtTypeWallet: "Savings",
                        txtWallet: "BPI Savings",
                        availableBalance: 10000.00,
                        cardColor: CardColor.red,
                      )
                    ],
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
                        Row(
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
                      ]
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(25, 0, 25, 90),
                    children: <Widget>[
                      for(int i=0; i<15; i++)
                        CTransactionListItem(
                          month: "Mar",
                          day: 15,
                          walletType: "SALARY",
                          walletName: "March 15 Payroll",
                          amount: 10000.00,
                        ),
                    ],
                  ),
                ),
              ]
          ),
        )
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
              child: CDrawer(drawerState: drawerState),
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
                    action: actionButtons,
                    leading: leading(),
                    toolBarHeight: 90
                ),
                body: CBody(child: content()),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Icons.add, color: Colors.white, size: 29,),
                  backgroundColor: ColorConstants.cyan,
                  tooltip: 'Capture Picture',
                  elevation: 5,
                  splashColor: Colors.grey,
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              ),
            ),
          ),
        ],
      ),
    );

  }
}

//TODO: Refactor Flutter Widgets
class ProgressBar extends StatelessWidget {
  ProgressBar({
    required this.max,
    required this.current
  });
  final double max;
  final double current;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, boxConstraints) {
        var x = boxConstraints.maxWidth;
        var percent = (current / max) * x;
        return Stack(
          children: [
            Container(
              width: x,
              height: 10,
              decoration: BoxDecoration(
                color: ColorConstants.red,
                borderRadius: BorderRadius.circular(35),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: percent,
              height: 10,
              decoration: BoxDecoration(
                color: ColorConstants.cyan6,
                borderRadius: BorderRadius.circular(35),
              ),
            ),
          ],
        );
      },
    );
  }
}
