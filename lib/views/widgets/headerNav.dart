import 'package:flutter/material.dart';

AppBar headerNav({
  required Widget title,
  List<Widget>? action,
  Widget? leading,
  double toolBarHeight = 90,
  bool centerTitle = true,
  double titleSpacing = 40}){
  //TODO: IF Conditionals
  if (leading == null) leading = Builder(
    builder: (BuildContext context) {
      return Container(
        margin: EdgeInsets.all(20),
        child: FloatingActionButton(
          heroTag: null,
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
              offset: const Offset(-4, -2),
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