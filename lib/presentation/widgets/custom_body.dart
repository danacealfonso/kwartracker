// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:kwartracker/util/color_constants.dart';

class CustomBody extends StatefulWidget {
  const CustomBody({
    Key? key,
    required this.child,
    this.hasScrollBody = false,
  }) : super(key: key);

  final Widget child;
  final bool hasScrollBody;

  @override
  _CustomBodyState createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> with TickerProviderStateMixin {
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: _animation,
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          decoration: const BoxDecoration(
            color: ColorConstants.grey,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              topLeft: Radius.circular(50),
            ),
          ),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                  hasScrollBody: widget.hasScrollBody, child: widget.child),
            ],
          ),
        ));
  }
}
