import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/model/firestoreData.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cButton.dart';
import 'package:kwartracker/views/widgets/cConfirmationDialog.dart';
import 'package:kwartracker/views/widgets/cDatePickerTextField.dart';
import 'package:kwartracker/views/widgets/cDropdownTextField.dart';
import 'package:kwartracker/views/widgets/cTextField.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../widgets/headerNav.dart';

class TransactionEditPage extends StatefulWidget {
  final String? transactionID;
  TransactionEditPage(this.transactionID);

  @override
  _TransactionEditPageState createState() => _TransactionEditPageState();
}

class _TransactionEditPageState extends State<TransactionEditPage> {
  bool enableSaveButton = false;
  String fName = "";
  String fType = "";
  String fCategory = "";
  String fCategoryID = "";
  String fWalletID = "";
  String fWallet = "";
  String fAmount = "";
  String fPersonName = "";
  File? file;
  String fDate = "";
  String fPhoto = "";
  Map<String, dynamic> transaction = Map<String, dynamic>();
  List<PopupMenuEntry<dynamic>> categoryList = <PopupMenuEntry>[];
  List<PopupMenuEntry<dynamic>> walletsList = <PopupMenuEntry>[];
  var conAmount = TextEditingController();
  var conPersonName = TextEditingController();

  bool validateFields () {
    var validate = true;
    if (fWallet.isEmpty) validate = false;
    if (conAmount.text.isEmpty) validate = false;
    if (fType.isEmpty) validate = false;
    if (fCategory.isEmpty) validate = false;
    if (widget.transactionID == null) validate = false;

    if (validate == true) {
      setState(() {
        enableSaveButton = true;
      });
    }
    return validate;
  }

  DateTime _date = DateTime.now();
  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'Select a date',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  Future selectFile() async {
    final result = await FilePicker
        .platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));

  }

  void saveAndUpload() {
    if (validateFields() == true) {
      Provider.of<FirestoreData>(context, listen: false).saveTransaction(
        context: context,
        transDate: _date,
        transID: widget.transactionID.toString(),
        walletID: fWalletID,
        spentPerson: fPersonName,
        file: file,
        catID: fCategoryID,
        transName: fName,
        transType: fType,
        fPhoto: fPhoto,
        amount: double.parse(conAmount.text),
      );

    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar( SnackBar(
        content: Text("Please fill up all the fields."),
        duration: Duration(milliseconds: 2000),
      ), );
    }
  }

  @override
  void initState() {
    super.initState();

    Provider.of<FirestoreData>(context,listen: false)
        .getTransaction(widget.transactionID!).then((value) {
      fWallet = (value["walletName"]!=null)? value["walletName"]: "";
      fWalletID = (value["wallet"]!=null)? value["wallet"]: "";
      conAmount.text = value["amount"].toString();
      fType = value["type"];
      fName = value["name"];
      fCategoryID = value["category"];
      fCategory = value["categoryName"];
      fPhoto = value["photo"];
      conPersonName.text = value["spentPerson"];
      if(value["fDate"] != null) {
        Timestamp t = value["fDate"];
        _date = t.toDate();
      }

      if (mounted) setState(() {
        transaction = value;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    validateFields();
    final fileName = file != null ? file!.path.split('/').last : "";
    var actionButtons = [
      TextButton(
        onPressed: () {
          if (enableSaveButton == true) {
            cConfirmationDialog(context,
              "Are you sure you want to update this?",
                () {
                saveAndUpload();
              }
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

    Widget title() {
      return Text(
          "Edit Transaction",
        );
    }

    Widget content() {
      return Consumer<FirestoreData>(
          builder: (context, firestoreData, child) {
            categoryList = firestoreData.categoriesList.map((item) {
              return PopupMenuItem<List>(
                  child: Container(width: 500, child: Text(item["name"])),
                  value: [item["id"], item["name"]]
              );
            }).toList();

            walletsList = firestoreData.walletsList.map((item) {
              return PopupMenuItem<List>(
                child: Text(item["name"]),
                value: [item["id"], item["name"]]
              );
            }).toList();

            return Container(
              margin: const EdgeInsets.only(top: 30),
              child: ListView(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                  children: <Widget>[
                    CDropdownTextField(
                        label: "Which wallet do you want it to add?",
                        hintText: "Select wallet to add",
                        text: fWallet,
                        onChanged: (value) {
                          if(value != null)
                          setState(() {
                            fWallet = value[1];
                            fWalletID = value[0];
                          });
                        },
                        items: walletsList
                    ),
                    CTextField(
                      hintText: "Enter transaction amount",
                      label: "Transaction amount",
                      controller: conAmount,
                      onChanged: (value) {
                        fAmount = value;
                      },
                    ),
                    CDropdownTextField(
                        label: "Transaction type",
                        hintText: "Select transaction type",
                        text: fType,
                        onChanged: (value) {
                          if (value != null )
                            setState(() {
                              fType = value[1];
                            });
                        },
                        items: [
                          PopupMenuItem<List>(
                            child: const Text('Income'),
                            value: ['Income','Income']),
                          PopupMenuItem<List>(
                            child: const Text('Expense'),
                            value: ['Expense','Expense']),
                        ]
                    ),
                    CDropdownTextField(
                        label: "Category",
                        hintText: "Select Category",
                        text: fCategory.toString(),
                        onChanged: (value) {
                          if (value != null )
                            setState(() {
                              fCategory = value[1];
                              fCategoryID = value[0];
                            });
                        },
                        items: categoryList
                    ),
                    GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        _selectDate.call();
                      },
                      child: CDatePickerTextField(
                          hintText: "Select Date",
                          label: "Select date",
                          text: _date.toString(),
                          onChanged: (value) {
                            _date = value;
                          },
                          items: []
                      ),
                    ),
                    CTextField(
                      label: "Spent with this person",
                      hintText: "Enter name of person",
                      controller: conPersonName,
                      onChanged: (value) {
                        fPersonName = value;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(
                              "Upload photo",
                              style: TextStyle(
                                  color: Color(0xFFBBC3C9),
                                  fontSize: 12
                              ),
                            ),
                          )
                      ),
                    ),
                    (transaction["photoURL"] != null)? Container(
                        width: MediaQuery.of(context).size.width,
                        height: 190,
                        decoration: BoxDecoration(
                          color: ColorConstants.grey,
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(transaction["photoURL"]!),
                          ),
                        )
                    ):SizedBox(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 100,
                        child: CButton(
                            text: "Replace",
                            backgroundColor: ColorConstants.grey3,
                            onPressed: () { selectFile(); }
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(fileName, style:
                      TextStyle(fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: ColorConstants.grey3)
                      ),
                    ),
                  ]
              ),
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
          body: CBody(child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF1F3F6),
              borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              topLeft: Radius.circular(50),
              ),
            ),
            child: content()
            ),
            hasScrollBody: true,
          )
        ),
      ),
    );
  }
}