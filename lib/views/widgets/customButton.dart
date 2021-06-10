import 'package:flutter/material.dart';

Padding customButton({
  required String text,
  required VoidCallback onPressed,
  Color? textColor,
  Color? backgroundColor,

}){
  if (textColor == null) textColor = Colors.white;
  if (backgroundColor == null) backgroundColor = Colors.cyan;

  return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: MaterialButton(
        height: 48,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(15)),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: textColor,
          ),
        ),
        color: backgroundColor,
      )
  );
}