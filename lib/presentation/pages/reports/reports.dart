// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kwartracker/util/color_constants.dart';

// Project imports:
import 'package:kwartracker/presentation/widgets/custom_body.dart';
import '../../widgets/header_nav.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<Widget> actionButtons = <Widget>[
    TextButton(
        onPressed: null,
        child: Image.asset('images/users/profile_pic.png',
            width: 70, height: 85, fit: BoxFit.fill))
  ];

  @override
  Widget build(BuildContext context) {
    Widget title() {
      return Column(children: const <Widget>[
        Text(
          'Hello',
        ),
        Text(
          'Samantha',
        ),
      ]);
    }

    Widget content() {
      return Column(
        children: <Widget>[
          SvgPicture.asset(
            'icons/ic_menu.svg',
            color: Colors.black,
            width: 100,
            height: 100,
            allowDrawingOutsideViewBox: true,
          ),
          Container(
              margin: const EdgeInsets.only(top: 100, bottom: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: ColorConstants.grey1)),
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
                    child: const Icon(
                      null,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              )),
        ],
      );
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
              child: Container(
                  padding: const EdgeInsets.all(10.0), child: content()),
            ))));
  }
}
