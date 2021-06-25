import 'package:flutter/material.dart';

class CButton extends StatelessWidget {
  CButton({
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.cyan,
    this.leadingIconPath = "",
  });

  final String text;
  final String leadingIconPath;
  final VoidCallback onPressed;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: MaterialButton(
          height: 55,
          shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15)),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (leadingIconPath.isNotEmpty)?
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Image.asset(
                    leadingIconPath,
                    width: 20,
                    height: 20,
                    fit:BoxFit.fill
                ),
              ):SizedBox(),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ],
          ),
          color: backgroundColor,
        )
    );
  }
}
