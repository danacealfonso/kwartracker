import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';

class CTextField extends StatelessWidget {
  CTextField({
    required this.label,
    this.text = "",
    this.hintText = "",
    this.onChanged,
    this.obscureText = false
  });

  final String label;
  final String text;
  final String hintText;
  final bool obscureText;
  final ValueChanged? onChanged;

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();

    if(text.isNotEmpty) {
      onChanged!(text);
      controller.text = text;
    }
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
          obscureText: obscureText,
          onChanged: onChanged,
          controller: controller,
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