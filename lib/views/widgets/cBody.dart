import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';

class CBody extends StatefulWidget {
  final Widget child;
  CBody({Key? key, required this.child}) : super(key: key);

  @override
  _CBodyState createState() => _CBodyState();
}

class _CBodyState extends State<CBody> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        padding: EdgeInsets.fromLTRB(30, 30, 20, 30),
        decoration: BoxDecoration(
          color: ColorConstants.gray,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
        ),
        child: widget.child,
      )
    );
  }
}

