// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/util/my_route.dart';
import 'package:kwartracker/views/pages/transactions/transaction_details.dart';

class CustomTransactionListItem extends StatelessWidget {
  const CustomTransactionListItem(
      {required this.category,
      this.transactionType = 'income',
      required this.transactionDate,
      required this.transactionID,
      required this.walletName,
      required this.amount,
      this.currency = 'php',
      this.categoryIcon});

  final String category;
  final String transactionType;
  final DateTime transactionDate;
  final String transactionID;
  final String walletName;
  final String? currency;
  final double amount;
  final Map<String, dynamic>? categoryIcon;

  @override
  Widget build(BuildContext context) {
    final String newAmount =
        NumberFormat.currency(customPattern: '#,###.##').format(amount);

    String currencyAbb = 'Php';
    if (currency != null) {
      if (currency!.toLowerCase() == 'dollar') {
        currencyAbb = 'Usd';
      }
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE4EAEF),
                border: Border.all(
                  color: const Color(0x00000029),
                  width: 1,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(14),
                  topLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Column(
                children: <Widget>[
                  Text(
                    DateFormat.MMM().format(transactionDate),
                    style: const TextStyle(
                        fontSize: 8,
                        color: ColorConstants.black1,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    transactionDate.day.toString(),
                    style: const TextStyle(
                        fontSize: 16,
                        color: ColorConstants.cyan,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              )),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(3),
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: ColorConstants.cyan,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Icon(
                          deserializeIcon(categoryIcon!),
                          color: Colors.white,
                          size: 8,
                        ),
                      ),
                      Text(category,
                          style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.cyan)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(walletName,
                              style: const TextStyle(
                                  fontSize: 12, color: ColorConstants.black1))),
                    ],
                  )
                ],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (transactionType.toUpperCase() == 'INCOME')
                Text('+ $currencyAbb ${newAmount.toString()}',
                    style: const TextStyle(
                        color: ColorConstants.cyan6,
                        fontSize: 12,
                        fontWeight: FontWeight.w500))
              else
                Text('- $currencyAbb ${newAmount.toString()}',
                    style: const TextStyle(
                        color: ColorConstants.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500))
            ],
          ),
          Container(
              margin: const EdgeInsets.only(left: 20),
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(6, 6),
                  ),
                  BoxShadow(
                    color: Color(0xFFFFFFFF),
                    blurRadius: 10,
                    offset: Offset(-6, -6),
                  ),
                ],
              ),
              child: FloatingActionButton(
                  heroTag: null,
                  elevation: 0,
                  backgroundColor: ColorConstants.grey,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MyRoute<dynamic>(
                          builder: (BuildContext context) =>
                              TransactionDetailsPage(transactionID),
                          routeSettings: const RouteSettings(
                              name: '/transactionDetailsPage'),
                        ));
                  },
                  child: Image.asset('images/icons/ic_next_grey.png',
                      width: 5, height: 10, fit: BoxFit.fill))),
        ],
      ),
    );
  }
}
