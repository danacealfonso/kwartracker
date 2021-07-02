import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/pages/transactions/transactionChooseWallet.dart';
import 'package:kwartracker/views/widgets/cBody.dart';

import '../../widgets/headerNav.dart';
import 'category/categories.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> actionButtons = [];

    Widget title() {
      return Text(
          "Settings",
        );
    }
    Widget content() {
      return Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            MaterialButton(
              padding: EdgeInsets.only(left: 20,right: 20),
              height: 55,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15)),
              onPressed: (){
                Navigator.push(context,
                  MyRoute(
                    builder: (context) => TransactionChooseWalletPage(),
                    routeSettings:
                    RouteSettings(name: "/transactionAddWallet"),
                  )
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Login and Security",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),RotatedBox(
                    quarterTurns: 1,
                    child: Image.asset(
                        'images/icons/ic_arrow_up.png',
                        width: 15,
                        height: 10,
                        fit:BoxFit.fill
                    ),
                  )
                ],
              ),
              color: ColorConstants.cyan,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: MaterialButton(
                padding: EdgeInsets.only(left: 20,right: 20),
                height: 55,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15)),
                onPressed: (){
                  Navigator.push(context,
                    MyRoute(
                      builder: (context) => CategoriesPage(),
                      routeSettings:
                      RouteSettings(name: "/transactionAddWallet"),
                    )
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),RotatedBox(
                      quarterTurns: 1,
                      child: Image.asset(
                          'images/icons/ic_arrow_up.png',
                          width: 15,
                          height: 10,
                          fit:BoxFit.fill
                      ),
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
          backgroundColor: Color(0xFF03BED6),
          appBar: headerNav(
              title: title(),
              action: actionButtons
          ),
          body: CBody(child: Container(
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
                    child:content()
                ),
              )
          ))
      ),
    );
  }
}