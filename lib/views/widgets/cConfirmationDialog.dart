import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/widgets/cButton.dart';

Future<void> cConfirmationDialog(BuildContext context,
    String text, VoidCallback onConfirm) async {
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
            height: 180,
            child: Column(
              children: [
                Text("Confirmation",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  fontSize: 30,
                  color: ColorConstants.black,
                  fontWeight: FontWeight.bold
                ),),
                Text(text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    fontSize: 16,
                    color: ColorConstants.black,
                )),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 64,
                  child: Row(children: [
                    Expanded(child:
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: CButton(text: "Delete", onPressed: onConfirm),
                      )
                    ),
                    Expanded(child:
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0,),
                      child: CButton(text: "Cancel", onPressed: (){
                        Navigator.pop(context);
                      },backgroundColor: ColorConstants.grey3,),
                    ))
                  ],),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

