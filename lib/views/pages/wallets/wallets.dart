import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/pages/wallets/walletAdd.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:horizontal_card_pager/card_item.dart';
import '../../widgets/headerNav.dart';

class WalletsPage extends StatefulWidget {
  @override
  _WalletsPageState createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletsPage> {
  var actionButtons = [
    Builder(
      builder: (BuildContext context) {
        return Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.all(20),
            child: FloatingActionButton(
                backgroundColor: ColorConstants.grey,
                onPressed: () {
                  Navigator.push(context,
                      MyRoute(
                          builder: (context) => WalletAddPage()
                      )
                  );
                },
                child: Image.asset(
                    'images/icons/ic_add.png',
                    width: 10,
                    height: 10,
                    fit:BoxFit.fill
                )
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(6, 6),
                ),
                BoxShadow(
                  color: Color(0x82FFFFFF),
                  blurRadius: 8,
                  offset: const Offset(-4, -2),
                ),
              ],
            )
        );
      },
    )
  ];


  @override
  Widget build(BuildContext context) {
    List<CardItem> items = [
      IconTitleCardItem(
        text: "Alarm",
        iconData: Icons.access_alarms,
      ),
      IconTitleCardItem(
        text: "Add",
        iconData: Icons.add,
      ),
      IconTitleCardItem(
        text: "Call",
        iconData: Icons.add_call,
      ),
      IconTitleCardItem(
        text: "WiFi",
        iconData: Icons.wifi,
      ),
      IconTitleCardItem(
        text: "File",
        iconData: Icons.attach_file,
      ),
      IconTitleCardItem(
        text: "Air Play",
        iconData: Icons.airplay,
      ),
    ];
    Widget title() {
      return Text(
        "My Wallet",
      );
    }
    Widget content() {
      return HorizontalCardPager(
        initialPage : 2,
        onPageChanged: (page) => print("page : $page"),
        onSelectedItem: (page) => print("selected : $page"),
        items: items,  // set ImageCardItem or IconTitleCardItem class
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
          body: CBody(child: content())
      ),
    );
  }
}