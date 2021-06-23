import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';

class CTransactionListItem extends StatelessWidget {

  CTransactionListItem({
    required this.month,
    required this.day,
    required this.walletType,
    required this.transactionType,
    required this.walletName,
    required this.amount,
    required this.currency,
  });

  final String month;
  final int day;
  final String walletType;
  final String transactionType;
  final String walletName;
  final String currency;
  final double amount;

  @override
  Widget build(BuildContext context) {

    String currencyAbb =  "Php";
    if(currency!=null)
      if(currency.toLowerCase() == "dollar")
        currencyAbb = "Usd";

    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      width: 40,
      height: 40,
      child: Row(
        children: <Widget>[
          Container(
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
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(6, 6),
              ),
              BoxShadow(
                color: Color(0xA8FFFFFF),
                blurRadius: 10,
                offset: const Offset(-6, -6),
              ),
            ],
          ),
            padding: EdgeInsets.fromLTRB(11, 8, 11, 0),
            child: Column(children: [
              Text(month,
                style: TextStyle(
                  fontSize: 8,
                  color: ColorConstants.black1,
                  fontWeight: FontWeight.w700
                ),
              ),
              Text(day.toString(),
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
              padding: EdgeInsets.fromLTRB(10, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      (transactionType.toUpperCase()!='INCOME')?
                      Container(
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: ColorConstants.cyan,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Icon(
                            Icons.receipt_outlined,
                          color: Colors.white,
                          size: 8,
                        ),
                      ) : Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Image.asset(
                            'images/icons/ic_savings.png',
                            width: 12,
                            height: 12,
                            fit:BoxFit.fill
                        ),
                      ),
                      Text(walletType,
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
                "+ $currencyAbb ${amount.toString()}",
                style: TextStyle(
                    color: ColorConstants.cyan6,
                    fontSize: 12,
                    fontWeight: FontWeight.w500
                )
              ): Text(
                "- $currencyAbb ${amount.toString()}",
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
                    blurRadius: 8,
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
              onPressed: () {},
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
