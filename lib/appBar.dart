import 'package:flutter/material.dart';

AppBar headerNav({
  required Widget title,
  List<Widget>? action,
  Widget? leading,
  double? toolBarHeight,
  bool? centerTitle, double? titleSpacing}){
  if (toolBarHeight == null) toolBarHeight = 90;
  if (titleSpacing == null) titleSpacing = 40;
  if (centerTitle == null) centerTitle = true;

  return AppBar(
    title: title,
    actions: action,
    automaticallyImplyLeading: true,
    toolbarHeight: toolBarHeight,
    elevation: 0,
    titleSpacing: titleSpacing,
    centerTitle: centerTitle,
    leading: leading,
  );
}