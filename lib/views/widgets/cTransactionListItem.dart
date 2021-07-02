import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/pages/transactions/transactionDetails.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class CTransactionListItem extends StatelessWidget {

  CTransactionListItem({
    required this.category,
    this.transactionType = 'income',
    required this.transactionDate,
    required this.transactionID,
    required this.walletName,
    required this.amount,
    this.currency = "php",
    this.categoryIcon
  });

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
    var newAmount = NumberFormat.currency(customPattern: '#,###.##')
        .format(amount);

    String currencyAbb =  "Php";
    if(currency!=null)
      if(currency!.toLowerCase() == "dollar")
        currencyAbb = "Usd";

    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
            color: Color(0xFFE4EAEF),
            border: Border.all(
              color: Color(0x00000029),
              width: 1,
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(14),
              topLeft: Radius.circular(14),
              bottomRight: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
          ),
            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Column(children: [
              Text(DateFormat.MMM().format(transactionDate),
                style: TextStyle(
                  fontSize: 8,
                  color: ColorConstants.black1,
                  fontWeight: FontWeight.w700
                ),
              ),
              Text(transactionDate.day.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConstants.cyan,
                  fontWeight: FontWeight.w700
                ),
              ),
            ],)
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        margin: EdgeInsets.only(right: 5),
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
                        style: TextStyle(
                            fontSize: 8 ,
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.cyan
                        )),
                    ],
                  ),
                  Row(children: [
                    Expanded(child: Text(walletName,
                      style: TextStyle(
                        fontSize: 12 ,
                        color: ColorConstants.black1
                      ))),
                  ],)
                ],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              (transactionType.toUpperCase()=='INCOME')?
              Text(
                "+ $currencyAbb ${newAmount.toString()}",
                style: TextStyle(
                    color: ColorConstants.cyan6,
                    fontSize: 12,
                    fontWeight: FontWeight.w500
                )
              ): Text(
                "- $currencyAbb ${newAmount.toString()}",
                style: TextStyle(
                  color: ColorConstants.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500
                )
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(6, 6),
                  ),
                  BoxShadow(
                    color: Color(0xFFFFFFFF),
                    blurRadius: 10,
                    offset: const Offset(-6, -6),
                  ),
                ],
              ),
            child: FloatingActionButton(
              heroTag: null,
              elevation: 0,
              backgroundColor: ColorConstants.grey,
              onPressed: () {
                Navigator.push(context,
                  MyRoute(
                    builder: (context) => TransactionDetailsPage(transactionID),
                    routeSettings: RouteSettings(name: "/transactionDetailsPage"),
                  )
                );
              },
              child: Image.asset(
              'images/icons/ic_next_grey.png',
              width: 5,
              height: 10,
              fit:BoxFit.fill
              )
            )
          ),
        ],
      ),
    );
  }
}
