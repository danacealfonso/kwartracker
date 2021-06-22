import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cButton.dart';
import 'package:kwartracker/views/widgets/cDatePickerTextField.dart';
import 'package:kwartracker/views/widgets/cDropdownTextField.dart';
import 'package:kwartracker/views/widgets/cTextField.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/services.dart';
import '../../widgets/headerNav.dart';

class TransactionAddDetailsPage extends StatefulWidget {
  final String? walletID;
  TransactionAddDetailsPage(this.walletID);

  @override
  _TransactionAddDetailsPageState createState() => _TransactionAddDetailsPageState();
}

class _TransactionAddDetailsPageState extends State<TransactionAddDetailsPage> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String fName = "";
  String fType = "";
  String fCategory = "";
  String fCategoryID = "";
  bool enableAddButton = false;
  bool showSpinner = false;
  String fPersonName = "";
  late final String fDate;
  late final String fPhoto;
  final categoryList = <PopupMenuEntry>[];
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

    if (validate == true)
      enableAddButton = true;

    return validate;
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<Null> _getData() async {
    categoryList.clear();
    var categoriesStream = _fireStore.collection("categories")
        .where("uID", isEqualTo: _auth.currentUser!.uid)
        .orderBy("name")
        .snapshots();

    categoriesStream.listen((snapshot) {
      for (var category in snapshot.docs) {
        String categoryName = category.data()["name"];
        String categoryID = category.id;

        List value = [categoryID, categoryName];

        categoryList.add(PopupMenuItem<List>(
            child: Text(categoryName), value: value)
        );
      }
    });

    return null;
  }

  DateTime _date = DateTime(2020, 11, 17);

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

  @override
  Widget build(BuildContext context) {
    _getData();
    Widget title() {
      return Text(
        "Add Transaction",
      );
    }

    Widget content() {
      return Container(
        padding: const EdgeInsets.fromLTRB(30,30,30,0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: Text("Enter amount"),),
              Center(child: TextField(
                autofocus: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
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
                padding: EdgeInsets.fromLTRB(0, 10, 0, 7),
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
              CButton(
                text: "Browse",
                backgroundColor: ColorConstants.grey3,
                onPressed: () {}
              ),
              Container(
                width: double.infinity,
                child: CButton(
                  text: "Add",
                  onPressed: () {
                    if (validateFields() == true) {
                      setState(() => showSpinner = true);
                      try{
                        _fireStore.collection("transactions").add({
                          'uID' : _auth.currentUser!.uid,
                          'wallet' : widget.walletID,
                          'amount' : txtAmount.text,
                          'name' : fName,
                          'type' : fType,
                          'category' : fCategoryID,
                          'fDate' : _date,
                          'spentPerson' : fPersonName,
                          'created_at': FieldValue.serverTimestamp()
                        }).then((value) {
                          setState(() {
                            showSpinner = false;
                            Navigator.of(context).popUntil(
                                ModalRoute.withName('/transactions')
                            );
                          });
                        });
                      } catch (e) {
                        setState(() => showSpinner = false);
                      }
                    }
                  }
                ),
              ),
            ]
          ),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          backgroundColor: Color(0xFF03BED6),
          appBar: headerNav(
            title: title(),
            action: actionButtons
          ),
          body: CBody(child: content())
        ),
      ),
    );
  }
}