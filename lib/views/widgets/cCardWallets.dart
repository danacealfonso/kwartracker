import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';

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

  Color get cardShadow {
    switch (cardColor) {
      case CardColor.green:
        return ColorConstants.cyan1;
      case CardColor.red:
        return ColorConstants.red1;
      default:
        return ColorConstants.green;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      width: 160,
      height: 150,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 12,
            left: 12,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {},
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    width: 127.0,
                    height: 97.0,
                    child: Container(
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: cardShadow,
                              blurRadius: 13,
                              offset: const Offset(4, 4),
                            ),
                          ]
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Image.asset(
            'images/cards/$cardBG.png',
            alignment: Alignment.topCenter,
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
