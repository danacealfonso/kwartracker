import 'package:flutter/material.dart';

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
              width: 1
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
          color: Colors.black38,
          blurRadius: 14,
          offset: const Offset(6, 6),
          ),
        ],
      ),
    )
    ],
  );
}