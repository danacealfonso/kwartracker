// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:kwartracker/util/color_constants.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({
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
      builder: (_, BoxConstraints boxConstraints) {
        final double x = boxConstraints.maxWidth;
        final double percent = (current / max) * x;
        return Stack(
          children: <Widget>[
            Container(
              width: x,
              height: 10,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(35),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
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
