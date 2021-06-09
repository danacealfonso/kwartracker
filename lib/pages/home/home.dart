import 'package:flutter/material.dart';
import 'package:kwartracker/pages/profile/profile.dart';
import 'package:kwartracker/pages/reports/reports.dart';
import 'package:kwartracker/pages/settings/settings.dart';
import 'package:kwartracker/pages/signIn/signIn.dart';
import 'package:kwartracker/pages/transactions/transactions.dart';
import 'package:kwartracker/pages/wallets/wallets.dart';
import 'package:kwartracker/util/myRoute.dart';
import '../../appBar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _drawerWidget = false;
  late AnimationController _controller;
  late Animation<Offset> _animation;
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
    final textTheme = theme.textTheme;
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
              Navigator.pushAndRemoveUntil(context, MyRoute(
                builder: (context) => SignInPage()
              ), (route) => false)
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
      return SlideTransition(
          position: _animation,
          child: Container(
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
      ));
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
            body: content(),
          ),
        ),
      ],
    );
  }
}