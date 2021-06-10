import 'package:flutter/material.dart';

class CButton extends StatelessWidget {
  CButton({
    required this.text,
    required this.onPressed,
    this.textColor,
    this.backgroundColor,
  });

  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: MaterialButton(
          height: 55,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15)),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: textColor == null ? Colors.white: textColor,
            ),
          ),
          color: backgroundColor == null ? Colors.cyan: backgroundColor,
        )
    );
  }
}
