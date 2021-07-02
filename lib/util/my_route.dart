// Flutter imports:
import 'package:flutter/material.dart';

class MyRoute<T> extends MaterialPageRoute<T> {
  MyRoute({
    required WidgetBuilder builder,
    RouteSettings? routeSettings,
    bool maintainState = false,
    bool fullscreenDialog = false,
  }) : super(
      builder: builder,
      maintainState: maintainState,
      settings: routeSettings,
      fullscreenDialog: fullscreenDialog);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
