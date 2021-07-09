// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:kwartracker/util/color_constants.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({
    required this.onPressed,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.cyan,
    this.leadingIconPath = '',
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
            margin: const EdgeInsets.all(20),
            child: FloatingActionButton(
                heroTag: null,
                backgroundColor: ColorConstants.grey,
                onPressed: onPressed,
                child: icon),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(6, 6),
                ),
                BoxShadow(
                  color: Color(0x82FFFFFF),
                  blurRadius: 8,
                  offset: Offset(-6, -6),
                ),
              ],
            ));
      },
    );
  }
}
