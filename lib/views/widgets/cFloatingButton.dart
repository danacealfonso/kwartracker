import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';

class CFloatingButton extends StatelessWidget {
  CFloatingButton({
    required this.onPressed,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.cyan,
    this.leadingIconPath = "",
    required this.icon,
  });
  final String leadingIconPath;
  final VoidCallback onPressed;
  final Color textColor;
  final Color backgroundColor;
  final Widget icon;

  @override
  Widget build(BuildContext context) {

    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: 40,
          height: 40,
          margin: EdgeInsets.all(20),
          child: FloatingActionButton(
            heroTag: null,
            backgroundColor: ColorConstants.grey,
            onPressed: onPressed,
            child: icon
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(6, 6),
              ),
              BoxShadow(
                color: Color(0x82FFFFFF),
                blurRadius: 8,
                offset: const Offset(-6, -6),
              ),
            ],
          )
        );
      },
    );
  }
}
