import 'package:flutter/material.dart';

enum CardColor { green, green_dark, red}

class CCardWallets extends StatelessWidget {
  CCardWallets({
    required this.txtTypeWallet,
    required this.txtWallet,
    required this.availableBalance,
    required this.cardColor,
  });

  final String txtTypeWallet;
  final String txtWallet;
  final double availableBalance;
  final CardColor cardColor;

  String get cardBG {
    switch (cardColor) {
      case CardColor.green:
        return 'green';
      case CardColor.red:
        return 'red';
      default:
        return 'green_dark';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      width: 160,
      height: 104,
      child: Stack(
        children: <Widget>[
          Image.asset(
            'images/cards/$cardBG.png',
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 17, 15, 0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(txtTypeWallet,
                    style: TextStyle(
                      color: Color(0x80FFFFFF),
                      fontSize: 8,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(txtWallet,
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14
                      )
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("AVAILABLE BALANCE",
                    style: TextStyle(
                      color: Color(0x80FFFFFF),
                      fontSize: 8
                    )
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("₱ " + availableBalance.toString(),
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14
                      )
                    ),
                  ),
                )
              ],
            ),

          ),
        ],
      ),
    );
  }
}
