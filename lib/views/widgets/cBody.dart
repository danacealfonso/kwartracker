import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';

class CBody extends StatefulWidget {
  //TODO: Final vs Const
  final Widget child;
  final bool? hasScrollBody;
  final double? paddingBottom;
  CBody({Key? key, required this.child, this.hasScrollBody, this.paddingBottom}) : super(key: key);

  @override
  _CBodyState createState() => _CBodyState();
}

class _CBodyState extends State<CBody> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  //TODO: Custom Flutter Animations with the Animation Controller
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
        decoration: BoxDecoration(
          color: ColorConstants.grey,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody:
                (widget.hasScrollBody==null || widget.hasScrollBody==true)
                    ? true : false ,
              child: widget.child
            ),
          ],
        ),
      )
    );
  }
}

