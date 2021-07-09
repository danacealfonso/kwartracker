// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:kwartracker/provider/firestore_data.dart';
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/presentation/widgets/custom_body.dart';
import 'package:kwartracker/presentation/widgets/custom_dropdown.dart';
import 'package:kwartracker/presentation/widgets/custom_switch.dart';
import 'package:kwartracker/presentation/widgets/custom_text_field.dart';
import 'package:kwartracker/presentation/widgets/header_nav.dart';

class CategoryAddPage extends StatefulWidget {
  @override
  _CategoryAddPageState createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends State<CategoryAddPage> {
  String fName = '';
  String parentCategory = '';
  String parentCategoryID = '';
  bool fParent = false;
  bool enableSaveButton = false;
  Map<String, dynamic>? serIcon;
  List<PopupMenuEntry<dynamic>> categoryList = <PopupMenuEntry<dynamic>>[];

  Future<void> _pickIcon() async {
    final IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackMode: IconPack.cupertino);

    setState(() {
      serIcon = serializeIcon(icon!);
    });

    debugPrint('Picked Icon:  $serIcon');
    debugPrint('Picked Icon:  ${deserializeIcon(serIcon!)}');
  }

  bool validateFields() {
    bool validate = true;
    if (fName.isEmpty) {
      validate = false;
    }

    if (serIcon == null) {
      validate = false;
    }

    if (fParent == false) {
      if (parentCategoryID.isEmpty) {
        validate = false;
      }
    }

    if (validate == true) {
      enableSaveButton = true;
    }

    return validate;
  }

  @override
  Widget build(BuildContext context) {
    validateFields();
    Widget title() => const Text('Add Category');

    final List<Widget> actionButtons = <Widget>[
      TextButton(
        onPressed: () {
          if (enableSaveButton == true) {
            Provider.of<FirestoreData>(context, listen: false).saveCategory(
                categoryIcon: serIcon,
                categoryName: fName,
                categoryParentID: parentCategoryID,
                context: context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text('Save',
              style: TextStyle(
                  fontSize: 16,
                  color: (enableSaveButton == true)
                      ? Colors.white
                      : ColorConstants.grey2)),
        ),
      ),
    ];

    Widget content() {
      return Consumer<FirestoreData>(builder:
          (BuildContext context, FirestoreData firestoreData, Widget? child) {
        return Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              MaterialButton(
                padding: const EdgeInsets.only(left: 20, right: 20),
                height: 100,
                minWidth: 100,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: _pickIcon,
                child: serIcon != null
                    ? Icon(
                        deserializeIcon(serIcon!),
                        size: 50,
                      )
                    : const Icon(null),
                color: ColorConstants.cyan,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Select icon',
                  style: TextStyle(
                      color: ColorConstants.black2,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
              CustomTextField(
                hintText: 'Enter category name',
                label: 'Category name',
                onChanged: (dynamic value) {
                  fName = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 7),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: const Text(
                        'Make parent category?',
                        style: TextStyle(
                            color: ColorConstants.grey6, fontSize: 12),
                      ),
                    )),
              ),
              Row(
                children: <Widget>[
                  const Text('Yes'),
                  RotatedBox(
                    quarterTurns: 2,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10, left: 10),
                      child: CustomSwitch(
                        value: fParent,
                        onChanged: (bool? value) {
                          if (mounted && value != null) {
                            setState(() {
                              fParent = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const Text('No'),
                ],
              ),
              if (fParent == false)
                CustomDropdown(
                    label: 'Wallet Type',
                    hintText: 'Select wallet type',
                    text: parentCategory,
                    onChanged: (dynamic value) {
                      if (mounted && value != null) {
                        setState(() {
                          parentCategory = value[1];
                          parentCategoryID = value[0];
                        });
                      }
                    },
                    items: firestoreData.categoriesParent
                        .map((Map<String, dynamic> item) {
                      return PopupMenuItem<dynamic>(
                          child: Text(item['name']),
                          value: <dynamic>[item['id'], item['name']]);
                    }).toList()),
            ],
          ),
        );
      });
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
          backgroundColor: const Color(0xFF03BED6),
          appBar: headerNav(title: title(), action: actionButtons),
          body: CustomBody(
              child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F3F6),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  child: content()))),
    );
  }
}
