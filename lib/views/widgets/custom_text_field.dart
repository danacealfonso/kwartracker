// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:kwartracker/util/color_constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {this.label = '',
      this.hintText = '',
      this.onChanged,
      this.obscureText = false,
      this.controller,
      this.initialValue = '',
      this.autofocus = false,
      this.keyboardType});

  final String label;
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged? onChanged;
  final String initialValue;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    if (controller != null) {
      onChanged!(controller!.text);
    }
    return Column(
      children: <Widget>[
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 7),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Text(
                    label,
                    style: const TextStyle(
                        color: ColorConstants.grey6, fontSize: 12),
                  ),
                )),
          ),
        Container(
          height: 56,
          child: TextField(
              autofocus: autofocus,
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              onChanged: onChanged,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                        color: Colors.white,
                        style: BorderStyle.solid,
                        width: 0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                        color: Colors.white,
                        style: BorderStyle.solid,
                        width: 1)),
                filled: true,
                hintStyle: const TextStyle(
                    color: Color(0xFFBBC3C9),
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
                hintText: hintText,
                fillColor: const Color(0xFFF1F3F6),
              )),
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
