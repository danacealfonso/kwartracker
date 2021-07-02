// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:kwartracker/util/color_constants.dart';

class DatePickerTextField extends StatelessWidget {
  const DatePickerTextField({
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
  final List<PopupMenuEntry<PopupMenuItem<dynamic>>> items;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final TextEditingController txt = TextEditingController();
    if (text != null) {
      txt.text = text!;
    }
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 7),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text(
                label,
                style: const TextStyle(
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
            decoration: InputDecoration(
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: Colors.white,
                      style: BorderStyle.solid,
                      width: 0
                  )
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: Colors.white,
                      style: BorderStyle.solid,
                      width: 1
                  )
              ),
              filled: true,
              hintStyle: const TextStyle(
                  color: Color(0xFFBBC3C9),
                  fontSize: 14,
                  fontStyle: FontStyle.italic
              ),
              hintText: hintText,
              fillColor: const Color(0xFFF1F3F6),
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 5),
                width: 50,
                height: 40,
                decoration: const BoxDecoration(
                    color: ColorConstants.grey1,
                    borderRadius: BorderRadius.all(Radius.circular(14))
                ),
                child: const Icon(Icons.date_range),
              ),
            )
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 14,
              offset: Offset(4, 4),
            ),
            BoxShadow(
              color: Colors.white,
              blurRadius: 14,
              offset: Offset(-6, -6),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      )
    ],
    );
  }
}
