// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';

// Project imports:
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/util/my_route.dart';
import 'package:kwartracker/views/widgets/custom_body.dart';
import 'package:kwartracker/views/widgets/custom_floating_button.dart';
import 'package:kwartracker/views/widgets/header_nav.dart';
import 'category_add.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  Widget categoryChildWidgets(Map<String, dynamic> categoryIcon,
      String categoryName) {
    return Container(
            margin: const EdgeInsets.only(left: 40, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border:
                Border.all(width: 2, color: ColorConstants.grey1)
            ),
            padding: const EdgeInsets.all(7),
            child: Row(
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(3),
                  margin: const EdgeInsets.only(right: 10),
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
                  style: const TextStyle(
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

    final List<Widget> actionButtons = <Widget>[
      CustomFloatingButton(
        icon: Image.asset(
          'images/icons/ic_add.png',
          width: 10,
          height: 10,
          fit:BoxFit.fill
        ), onPressed: () {
          Navigator.push(context,
              MyRoute<dynamic>(
                  builder: (BuildContext context) => CategoryAddPage(),
                  routeSettings:
                  const RouteSettings(name: '/categoryAdd')
              )
          );
        }
      )
    ];

    Widget title() {
      return const Text(
        'Categories',
      );
    }

    Widget content() {

      return Container(
        padding: const EdgeInsets.all(10.0),
        child: const SizedBox(),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
          backgroundColor: const Color(0xFF03BED6),
          appBar: headerNav(
              title: title(),
              action: actionButtons
          ),
          body: CustomBody(hasScrollBody:true,child: Container(
              decoration: const BoxDecoration(
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
