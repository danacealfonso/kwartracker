import 'package:flutter/material.dart';
import 'colorConstants.dart';

Column customTextField({
  required String label,
  String? text,
  String? hintText,
}){ return Column(children: [
    Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 7),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Text(
              label,
              style: TextStyle(
                color: Color(0xFFBBC3C9),
                fontSize: 12
              ),
            ),
          )
      ),
    ),
    Container(
      child: TextField(
        decoration: new InputDecoration(
            enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.white,
              style: BorderStyle.solid,
              width: 0
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.white,
              style: BorderStyle.solid,
              width: 1
            )
          ),
          filled: true,
          hintStyle: new TextStyle(color: Color(0xFFBBC3C9)),
          hintText: hintText,
          fillColor: Color(0xFFF1F3F6),
        )
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
          color: Colors.black26,
          blurRadius: 14,
          offset: const Offset(4, 4),
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 14,
            offset: const Offset(-6, -6),
          ),
        ],
      ),
    ),
    SizedBox(
      height: 10,
    )
    ],
  );
}

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
          fontSize: 18,
          color: textColor,
        ),
      ),
      color: backgroundColor,
    )
);
}