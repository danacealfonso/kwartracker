import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/widgets/cButton.dart';

Future<void> cDialog(
    BuildContext context,
    String title,
    String description,
    String textButton,
    Widget icon) async {
  return showDialog<void>(
    barrierColor: Colors.transparent,
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: 20, sigmaY: 20),
        child: AlertDialog(
          contentPadding: EdgeInsets.all(40),
          backgroundColor: ColorConstants.grey,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))
          ),
          content: Container(
            height: 270,
            child: Column(
              children: [
                icon,
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    fontSize: 30,
                    color: ColorConstants.black,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                Text(description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    fontSize: 16,
                    color: ColorConstants.black,
                )),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 70,
                  child: CButton(text: textButton, onPressed: (){
                    Navigator.pop(context);
                  },backgroundColor: ColorConstants.cyan,),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

