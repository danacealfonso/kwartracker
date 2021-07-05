// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/util/globals.dart' as globals;
import 'package:kwartracker/util/my_route.dart';
import 'package:kwartracker/views/pages/profile/profile.dart';
import 'package:kwartracker/views/pages/reports/reports.dart';
import 'package:kwartracker/views/pages/settings/settings.dart';
import 'package:kwartracker/views/pages/signIn/sign_in.dart';
import 'package:kwartracker/views/pages/transactions/transactions.dart';
import 'package:kwartracker/views/pages/wallets/wallets.dart';
import 'package:kwartracker/views/widgets/drawer_list_item.dart';
import 'drawer_list_item.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key, required this.drawerState, this.drawerStateChange})
      : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DrawerState drawerState;
  final ValueChanged? drawerStateChange;

  Widget drawerList(BuildContext context) {
    final CWidgets cWidgets = CWidgets(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 58, 0, 0),
          child: Row(
            children: <Widget>[
              IconButton(
                padding: const EdgeInsets.all(0.0),
                iconSize: 80,
                icon: Image.asset('images/users/profile_pic.png'),
                onPressed: () {},
              ),
              const Text(
                'Samantha Tagli',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        GestureDetector(
            onTap: () {
              drawerStateChange!(DrawerState.close);
            },
            child: Card(
                color: ColorConstants.grey5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: const DrawerListItem(
                    title: 'Home',
                    leadingIconPath: 'images/icons/ic_home.png',
                    textStyle: TextStyle(
                        color: ColorConstants.cyan,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)))),
        GestureDetector(
          onTap: () {
            drawerStateChange!(DrawerState.close);
            cWidgets.navPush(TransactionsPage(), '/transactions');
          },
          child: const DrawerListItem(
            title: 'Transactions',
            leadingIconPath: 'images/icons/ic_transaction.png',
          ),
        ),
        GestureDetector(
          onTap: () {
            drawerStateChange!(DrawerState.close);
            cWidgets.navPush(const WalletsPage(), '/wallets');
          },
          child: const DrawerListItem(
            title: 'Wallets',
            leadingIconPath: 'images/icons/ic_wallet.png',
          ),
        ),
        GestureDetector(
          onTap: () {
            drawerStateChange!(DrawerState.close);
            cWidgets.navPush(ReportsPage(), '/reports');
          },
          child: const DrawerListItem(
            title: 'Reports',
            leadingIconPath: 'images/icons/ic_report.png',
          ),
        ),
        GestureDetector(
          onTap: () {
            drawerStateChange!(DrawerState.close);
            cWidgets.navPush(ProfilePage(), '/profile');
          },
          child: const DrawerListItem(
            title: 'My Profile',
            leadingIconPath: 'images/icons/ic_profile.png',
          ),
        ),
        GestureDetector(
          onTap: () {
            drawerStateChange!(DrawerState.close);
            cWidgets.navPush(SettingsPage(), '/settings');
          },
          child: const DrawerListItem(
            title: 'Settings',
            leadingIconPath: 'images/icons/ic_settings.png',
          ),
        ),
        Expanded(
          child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: GestureDetector(
                    onTap: () {
                      _auth.signOut();
                      globals.isLoggedIn = false;
                      Navigator.pushAndRemoveUntil(
                          context,
                          MyRoute<dynamic>(
                            builder: (BuildContext context) => SignInPage(),
                            routeSettings: const RouteSettings(name: '/signIn'),
                          ),
                          (Route<dynamic> route) => false);
                    },
                    child: const DrawerListItem(
                      title: 'Logout',
                      leadingIconPath: 'images/icons/ic_logout.png',
                    ),
                  ))),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: (DrawerState.open == drawerState) ? 300 : 0,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      child: Drawer(
        child: Container(
            color: ColorConstants.cyan,
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: drawerList(context)),
      ),
    );
  }
}

abstract class CustomWidgets {
  void navPush(dynamic page, String name);
}

enum DrawerState {
  open,
  close,
}

class CWidgets extends CustomWidgets {
  CWidgets(this.context);
  final BuildContext context;

  @override
  void navPush(dynamic page, String name) {
    Navigator.push(
        context,
        MyRoute<dynamic>(
            builder: (BuildContext context) => page,
            routeSettings: RouteSettings(name: name)));
  }
}
