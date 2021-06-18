import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/pages/transactions/transactionAddWallet.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import '../../widgets/headerNav.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    var actionButtons = [
      Builder(
        builder: (BuildContext context) {
          return Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.all(20),
            child: FloatingActionButton(
              backgroundColor: ColorConstants.grey,
              onPressed: () {
                Navigator.push(context,
                  MyRoute(
                    builder: (context) => TransactionAddWalletPage()
                  )
                );
              },
              child: Image.asset(
                  'images/icons/ic_add.png',
                  width: 10,
                  height: 10,
                  fit:BoxFit.fill
              )
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(6, 6),
                ),
                BoxShadow(
                  color: Color(0x82FFFFFF),
                  blurRadius: 8,
                  offset: const Offset(-4, -2),
                ),
              ],
            )
          );
        },
      )
    ];

    Widget title() {
      return Text(
          "Transactions",
        );
    }

    Widget content() {
      return Container(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: Text("Transactions")
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
          body: CBody(child: content())
      ),
    );
  }
}