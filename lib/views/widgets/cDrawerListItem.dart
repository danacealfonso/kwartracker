import 'package:flutter/material.dart';

class CDrawerListItem extends StatelessWidget {
  CDrawerListItem({
    required this.title,
    required this.leadingIconPath,
    this.textStyle,
  });

  final String title;
  final String leadingIconPath;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
          children: [
            Image.asset(
                leadingIconPath,
                width: 11,
                height: 10,
                fit:BoxFit.fill
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Text(title,
                style: textStyle == null ? TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ): textStyle
              )
            )
          ]
      ),
    );
  }
}
