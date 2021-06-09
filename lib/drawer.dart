import 'package:flutter/material.dart';
import 'package:kwartracker/pages/profile/profile.dart';
import 'package:kwartracker/pages/reports/reports.dart';
import 'package:kwartracker/pages/settings/settings.dart';
import 'package:kwartracker/pages/signIn/signIn.dart';
import 'package:kwartracker/pages/transactions/transactions.dart';
import 'package:kwartracker/pages/wallets/wallets.dart';
import 'package:kwartracker/util/MyRoute.dart';

class DrawerApp extends StatefulWidget {

  @override
  _DrawerAppState createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  bool _drawerWidget = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    void navPush(page) {
      Navigator.push(context,
          MyRoute(
              builder: (context) => page
          )
      );
    }

    Widget leading() {
      return Builder(
        builder: (BuildContext context) {
          return IconButton(
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
    Widget drawerList() {
      return ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0,100,20,0),
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
                  style: textTheme.headline5,
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Home'),
            onTap: () => {
              setState(() {
                _drawerWidget = false;
              })
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Transactions'),
            onTap: () => {
              navPush(TransactionsPage())
            },
          ),
          ListTile(
            leading: Icon(Icons.label),
            title: Text('Wallets'),
            onTap: () => {
              navPush(WalletsPage())
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Reports'),
            onTap: () => {
              navPush(ReportsPage())
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('My Profile'),
            onTap: () => {
              navPush(ProfilePage())
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Settings'),
            onTap: () => {
              navPush(SettingsPage())
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '',
              style: textTheme.headline6,
            ),
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Logout'),
            onTap: () => {
              navPush(SignInPage())
            },
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
              width: MediaQuery.of(context).size.width,
              color: theme.primaryColor,
              child: drawerList(),
            ),
          )
      );
    }

    return drawer();
  }
}

