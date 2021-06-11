import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/pages/profile/profile.dart';
import 'package:kwartracker/views/pages/reports/reports.dart';
import 'package:kwartracker/views/pages/settings/settings.dart';
import 'package:kwartracker/views/pages/signIn/signIn.dart';
import 'package:kwartracker/views/pages/transactions/transactions.dart';
import 'package:kwartracker/views/pages/wallets/wallets.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cDrawerListItem.dart';
import '../../widgets/headerNav.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//TODO: Enums
enum DrawerState { open, close, }

class _HomePageState extends State<HomePage> {
  bool _drawerWidget = false;

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
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
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
                                    "40,000",
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
                                      "5,000",
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
                    padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                    child: Text(
                      "Wallet",
                      style: TextStyle(
                          color: ColorConstants.black1,
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                    )
                )
              ]
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        drawer(DrawerState.close, context),
        Container(
          width: MediaQuery.of(context).size.width,
          //TODO: Scaffolding
          child: Scaffold(
            backgroundColor: Color(0xFF03BED6),
            appBar: headerNav(
                title: title(),
                action: actionButtons,
                leading: CWidgets(context).leading(),
                toolBarHeight: 90
            ),
            body: CBody(child: content()),
          ),
        ),
      ],
    );
  }
}

abstract class CustomWidgets {
  Widget drawerList();
  Widget leading();
  void navPush(page);
}

//TODO: OOP - Abstract
//TODO: OOP - Inheritance
//TODO: OOP - Polymorphism
class CWidgets extends CustomWidgets {
  CWidgets(this.context);
  final dynamic context;

  @override
  void navPush(page) {
    drawer(DrawerState.close, context);
    Navigator.push(context,
      MyRoute(
        builder: (context) => page
      )
    );
  }

  @override
  Widget drawerList() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0,58,0,0),
          child: Row(
            children: [
              IconButton(
                padding: new EdgeInsets.all(0.0),
                iconSize: 80,
                icon: Image.asset(
                    'images/users/profile_pic.png'
                ),
                onPressed: () {},
              ),
              Text(
                'Samantha Tagli',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),
        ),
        //TODO: GestureDetector
        GestureDetector(
            onTap: () {
              drawer(DrawerState.close, context);
            },
            child: Card(
                color: ColorConstants.grey5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: CDrawerListItem(
                    title: "Home",
                    leadingIconPath: 'images/icons/ic_home.png',
                    textStyle: TextStyle(
                        color: ColorConstants.cyan,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                    )
                )
            )
        ),
        GestureDetector(
          onTap: () {
            navPush(TransactionsPage());
          },
          //TODO: Custom Flutter Widgets
          child: CDrawerListItem(
            title: "Transactions",
            leadingIconPath: 'images/icons/ic_transaction.png',
          ),
        ),
        GestureDetector(
          onTap: () {
            navPush(WalletsPage());
          },
          child: CDrawerListItem(
            title: "Wallets",
            leadingIconPath: 'images/icons/ic_wallet.png',
          ),
        ),
        GestureDetector(
          onTap: () {
            navPush(ReportsPage());
          },
          child: CDrawerListItem(
            title: "Reports",
            leadingIconPath: 'images/icons/ic_report.png',
          ),
        ),
        GestureDetector(
          onTap: () {
            navPush(ProfilePage());
          },
          child: CDrawerListItem(
            title: "My Profile",
            leadingIconPath: 'images/icons/ic_profile.png',
          ),
        ),
        GestureDetector(
          onTap: () {
            navPush(SettingsPage());
          },
          child: CDrawerListItem(
            title: "Settings",
            leadingIconPath: 'images/icons/ic_settings.png',
          ),
        ),
        Expanded(
          child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,40),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(context, MyRoute(
                          builder: (context) => SignInPage()
                      ), (route) => false);
                    },
                    child: CDrawerListItem(
                      title: "Logout",
                      leadingIconPath: 'images/icons/ic_logout.png',
                    ),
                  )
              )
          ),
        ),
      ],
    );
  }

  @override
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
        drawer(DrawerState.close, context);
      },
      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
    );
  }
}

//TODO: OOP - Encapsulation
Widget drawer(DrawerState drawerState, dynamic context) {
  CWidgets cWidgets = CWidgets(context);
  //TODO: IF Conditionals
  double drawerWidth;
  drawerWidth = (DrawerState.open == drawerState) ?
  drawerWidth = 300 :
  drawerWidth = 0;

  return AnimatedContainer(
    width: drawerWidth,
    duration: Duration(seconds: 1),
    curve: Curves.fastOutSlowIn,
    child: Drawer(
      child: Container(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: cWidgets.drawerList()
      ),
    ),
  );
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
