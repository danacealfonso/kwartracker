import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/model/firestoreData.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cButton.dart';
import 'package:kwartracker/views/widgets/cDatePickerTextField.dart';
import 'package:kwartracker/views/widgets/cDropdownTextField.dart';
import 'package:kwartracker/views/widgets/cTextField.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../widgets/headerNav.dart';

class TransactionAddDetailsPage extends StatefulWidget {
  final String? walletID;
  TransactionAddDetailsPage(this.walletID);

  @override
  _TransactionAddDetailsPageState createState() =>
      _TransactionAddDetailsPageState();
}

class _TransactionAddDetailsPageState extends
  State<TransactionAddDetailsPage> {
  String fName = "";
  String fType = "";
  String fCategory = "";
  String fCategoryID = "";
  bool enableAddButton = false;
  String fPersonName = "";
  File? file;
  late final String fDate;
  late final String fPhoto;
  List<PopupMenuEntry<dynamic>> categoryList = <PopupMenuEntry>[];
  var txtAmount = TextEditingController();
  var actionButtons = [
    TextButton(
        onPressed: () {  },
        child: Text(""),
    ),
  ];

  bool validateFields () {
    var validate = true;
    if (fName.isEmpty) validate = false;
    if (fType.isEmpty) validate = false;
    if (fCategory.isEmpty) validate = false;
    if (fPersonName.isEmpty) validate = false;
    if (fCategory.isEmpty) validate = false;
    if (fType.isEmpty) validate = false;
    if (txtAmount.text.isEmpty) validate = false;
    if (file == null) validate = false;
    if (widget.walletID == null) validate = false;

    if (validate == true) {
      setState(() {
        enableAddButton = true;
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar( SnackBar(
        content: Text("Please fill up all the fields."),
        duration: Duration(milliseconds: 2000),
      ), );
    }

    return validate;
  }

  @override
  void initState() {

    super.initState();
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
        walletID: widget.walletID.toString(),
        spentPerson: fPersonName,
        file: file!,
        catID: fCategoryID,
        transName: fName,
        transType: fType,
        amount: double.parse(txtAmount.text),
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
  Widget build(BuildContext context) {
    final fileName = file != null ? file!.path.split('/').last : "";

    Widget title() {
      return Text(
        "Add Transaction",
      );
    }

    Widget content() {
      return Consumer<FirestoreData>(
          builder: (context, firestoreData, child) {
            categoryList = firestoreData.categoriesList.map((item) {
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
                    Center(child: Text("Enter amount"),),
                    Center(child: TextField(
                        autofocus: true,
                        keyboardType: TextInputType
                          .numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 40,
                            color: ColorConstants.black
                        ),
                        controller: txtAmount,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        )
                    ),),
                    CTextField(
                      hintText: "Enter transaction name",
                      label: "Transaction name",
                      onChanged: (value) {
                        fName = value;
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
                              child: const Text('Income'), value: ['Income','Income']),
                          PopupMenuItem<List>(
                              child: const Text('Expense'), value: ['Expense','Expense']),
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
                    (file == null)? Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 100,
                        child: CButton(
                            text: "Browse",
                            backgroundColor: ColorConstants.grey3,
                            onPressed: () { selectFile(); }
                        ),
                      ),
                    ):Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            selectFile();
                          },
                          child: Container(
                            child: Image.file(file!),
                            decoration: BoxDecoration(
                              color: ColorConstants.grey,
                            borderRadius: BorderRadius.circular(16),
                            )
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(fileName, style:
                            TextStyle(fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: ColorConstants.grey3)
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      child: CButton(
                        text: "Add",
                        onPressed: () {
                          saveAndUpload();
                        }
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
          body: CBody(child: content(),hasScrollBody: false,)
        ),
      ),
    );
  }
}