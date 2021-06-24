import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';

class CProgressBar extends StatelessWidget {
  CProgressBar({
    required this.max,
    required this.current,
    this.backgroundColor = ColorConstants.red,
    this.progressBarColor = ColorConstants.cyan6,
  });
  final double max;
  final double current;
  final Color backgroundColor;
  final Color progressBarColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, boxConstraints) {
        var x = boxConstraints.maxWidth;
        var percent = (current / max) * x;
        return Stack(
          children: [
            Container(
              width: x,
              height: 10,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(35),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: percent,
              height: 10,
              decoration: BoxDecoration(
                color: progressBarColor,
                borderRadius: BorderRadius.circular(35),
              ),
            ),
          ],
        );
      },
    );
  }
}