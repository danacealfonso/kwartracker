import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/widgets/cDrawerListItem.dart';
import 'package:kwartracker/views/pages/profile/profile.dart';
import 'package:kwartracker/views/pages/reports/reports.dart';
import 'package:kwartracker/views/pages/settings/settings.dart';
import 'package:kwartracker/views/pages/signIn/signIn.dart';
import 'package:kwartracker/views/pages/transactions/transactions.dart';
import 'package:kwartracker/views/pages/wallets/wallets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kwartracker/util/globals.dart' as globals;
import 'cDrawerListItem.dart';

class CDrawer extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final DrawerState drawerState;
  CDrawer({Key? key, required this.drawerState}) : super(key: key);

  DrawerState getDrawerState () {
    return drawerState;
  }

  Widget drawerList(BuildContext context) {
    CWidgets cWidgets = CWidgets(context);
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
              CDrawer(drawerState: DrawerState.close);
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
            cWidgets.navPush(TransactionsPage(), "/transactions");
          },
          //TODO: Custom Flutter Widgets
          child: CDrawerListItem(
            title: "Transactions",
            leadingIconPath: 'images/icons/ic_transaction.png',
          ),
        ),
        GestureDetector(
          onTap: () {
            cWidgets.navPush(WalletsPage(), "/wallets");
          },
          child: CDrawerListItem(
            title: "Wallets",
            leadingIconPath: 'images/icons/ic_wallet.png',
          ),
        ),
        GestureDetector(
          onTap: () {
            cWidgets.navPush(ReportsPage(), '/reports');
          },
          child: CDrawerListItem(
            title: "Reports",
            leadingIconPath: 'images/icons/ic_report.png',
          ),
        ),
        GestureDetector(
          onTap: () {
            cWidgets.navPush(ProfilePage(), '/profile');
          },
          child: CDrawerListItem(
            title: "My Profile",
            leadingIconPath: 'images/icons/ic_profile.png',
          ),
        ),
        GestureDetector(
          onTap: () {
            cWidgets.navPush(SettingsPage(),'/settings');
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
                      _auth.signOut();
                      globals.isLoggedIn = false;
                      Navigator.pushAndRemoveUntil(context, MyRoute(
                        builder: (context) => SignInPage(), routeSettings:
                        RouteSettings(name: "/signIn"),
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
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: (DrawerState.open == drawerState) ? 300: 0,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      child: Drawer(
        child: Container(
            color: ColorConstants.cyan,
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: drawerList(context)
        ),
      ),
    );


  }
}

abstract class CustomWidgets {
  void navPush(page, name);
}
//TODO: Enums
enum DrawerState { open, close, }
//TODO: OOP - Abstract
//TODO: OOP - Inheritance
//TODO: OOP - Polymorphism
class CWidgets extends CustomWidgets {
  CWidgets(this.context);
  final BuildContext context;

  @override
  void navPush(page, name) {
    Navigator.push(context,
      MyRoute(
        builder: (context) => page,
        routeSettings:  RouteSettings(name: name)
      )
    );
  }
}
