// Flutter imports:
import 'package:flutter/material.dart';

AppBar headerNav({
  required Widget title,
  List<Widget>? action,
  Widget? leading,
  double toolBarHeight = 90,
  bool centerTitle = true,
  double titleSpacing = 40}){
  leading ??= Builder(
    builder: (BuildContext context) {
      return Container(
        margin: const EdgeInsets.all(20),
        child: FloatingActionButton(
          heroTag: null,
          elevation: 0,
          onPressed: () {
            Navigator.pop(context,'test');
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
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(6, 6),
            ),
            BoxShadow(
              color: Color(0x82FFFFFF),
              blurRadius: 8,
              offset: Offset(-6, -6),
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
