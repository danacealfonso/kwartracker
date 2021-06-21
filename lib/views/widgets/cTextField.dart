import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';

class CTextField extends StatelessWidget {
  CTextField({
    required this.label,
    this.hintText = "",
    this.onChanged,
    this.obscureText = false,
    this.controller,
    this.initialValue = ""
  });

  final String label;
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final ValueChanged? onChanged;
  final String initialValue;

  @override
  Widget build(BuildContext context) {

    return Column(children: [
      Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 7),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Text(
              label,
              style: TextStyle(
                color: ColorConstants.grey6,
                fontSize: 12
              ),
            ),
          )
        ),
      ),
      Container(
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          onChanged: onChanged,
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
            hintStyle: new TextStyle(
              color: Color(0xFFBBC3C9),
              fontSize: 14,
              fontStyle: FontStyle.italic
            ),
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
}