import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/pages/profile/profile.dart';
import 'package:kwartracker/views/pages/reports/reports.dart';
import 'package:kwartracker/views/pages/settings/settings.dart';
import 'package:kwartracker/views/pages/signIn/signIn.dart';
import 'package:kwartracker/views/pages/transactions/transactions.dart';
import 'package:kwartracker/views/pages/wallets/wallets.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/widgets/cDrawerListItem.dart';
import '../../widgets/appBar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _drawerWidget = false;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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

    void navPush(page) {
      setState(() {
        _drawerWidget = false;
      });
      Navigator.push(context,
          MyRoute(
              builder: (context) => page
          )
      );
    }
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
          GestureDetector(
            onTap: () {
              setState(() {
                _drawerWidget = false;
              });
            },
            child: Card(
              color: ColorConstants.gray5,
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
    Widget drawer() {
      double drawerWidth = 0;
      if (_drawerWidget == true) drawerWidth = 300;

      return AnimatedContainer(
        width: drawerWidth,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        child: Drawer(
          child: Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            width: MediaQuery.of(context).size.width,
            color: theme.primaryColor,
            child: drawerList()
            ),
          ),
        );
    }
    Widget leading() {
      return Builder(
        builder: (BuildContext context) {
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
                if (_drawerWidget == true) _drawerWidget = false;
                else _drawerWidget = true;
              });
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
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
            child: Center(
                child: Text("Home")
            ),
          )
      );
    }

    return Row(
      children: [
        drawer(),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Scaffold(
            backgroundColor: Color(0xFF03BED6),
            appBar: headerNav(
                title: title(),
                action: actionButtons,
                leading: leading(),
                toolBarHeight: 90
            ),
            body: SlideTransition(
                position: _animation,
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 30, 20, 30),
                  decoration: BoxDecoration(
                    color: ColorConstants.gray,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  child: content(),
                )
            ),
          ),
        ),
      ],
    );
  }
}