import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';

class CDatePickerTextField extends StatelessWidget {
  CDatePickerTextField({
    required this.label,
    this.text,
    this.hintText,
    this.onChanged,
    required this.items,
    this.initialValue
  });

  final String label;
  final String? text;
  final String? hintText;
  final ValueChanged? onChanged;
  final List<PopupMenuEntry> items;
  final initialValue;

  @override
  Widget build(BuildContext context) {
    var txt = TextEditingController();
    if (text != null) txt.text = text!;
    return Column(children: [
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
            controller: txt,
            enabled: false,
            onChanged: onChanged,
            decoration: new InputDecoration(
              disabledBorder: OutlineInputBorder(
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
              suffixIcon: Container(
                margin: EdgeInsets.only(right: 5),
                width: 50,
                height: 40,
                decoration: BoxDecoration(
                    color: ColorConstants.grey1,
                    borderRadius: BorderRadius.all(Radius.circular(14))
                ),
                child: Icon(Icons.date_range),
              ),
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