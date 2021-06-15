import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';

class CTransactionListItem extends StatelessWidget {

  CTransactionListItem({
    required this.month,
    required this.day,
    required this.walletType,
    required this.walletName,
    required this.amount
  });

  final String month;
  final int day;
  final String walletType;
  final String walletName;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
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
                  color: ColorConstants.black1
                ),
              ),
              Text(day.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConstants.cyan
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
                  Text(walletType,
                    style: TextStyle(
                        fontSize: 8 ,
                        color: ColorConstants.cyan
                    )),
                  Row(children: [
                    Expanded(child: Text(walletName,
                      style: TextStyle(
                        fontSize: 12 ,
                        color: ColorConstants.black1
                      ))),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                        amount.toString(),
                        style: TextStyle(
                          color: ColorConstants.cyan6,
                          fontSize: 12,
                          fontWeight: FontWeight.w500
                        )
                      )],
                    )
                  ],)
                ],
              ),
            ),
          ),
          Container(
            height: 20,
            width: 20,
            child: FloatingActionButton(
            backgroundColor: ColorConstants.grey,
            onPressed: () {},
            child: Image.asset(
              'images/icons/ic_next_grey.png',
              width: 5,
              height: 10,
              fit:BoxFit.fill
            )
          )),
        ],
      ),
    );
  }
}
