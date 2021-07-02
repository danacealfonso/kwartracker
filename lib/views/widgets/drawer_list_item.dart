// Flutter imports:
import 'package:flutter/material.dart';

class DrawerListItem extends StatelessWidget {
  const DrawerListItem({
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        children: <Widget>[
          Image.asset(
            leadingIconPath,
            width: 11,
            height: 10,
            fit:BoxFit.fill
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Text(title,
              style: textStyle ?? const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500
              )
            )
          )
        ]
      ),
    );
  }
}
