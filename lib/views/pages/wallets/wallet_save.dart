// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:kwartracker/provider/firestore_data.dart';
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/views/widgets/card_wallets.dart';
import 'package:kwartracker/views/widgets/custom_body.dart';
import 'package:kwartracker/views/widgets/custom_dropdown.dart';
import 'package:kwartracker/views/widgets/custom_switch.dart';
import 'package:kwartracker/views/widgets/custom_text_field.dart';
import 'package:kwartracker/views/widgets/date_picker_text_field.dart';
import '../../widgets/header_nav.dart';

class WalletSavePage extends StatefulWidget {
  const WalletSavePage({this.walletID = ''});
  final String walletID;

  @override
  _WalletSavePageState createState() => _WalletSavePageState();
}

class _WalletSavePageState extends State<WalletSavePage> {
  String walletName = '';
  String walletType = '';
  String walletTypeID = '';
  String walletCurrencyID = '';
  String targetAmount = '';
  String walletCurrency = '';
  String savedTo = '';
  bool fOverallBalance = true;
  bool enableSaveButton = false;
  CardColor cardColor = CardColor.cyan;
  List<PopupMenuEntry<dynamic>> walletTypeList = <PopupMenuEntry<dynamic>>[];
  List<PopupMenuEntry<dynamic>> currencyList = <PopupMenuEntry<dynamic>>[];
  Map<String, dynamic> walletTypeListFS = <String, dynamic>{};
  TextEditingController conName = TextEditingController();
  TextEditingController conSavedTo = TextEditingController();
  TextEditingController conTargetAmount = TextEditingController();

