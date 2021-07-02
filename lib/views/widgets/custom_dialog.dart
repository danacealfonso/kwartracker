// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:kwartracker/util/color_constants.dart';
import 'custom_button.dart';

Future<void> customDialog(
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
          contentPadding: const EdgeInsets.all(40),
          backgroundColor: ColorConstants.grey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))
          ),
          content: Container(
            height: 270,
            child: Column(
              children: <Widget>[
                icon,
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Text(title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                    fontSize: 30,
                    color: ColorConstants.black,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                Text(description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                    fontSize: 16,
                    color: ColorConstants.black,
                )),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  height: 70,
                  child: CustomButton(text: textButton, onPressed: (){
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

