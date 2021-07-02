import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/model/firestoreData.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cCardWallets.dart';
import 'package:kwartracker/views/widgets/cDatePickerTextField.dart';
import 'package:kwartracker/views/widgets/cDropdownTextField.dart';
import 'package:kwartracker/views/widgets/cSwitch.dart';
import 'package:kwartracker/views/widgets/cTextField.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../../widgets/headerNav.dart';

class WalletSavePage extends StatefulWidget {
  final String walletID;
  WalletSavePage({this.walletID = ""});

  @override
  _WalletSavePageState createState() => _WalletSavePageState();
}

class _WalletSavePageState extends State<WalletSavePage> {
  String walletName = "";
  String walletType = "";
  String walletTypeID = "";
  String walletCurrencyID = "";
  String targetAmount = "";
  String walletCurrency = "";
  String savedTo = "";
  bool fOverallBalance = true;
  bool enableSaveButton = false;
  CardColor cardColor = CardColor.cyan;
  List <PopupMenuEntry>walletTypeList = <PopupMenuEntry>[];
  List<PopupMenuEntry>currencyList = <PopupMenuEntry>[];
  var walletTypeListFS = {};
  var conName = TextEditingController();
  var conSavedTo = TextEditingController();
  var conTargetAmount = TextEditingController();

  DateTime _date = DateTime.now();
  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'Select target date',
    );
    if (newDate != null) {
      if(mounted)
      setState(() {
        _date = newDate;
      });
    }
  }

  bool validateFields() {
    var validate = true;
    if (walletName.isEmpty) validate = false;
    if (walletTypeID.isEmpty) validate = false;
    if (walletCurrencyID.isEmpty) validate = false;

    if (walletType.toLowerCase()=='goal'){
      if (targetAmount.isEmpty) validate = false;
      if (savedTo.isEmpty) validate = false;
    }

    if (validate == true)
      enableSaveButton = true;

    return validate;
  }

  @override
  void initState () {
    walletTypeList.clear();
    currencyList.clear();
    walletTypeListFS.clear();

    currencyList = <PopupMenuEntry>[
      PopupMenuItem<List>(
          child: Text('₱ (Php) Philippine Peso'),
          value: ['php', '₱ (Php) Philippine Peso']),
      PopupMenuItem<List>(
          child: Text('\$ (Usd) US Dollar'),
          value: ['usd', '\$ (Usd) US Dollar'])
    ];

    if (widget.walletID.isNotEmpty) {
      List getWallet = Provider.of<FirestoreData>(context, listen: false)
          .walletsList;
      getWallet.forEach((item) {
        if (item["id"] == widget.walletID) {
          targetAmount = item["targetAmount"].toString();
          walletName = item["name"];
          walletTypeID = item["typeID"];
          walletType = item["type"];
          walletCurrencyID = item["currencyID"];
          walletCurrency = item["currency"];
          fOverallBalance = item["fOverallBalance"];
          savedTo = item["savedTo"];
          cardColor = item["color"];
          conName.text = walletName;
          conSavedTo.text = savedTo;
          conTargetAmount.text = targetAmount;
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    validateFields();
    Widget title() {
      return Text(
        (widget.walletID.isNotEmpty)? "Edit Wallet":
        "Add Wallet",
      );
    }

    var actionButtons = [
      TextButton(
        onPressed: () {
          if (enableSaveButton == true) {
            Provider.of<FirestoreData>(context, listen: false)
            .saveWallet(
              context: context,
              walletID: widget.walletID,
              targetAmount: (targetAmount.isNotEmpty) ?
                double.parse(targetAmount):0.00,
              walletName: walletName,
              walletTypeID: walletTypeID,
              overAllBalance: fOverallBalance,
              walletCurrency: walletCurrencyID,
              savedTo: savedTo
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
          walletTypeList = firestoreData.walletTypeData.map((item) {
            walletTypeListFS.putIfAbsent(item["id"], () => item["color"]);
            return PopupMenuItem<List>(
                child: Text(item["name"]),
                value: [item["id"], item["name"]]
            );
          }).toList();

          for (CardColor cColor in CardColor.values) {
            if(cardColor != cColor) {
              var cColorLast = cColor.toString().split('.').last;
              if (cColorLast == walletTypeListFS[walletTypeID]) {
                cardColor = cColor;
                break;
              }
            }
          }

          Widget goalFields() {
            return Column(
              children: [
                CTextField(
                  label: "Target Amount",
                  keyboardType: TextInputType
                      .numberWithOptions(decimal: true),
                  hintText: "Enter target amount",
                  controller: conTargetAmount,
                  onChanged: (value) {
                    targetAmount = value;
                  },
                ),
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    _selectDate.call();
                  },
                  child: CDatePickerTextField(
                      hintText: "Target Date",
                      label: "target date",
                      text: _date.toString(),
                      onChanged: (value) {
                        _date = value;
                      },
                      items: []
                  ),
                ),
                CTextField(
                  label: "Saved to",
                  hintText: "Enter saved to",
                  controller: conSavedTo,
                  onChanged: (value) {
                    savedTo = value;
                  },
                ),
              ],
            );
          }

          return ListView(
              padding: EdgeInsets.fromLTRB(30,30,30,30),
              children: <Widget>[
                Center(child: CCardWallets(
                  txtWallet: walletName.toString(),
                  txtTypeWallet: walletType,
                  currencyID: walletCurrencyID,
                  cardSize: CardSize.large,
                  cardColor: cardColor,)
                ),
                (widget.walletID.isNotEmpty)? CTextField(
                  label: "Wallet Name",
                  hintText: "Enter wallet name",
                  controller: conName,
                  autofocus: true,
                  onChanged: (value) {
                    walletName = value;
                  },
                ):CTextField(
                  label: "Wallet Name",
                  hintText: "Enter wallet name",
                  autofocus: true,
                  onChanged: (value) {
                    if(mounted && value != null)
                      setState(() {
                        walletName = value;
                      });
                  },
                ),
                CDropdownTextField(
                    label: "Currency",
                    hintText: "Select wallet currency",
                    text: walletCurrency,
                    onChanged: (value) {
                      if(mounted && value != null)
                        setState(() {
                          walletCurrency = value[1];
                          walletCurrencyID = value[0];
                        });
                    },
                    items: currencyList
                ),
                CDropdownTextField(
                    label: "Wallet Type",
                    hintText: "Select wallet type",
                    text: walletType,
                    onChanged: (value) {
                      if(mounted && value != null)
                        setState(() {
                          walletType = value[1];
                          walletTypeID = value[0];
                        });
                    },
                    items: walletTypeList
                ),
                (walletType.toLowerCase()=='goal')? goalFields(): SizedBox(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 7),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Include in overall total balance?",
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
                        value: fOverallBalance==null? true: fOverallBalance,
                        onChanged: (bool value){
                          if(mounted && value != null)
                          setState(() {
                            fOverallBalance = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Text("No"),
                ],)
              ]
          );
        }
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: ModalProgressHUD(
        inAsyncCall: Provider.of<FirestoreData>(context).showSpinner,
        child: Scaffold(
            backgroundColor: Color(0xFF03BED6),
            appBar: headerNav(
                title: title(),
                action: actionButtons
            ),
            body: CBody(child: content(),hasScrollBody: true,)
        ),
      ),
    );
  }
}