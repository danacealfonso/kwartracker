import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:kwartracker/model/firestoreData.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cDropdownTextField.dart';
import 'package:kwartracker/views/widgets/cSwitch.dart';
import 'package:kwartracker/views/widgets/cTextField.dart';
import 'package:kwartracker/views/widgets/headerNav.dart';
import 'package:provider/provider.dart';

class CategoryAddPage extends StatefulWidget {
  @override
  _CategoryAddPageState createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends State<CategoryAddPage> {
  String fName = "";
  String parentCategory = "";
  String parentCategoryID = "";
  bool fParent = false;
  bool enableSaveButton = false;
  Map<String, dynamic>? serIcon;
  List<PopupMenuEntry<dynamic>> categoryList = <PopupMenuEntry>[];

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker
        .showIconPicker(context, iconPackMode: IconPack.cupertino
    );

    setState((){
      serIcon = serializeIcon(icon!);
    });


    debugPrint('Picked Icon:  $serIcon');
    debugPrint('Picked Icon:  ${deserializeIcon(serIcon!)}');
  }

  bool validateFields() {
    var validate = true;
    if (fName.isEmpty) validate = false;

    if (serIcon == null) validate = false;

    if (fParent==false)
      if (parentCategoryID.isEmpty) validate = false;

    if (validate == true)
      enableSaveButton = true;

    return validate;
  }

  @override
  Widget build(BuildContext context) {
    validateFields();
    Widget title() => Text("Add Category");

    var actionButtons = [
      TextButton(
        onPressed: () {
          if (enableSaveButton == true) {
            Provider.of<FirestoreData>(context, listen: false)
              .saveCategory(
              categoryIcon: serIcon,
              categoryName: fName,
              categoryParentID: parentCategoryID,
              context: context
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text("Save",
              style: TextStyle(
                  fontSize: 16,
                  color: (enableSaveButton == true)? Colors.white
                      : ColorConstants.grey2
              )
          ),
        ),
      ),
    ];

    Widget content() {
      return Consumer<FirestoreData>(
        builder: (context, firestoreData, child) {
          return Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(children: [
              MaterialButton(
                padding: EdgeInsets.only(left: 20,right: 20),
                height: 100,
                minWidth: 100,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30)),
                onPressed: _pickIcon,
                child: serIcon != null?
                Icon(
                  deserializeIcon(serIcon!),
                  size: 50,
                ) :
                Icon(null),
                color: ColorConstants.cyan,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Select icon",
                  style: TextStyle(
                      color: ColorConstants.black2,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              CTextField(
                hintText: "Enter category name",
                label: "Category name",
                onChanged: (value) {
                  fName = value;
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 7),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Make parent category?",
                        style: TextStyle(
                            color: ColorConstants.grey6,
                            fontSize: 12
                        ),
                      ),
                    )
                ),
              ),
              Row(children: [
                Text("Yes"),
                RotatedBox(
                  quarterTurns: 2,
                  child: Container(
                    margin: EdgeInsets.only(right: 10, left: 10),
                    child: CSwitch(
                      value: fParent,
                      onChanged: (bool? value){
                        if(mounted && value != null)
                          setState(() {
                            fParent = value;
                          });
                      },
                    ),
                  ),
                ),
                Text("No"),
              ],),
              fParent == false ? CDropdownTextField(
                  label: "Wallet Type",
                  hintText: "Select wallet type",
                  text: parentCategory,
                  onChanged: (value) {
                    if(mounted && value != null)
                      setState(() {
                        parentCategory = value[1];
                        parentCategoryID = value[0];
                      });
                  },
                  items: firestoreData.categoriesParent.map((item) {
                    return PopupMenuItem<List>(
                        child: Text(item["name"]),
                        value: [item["id"], item["name"]]
                    );
                  }).toList()
              ) : SizedBox(),
            ],),
          );
        }
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
          backgroundColor: Color(0xFF03BED6),
          appBar: headerNav(
              title: title(),
              action: actionButtons
          ),
          body: CBody(child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF1F3F6),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                topLeft: Radius.circular(50),
              ),
            ),
            child: content()
          )
        )
      ),
    );
  }
}