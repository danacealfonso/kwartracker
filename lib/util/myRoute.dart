import 'package:flutter/material.dart';

class MyRoute<T> extends MaterialPageRoute<T> {
  MyRoute({ required WidgetBuilder builder, required RouteSettings routeSettings})
      : super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child;
  }
}