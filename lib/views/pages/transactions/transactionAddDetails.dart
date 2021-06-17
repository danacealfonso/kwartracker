import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/widgets/cBody.dart';
import 'package:kwartracker/views/widgets/cButton.dart';
import 'package:kwartracker/views/widgets/cDatePickerTextField.dart';
import 'package:kwartracker/views/widgets/cDropdownTextField.dart';
import 'package:kwartracker/views/widgets/cTextField.dart';
import '../../widgets/headerNav.dart';

class TransactionAddDetailsPage extends StatefulWidget {
  @override
  _TransactionAddDetailsPageState createState() => _TransactionAddDetailsPageState();
}

class _TransactionAddDetailsPageState extends State<TransactionAddDetailsPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late final String fName;
  late final String fType;
  late final String fCategory;
  late final String fDate;
  late final String fPhoto;
  late final String fPersonName;
  var txtAmount = TextEditingController();
  var actionButtons = [
    TextButton(
        onPressed: () {  },
        child: Text(""),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                  textAlign: TextAlign.center,
                  controller: txtAmount,
                ),),
                CTextField(
                  hintText: "Enter transaction name",
                  label: "Transaction name",
                  onChanged: (value) {
                    fName = value;
                  },
                ),
                CDropdownTextField(
                  hintText: "Select transaction type",
                  label: "Transaction type",
                  onChanged: (value) {
                    fType = value;
                  },
                  items: [
                    PopupMenuItem<String>(
                        child: const Text('Salary'), value: 'Salary'),
                    PopupMenuItem<String>(
                        child: const Text('Bills'), value: 'Bills'),
                    PopupMenuItem<String>(
                        child: const Text('Shopping'), value: 'Shopping'),
                  ]
                ),
                CDropdownTextField(
                  hintText: "Select Category",
                  label: "Category",
                  onChanged: (value) {
                    fCategory = value;
                  },
                  items: [
                    PopupMenuItem<String>(
                        child: const Text('Category1'), value: 'Salary'),
                    PopupMenuItem<String>(
                        child: const Text('Category2'), value: 'Bills'),
                    PopupMenuItem<String>(
                        child: const Text('Category3'), value: 'Shopping'),
                  ]
                ),
                CDatePickerTextField(
                    hintText: "Select Category",
                    initialValue: "DD / MM / YYYY",
                    label: "Select date",
                    onChanged: (value) {
                      fDate = value;
                    },
                    items: [
                      PopupMenuItem<String>(
                          child: const Text('Category1'), value: 'Salary'),
                      PopupMenuItem<String>(
                          child: const Text('Category2'), value: 'Bills'),
                      PopupMenuItem<String>(
                          child: const Text('Category3'), value: 'Shopping'),
                    ]
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
                      _firestore.collection("transactions").add({
                        'userID' : _auth.currentUser!.uid,
                        'amount' : txtAmount.text,
                        'name' : fName,
                        'type' : "fdsaf",
                        'category' : "asdfas",
                        'fDate' : "asdfadsf",
                        'spentPerson' : fPersonName
                      });
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