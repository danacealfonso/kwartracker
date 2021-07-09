// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import 'package:kwartracker/util/color_constants.dart';

enum CardColor { green, cyan, red }
enum CardSize { large, small }

class CardWallets extends StatelessWidget {
  const CardWallets(
      {this.txtTypeWallet = '',
      this.txtWallet = '',
      this.availableBalance = 0.00,
      this.cardColor = CardColor.green,
      this.currencyID = 'php',
      this.cardSize = CardSize.small});

  final String txtTypeWallet;
  final String txtWallet;
  final String currencyID;
  final double availableBalance;
  final CardColor cardColor;
  final CardSize cardSize;

  String get cardBG {
    switch (cardColor) {
      case CardColor.cyan:
        return 'cyan';
      case CardColor.red:
        return 'red';
      default:
        return 'green';
    }
  }

  Color get cardShadow {
    switch (cardColor) {
      case CardColor.cyan:
        return ColorConstants.cyan1;
      case CardColor.red:
        return ColorConstants.red1;
      default:
        return ColorConstants.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    double cWidth = 160;
    double cHeight = 150;
    double sWidth = 127;
    double sHeight = 97;
    double typeFont = 8;
    double walletFont = 14;
    double aBalanceFont = 8;
    double amountFont = 14;
    final String currencySign =
        (currencyID.toLowerCase() == 'usd') ? '\$ ' : '₱ ';
    EdgeInsets cPadding = const EdgeInsets.fromLTRB(15, 17, 15, 0);

    if (cardSize == CardSize.large) {
      cWidth = 234;
      cHeight = 170;
      sWidth = 189;
      sHeight = 152;
      typeFont = 12;
      aBalanceFont = 12;
      walletFont = 20;
      amountFont = 20;
      cPadding = const EdgeInsets.fromLTRB(26, 27, 26, 0);
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      width: cWidth,
      height: cHeight,
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
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    width: sWidth,
                    height: sHeight,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: cardShadow,
                              blurRadius: 13,
                              offset: const Offset(4, 4),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Image.asset(
            'images/cards/$cardBG${(cardSize == CardSize.large) ? "_l" : "_s"}.png',
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            padding: cPadding,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    txtTypeWallet.toUpperCase(),
                    style: TextStyle(
                      color: const Color(0x80FFFFFF),
                      fontSize: typeFont,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(txtWallet,
                        style: TextStyle(
                            color: const Color(0xFFFFFFFF),
                            fontSize: walletFont)),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('AVAILABLE BALANCE',
                      style: TextStyle(
                          color: const Color(0x80FFFFFF),
                          fontSize: aBalanceFont)),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        currencySign +
                            NumberFormat.currency(customPattern: '#,###.##')
                                .format(availableBalance),
                        style: TextStyle(
                            color: const Color(0xFFFFFFFF),
                            fontSize: amountFont)),
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
