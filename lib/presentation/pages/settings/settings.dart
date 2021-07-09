// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/util/my_route.dart';
import 'package:kwartracker/presentation/pages/transactions/transaction_choose_wallet.dart';
import 'package:kwartracker/presentation/widgets/custom_body.dart';
import '../../widgets/header_nav.dart';
import 'category/categories.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> actionButtons = <Widget>[];

    Widget title() {
      return const Text('Settings');
    }

    Widget content() {
      return Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            MaterialButton(
              padding: const EdgeInsets.only(left: 20, right: 20),
              height: 55,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () {
                Navigator.push(
                    context,
                    MyRoute<dynamic>(
                      builder: (BuildContext context) =>
                          TransactionChooseWalletPage(),
                      routeSettings:
                          const RouteSettings(name: '/transactionAddWallet'),
                    ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Login and Security',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 1,
                    child: Image.asset('images/icons/ic_arrow_up.png',
                        width: 15, height: 10, fit: BoxFit.fill),
                  )
                ],
              ),
              color: ColorConstants.cyan,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: MaterialButton(
                padding: const EdgeInsets.only(left: 20, right: 20),
                height: 55,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MyRoute<dynamic>(
                        builder: (BuildContext context) => CategoriesPage(),
                        routeSettings:
                            const RouteSettings(name: '/transactionAddWallet'),
                      ));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 1,
                      child: Image.asset('images/icons/ic_arrow_up.png',
                          width: 15, height: 10, fit: BoxFit.fill),
                    )
                  ],
                ),
                color: ColorConstants.cyan,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
          backgroundColor: const Color(0xFF03BED6),
          appBar: headerNav(title: title(), action: actionButtons),
          body: CustomBody(
              child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F3F6),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(child: content()),
                  )))),
    );
  }
}