  DateTime _date = DateTime.now();
  Future<void> _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'Select target date',
    );
    if (newDate != null) {
      if (mounted) {
        setState(() {
          _date = newDate;
        });
      }
    }
  }

  bool validateFields() {
    bool validate = true;

    if (walletName.isEmpty == true) {
      validate = false;
    }
    if (walletName.isEmpty) {
      validate = false;
    }
    if (walletTypeID.isEmpty) {
      validate = false;
    }
    if (walletCurrencyID.isEmpty) {
      validate = false;
    }

    if (walletType.toLowerCase() == 'goal') {
      if (targetAmount.isEmpty) {
        validate = false;
      }
      if (savedTo.isEmpty) {
        validate = false;
      }
    }

    if (validate == true) {
      enableSaveButton = true;
    }

    return validate;
  }

  @override
  void initState() {
    walletTypeList.clear();
    currencyList.clear();
    walletTypeListFS.clear();

    currencyList = const <PopupMenuEntry<dynamic>>[
      PopupMenuItem<dynamic>(
          child: Text('₱ (Php) Philippine Peso'),
          value: <String>['php', '₱ (Php) Philippine Peso']),
      PopupMenuItem<dynamic>(
          child: Text('\$ (Usd) US Dollar'),
          value: <String>['usd', '\$ (Usd) US Dollar'])
    ];

    if (widget.walletID.isNotEmpty) {
      Provider.of<FirestoreData>(context, listen: false)
          .walletsList
          .forEach((dynamic item) {
        if (item['id'] == widget.walletID) {
          targetAmount = item['targetAmount'].toString();
          walletName = item['name'];
          walletTypeID = item['typeID'];
          walletType = item['type'];
          walletCurrencyID = item['currencyID'];
          walletCurrency = item['currency'];
          fOverallBalance = (item['fOverallBalance'] == null)
              ? true
              : item['fOverallBalance'];
          savedTo = item['savedTo'];
          cardColor = item['color'];
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
        (widget.walletID.isNotEmpty) ? 'Edit Wallet' : 'Add Wallet',
      );
    }

    final List<Widget> actionButtons = <Widget>[
      TextButton(
        onPressed: () {
          if (enableSaveButton == true) {
            Provider.of<FirestoreData>(context, listen: false).saveWallet(
                context: context,
                walletID: widget.walletID,
                targetAmount: (targetAmount.isNotEmpty)
                    ? double.parse(targetAmount)
                    : 0.00,
                walletName: walletName,
                walletTypeID: walletTypeID,
                overAllBalance: fOverallBalance,
                walletCurrency: walletCurrencyID,
                savedTo: savedTo);
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
        walletTypeList = firestoreData.walletTypeData.map((dynamic item) {
          walletTypeListFS.putIfAbsent(item['id'], () => item['color']);
          return PopupMenuItem<dynamic>(
              child: Text(item['name']),
              value: <dynamic>[item['id'], item['name']]);
        }).toList();

        for (final CardColor cColor in CardColor.values) {
          if (cardColor != cColor) {
            final String cColorLast = cColor.toString().split('.').last;
            if (cColorLast == walletTypeListFS[walletTypeID]) {
              cardColor = cColor;
              break;
            }
          }
        }

        Widget goalFields() {
          return Column(
            children: <Widget>[
              CustomTextField(
                label: 'Target Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                hintText: 'Enter target amount',
                controller: conTargetAmount,
                onChanged: (dynamic value) {
                  targetAmount = value;
                },
              ),
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _selectDate.call();
                },
                child: DatePickerTextField(
                    hintText: 'Target Date',
                    label: 'target date',
                    text: _date.toString(),
                    onChanged: (dynamic value) {
                      _date = value;
                    },
                    items: const <PopupMenuEntry<PopupMenuItem<dynamic>>>[]),
              ),
              CustomTextField(
                label: 'Saved to',
                hintText: 'Enter saved to',
                controller: conSavedTo,
                onChanged: (dynamic value) {
                  savedTo = value;
                },
              ),
            ],
          );
        }

        return ListView(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
            children: <Widget>[
              Center(
                  child: CardWallets(
                txtWallet: walletName.toString(),
                txtTypeWallet: walletType,
                currencyID: walletCurrencyID,
                cardSize: CardSize.large,
                cardColor: cardColor,
              )),
              if (widget.walletID.isNotEmpty)
                CustomTextField(
                  label: 'Wallet Name',
                  hintText: 'Enter wallet name',
                  controller: conName,
                  autofocus: true,
                  onChanged: (dynamic value) {
                    walletName = value;
                  },
                )
              else
                CustomTextField(
                  label: 'Wallet Name',
                  hintText: 'Enter wallet name',
                  autofocus: true,
                  onChanged: (dynamic value) {
                    if (mounted && value != null) {
                      setState(() {
                        walletName = value;
                      });
                    }
                  },
                ),
              CustomDropdown(
                  label: 'Currency',
                  hintText: 'Select wallet currency',
                  text: walletCurrency,
                  onChanged: (dynamic value) {
                    if (mounted && value != null) {
                      setState(() {
                        walletCurrency = value[1];
                        walletCurrencyID = value[0];
                      });
                    }
                  },
                  items: currencyList),
              CustomDropdown(
                  label: 'Wallet Type',
                  hintText: 'Select wallet type',
                  text: walletType,
                  onChanged: (dynamic value) {
                    if (mounted && value != null) {
                      setState(() {
                        walletType = value[1];
                        walletTypeID = value[0];
                      });
                    }
                  },
                  items: walletTypeList),
              if (walletType.toLowerCase() == 'goal') goalFields(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 7),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: const Text(
                        'Include in overall total balance?',
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
                        value: fOverallBalance,
                        onChanged: (bool value) {
                          if (mounted) {
                            setState(() {
                              fOverallBalance = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const Text('No'),
                ],
              )
            ]);
      });
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: ModalProgressHUD(
        inAsyncCall: Provider.of<FirestoreData>(context).showSpinner,
        child: Scaffold(
            backgroundColor: const Color(0xFF03BED6),
            appBar: headerNav(title: title(), action: actionButtons),
            body: CustomBody(
              child: content(),
              hasScrollBody: true,
            )),
      ),
    );
  }
}
