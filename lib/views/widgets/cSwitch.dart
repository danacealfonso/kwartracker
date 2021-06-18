import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';

class CSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  CSwitch({
    Key? key,
    this.value = true,
    this.onChanged})
      : super(key: key);

  @override
  _CSwitchState createState() => _CSwitchState();
}

class _CSwitchState extends State<CSwitch>
    with SingleTickerProviderStateMixin {
  late Animation _circleAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
        begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        end: widget.value ? Alignment.centerLeft :Alignment.centerRight).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.value == false
                ? widget.onChanged!(true)
                : widget.onChanged!(false);
          },
          child: Container(
            width: 60.0,
            height: 38.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: ColorConstants.grey,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 14,
                  offset: const Offset(-6, -6),
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 14,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
              child:  Container(
                alignment: widget.value
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 32.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.0),
                    color: _circleAnimation.value ==
                        Alignment.centerLeft
                        ? ColorConstants.grey6
                        : ColorConstants.cyan,),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}