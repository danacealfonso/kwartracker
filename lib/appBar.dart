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

  if (leading == null) leading = Builder(
    builder: (BuildContext context) {
      return IconButton(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        icon: Image.asset(
            'images/icons/ic_back.png',
            width: 50,
            height: 50,
            fit:BoxFit.fill
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    },
  );

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