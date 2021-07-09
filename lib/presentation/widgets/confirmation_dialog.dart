// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:kwartracker/util/color_constants.dart';
import 'custom_button.dart';

Future<void> confirmationDialog(
    BuildContext context, String text, VoidCallback onConfirm) async {
  return showDialog<void>(
    barrierColor: Colors.transparent,
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(40),
          backgroundColor: ColorConstants.grey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: Container(
            height: 180,
            child: Column(
              children: <Widget>[
                const Text(
                  'Confirmation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      color: ColorConstants.black,
                      fontWeight: FontWeight.bold),
                ),
                Text(text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: ColorConstants.black,
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  height: 64,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child:
                            CustomButton(text: 'Delete', onPressed: onConfirm),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(
                          left: 5.0,
                        ),
                        child: CustomButton(
                          text: 'Cancel',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          backgroundColor: ColorConstants.grey3,
                        ),
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
