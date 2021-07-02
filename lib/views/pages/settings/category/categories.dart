import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cFloatingButton.dart';
import 'package:kwartracker/views/widgets/headerNav.dart';
import 'categoryAdd.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  Widget categoryChildWidgets(Map<String, dynamic> categoryIcon,
      String categoryName) {
    return Container(
            margin: EdgeInsets.only(left: 40, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border:
                Border.all(width: 2, color: ColorConstants.grey1)
            ),
            padding: EdgeInsets.all(7),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(3),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: ColorConstants.cyan,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    deserializeIcon(categoryIcon),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Text(
                  categoryName,
                  style: TextStyle(
                      fontSize: 16,
                      color: ColorConstants.black,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )
        );
  }

  @override
  Widget build(BuildContext context) {

    var actionButtons = [
      CFloatingButton(
        icon: Image.asset(
          'images/icons/ic_add.png',
          width: 10,
          height: 10,
          fit:BoxFit.fill
        ), onPressed: () {
          Navigator.push(context,
              MyRoute(
                  builder: (context) => CategoryAddPage(),
                  routeSettings:
                  RouteSettings(name: "/categoryAdd")
              )
          );
        }
      )
    ];

    Widget title() {
      return Text(
        "Categories",
      );
    }

    Widget content() {

      return Container(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(),
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
          body: CBody(hasScrollBody:true,child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF1F3F6),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                    child:content()
                ),
              )
          ))
      ),
    );
  }
}