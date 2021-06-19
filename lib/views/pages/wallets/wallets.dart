import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/myRoute.dart';
import 'package:kwartracker/views/pages/wallets/walletAdd.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kwartracker/views/widgets/cCardWallets.dart';
import 'package:kwartracker/views/widgets/cTransactionListItem.dart';
import '../../widgets/headerNav.dart';

class WalletsPage extends StatefulWidget {
  @override
  _WalletsPageState createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletsPage> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
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

  Widget title() {
    return Text(
      "My Wallet",
    );
  }
  final List<Map<String, dynamic>> imgList = [];
  int prevListCount = 0;
  int _current = 0;

  void getData() async {
    List<Map<String, dynamic>> walletTypeData = [];
    List<Map<String, dynamic>> colorData = [];
    for (CardColor cColor in CardColor.values) {
      var cColorLast = cColor.toString().split('.').last;
      colorData.add({
        "color": cColorLast,
        "cardColor": cColor,
      });
    }

    var walletTypeStream = _fireStore.collection("walletType")
        .snapshots();

    walletTypeStream.listen((snapshot) {
      for (var walletType in snapshot.docs) {
        String walletName = walletType.data()["name"];
        String walletId = walletType.id;
        String walletColor = walletType.data()["colorName"];
        walletTypeData.add({
          "id": walletId,
          "color": walletColor,
          "name":walletName,
        });
      }

      var walletsStream = _fireStore.collection("wallets")
          .where("uID", isEqualTo: _auth.currentUser!.uid)
          .snapshots();

      walletsStream.listen((snapshot) {
        imgList.clear();
        for (var walletType in snapshot.docs) {
          String walletName = walletType.data()["name"];
          String walletTypeID = walletType.data()["type"];
          String balance = walletType.data()["balance"];
          CardColor? walletColor;
          String? walletTypeName = "";
          for (var walletType in walletTypeData) {
            if(walletTypeID == walletType["id"]) {
              var colorIndex = colorData.indexWhere((element) =>
                element["color"] == walletType["color"]);

              walletTypeName = walletType["name"];
              walletColor = colorData[colorIndex]["cardColor"];
              break;
            }
          }

          imgList.add({
            "color": walletColor,
            "type": walletTypeName,
            "name":walletName,
            "balance":balance == null ? "0.00": balance
          });
        }

        if(prevListCount != imgList.length)
          setState(() {});

        prevListCount = imgList.length;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    getData();
    final List<Widget> imageSliders = imgList.map((item) => Container(
      child: Container(
        width: 240,
        child: CCardWallets(
          txtTypeWallet: item["type"],
          txtWallet: item["name"],
          availableBalance: double.parse(item["balance"]),
          cardSize: CardSize.large,
          cardColor: item["color"],
        )
      ),
    )).toList();
    Widget content() {
      return Container(
        height: 300,
        child: Column(
          children: [
            Stack(
              children: [
                CarouselSlider(
                  items: imageSliders,
                  options: CarouselOptions(
                    viewportFraction: 0.6,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 180.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imgList.map((url) {
                      int index = imgList.indexOf(url);
                      return _current == index ? Container(
                        width: 15.0,
                        height: 10.0,
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                          color : ColorConstants.cyan,
                        ),
                      ) : Container(
                        width: 10.0,
                        height: 10.0,
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                          color : ColorConstants.grey1,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ]
            ),
            Row(children: [
              Container(
                  height: 30,
                  width: 30,
                  child: FloatingActionButton(
                      backgroundColor: ColorConstants.grey,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                          'images/icons/ic_close.png',
                          width: 10,
                          height: 10,
                          fit:BoxFit.fill
                      )
                  )
              ),
              Text("Edit Wallet"),
              Container(
                  height: 30,
                  width: 30,
                  child: FloatingActionButton(
                      backgroundColor: ColorConstants.grey,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                          'images/icons/ic_close.png',
                          width: 10,
                          height: 10,
                          fit:BoxFit.fill
                      )
                  )
              ),
              Text("Add Transaction")
            ]),
            Container(
              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          "Transactions",
                          style: TextStyle(
                              color: ColorConstants.black1,
                              fontSize: 16,
                              fontWeight: FontWeight.w700
                          )
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [Text(
                          "View All",
                          style: TextStyle(
                              color: ColorConstants.grey6,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500
                          )
                      )],
                    ),
                  ]
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(25, 0, 25, 90),
                children: <Widget>[
                  for(int i=0; i<15; i++)
                    CTransactionListItem(
                      month: "Mar",
                      day: 15,
                      walletType: "SALARY",
                      walletName: "March 15 Payroll",
                      amount: 10000.00,
                    ),
                ],
              ),
            ),
          ],
        ),
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