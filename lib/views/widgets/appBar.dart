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
      return Container(
        margin: EdgeInsets.all(20),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Image.asset(
              'images/icons/ic_back.png',
              width: 10,
              height: 15,
              fit:BoxFit.fill
          )
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(6, 6),
            ),
            BoxShadow(
              color: Color(0x82FFFFFF),
              blurRadius: 8,
              offset: const Offset(-5, -2),
            ),
          ],
        )
      );
    },
  );

  return AppBar(
    title: title,
    actions: action,
    leadingWidth: 80,
    automaticallyImplyLeading: true,
    toolbarHeight: toolBarHeight,
    elevation: 0,
    titleSpacing: titleSpacing,
    centerTitle: centerTitle,
    leading: leading,
  );
}