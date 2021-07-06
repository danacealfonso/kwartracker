// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:kwartracker/provider/firestore_data.dart';
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/views/widgets/confirmation_dialog.dart';
import 'package:kwartracker/views/widgets/custom_body.dart';
import 'package:kwartracker/views/widgets/custom_button.dart';
import 'package:kwartracker/views/widgets/custom_dropdown.dart';
import 'package:kwartracker/views/widgets/custom_text_field.dart';
import 'package:kwartracker/views/widgets/date_picker_text_field.dart';
import '../../widgets/header_nav.dart';

class TransactionEditPage extends StatefulWidget {
  const TransactionEditPage(this.transactionID);
  final String? transactionID;

  @override
  _TransactionEditPageState createState() => _TransactionEditPageState();
}

class _TransactionEditPageState extends State<TransactionEditPage> {
  bool enableSaveButton = false;
  String fName = '';
  String fType = '';
  String fCategory = '';
  String fCategoryID = '';
  String fWalletID = '';
  String fWallet = '';
  String fAmount = '';
  String fPersonName = '';
  File? file;
  String fDate = '';
  String fPhoto = '';
  Map<String, dynamic> transaction = <String, dynamic>{};
  List<PopupMenuEntry<dynamic>> categoryList = <PopupMenuEntry<dynamic>>[];
  List<PopupMenuEntry<dynamic>> walletsList = <PopupMenuEntry<dynamic>>[];
  TextEditingController conAmount = TextEditingController();
  TextEditingController conPersonName = TextEditingController();

  bool validateFields() {
    bool validate = true;
    if (fWallet.isEmpty == true) {
      validate = false;
    }
    if (conAmount.text.isEmpty == true) {
      validate = false;
    }
    if (fType.isEmpty == true) {
      validate = false;
    }
    if (fCategory.isEmpty == true) {
      validate = false;
    }
    if (widget.transactionID == null) {
      validate = false;
    }

    if (validate == true) {
      setState(() {
        enableSaveButton = true;
      });
    }
    return validate;
  }

  DateTime _date = DateTime.now();
  Future<void> _selectDate() async {
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

  Future<void> selectFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result != null) {
      final String path = result.files.single.path!;
      setState(() => file = File(path));
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill up all the fields.'),
          duration: Duration(milliseconds: 2000),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    Provider.of<FirestoreData>(context, listen: false)
        .getTransaction(widget.transactionID!)
        .then((Map<String, dynamic> value) {
      fWallet = (value['walletName'] != null) ? value['walletName'] : '';
      fWalletID = (value['wallet'] != null) ? value['wallet'] : '';
      conAmount.text = value['amount'].toString();
      fType = value['type'];
      fName = value['name'];
      fCategoryID = value['category'];
      fCategory = value['categoryName'];
      fPhoto = value['photo'];
      conPersonName.text = value['spentPerson'];
      if (value['fDate'] != null) {
        final Timestamp t = value['fDate'];
        _date = t.toDate();
      }

      if (mounted) {
        setState(() {
          transaction = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    validateFields();
    final String fileName = file != null ? file!.path.split('/').last : '';
    final List<Widget> actionButtons = <Widget>[
      TextButton(
        onPressed: () {
          if (enableSaveButton == true) {
            confirmationDialog(context, 'Are you sure you want to update this?',
                () {
              saveAndUpload();
            });
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

    Widget title() {
      return const Text(
        'Edit Transaction',
      );
    }

    Widget content() {
      return Consumer<FirestoreData>(builder:
          (BuildContext context, FirestoreData firestoreData, Widget? child) {
        categoryList = firestoreData.categoriesList.map((dynamic item) {
          return PopupMenuItem<dynamic>(
              child: Container(width: 500, child: Text(item['name'])),
              value: <dynamic>[item['id'], item['name']]);
        }).toList();

        walletsList = firestoreData.walletsList.map((dynamic item) {
          return PopupMenuItem<dynamic>(
              child: Text(item['name']),
              value: <dynamic>[item['id'], item['name']]);
        }).toList();

        return Container(
          margin: const EdgeInsets.only(top: 30),
          child: ListView(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
              children: <Widget>[
                CustomDropdown(
                    label: 'Which wallet do you want it to add?',
                    hintText: 'Select wallet to add',
                    text: fWallet,
                    onChanged: (dynamic value) {
                      if (value != null) {
                        setState(() {
                          fWallet = value[1];
                          fWalletID = value[0];
                        });
                      }
                    },
                    items: walletsList),
                CustomTextField(
                  hintText: 'Enter transaction amount',
                  label: 'Transaction amount',
                  controller: conAmount,
                  onChanged: (dynamic value) {
                    fAmount = value;
                  },
                ),
                CustomDropdown(
                    label: 'Transaction type',
                    hintText: 'Select transaction type',
                    text: fType,
                    onChanged: (dynamic value) {
                      if (value != null) {
                        setState(() {
                          fType = value[1];
                        });
                      }
                    },
                    items: const <PopupMenuEntry<dynamic>>[
                      PopupMenuItem<dynamic>(
                          child: Text('Income'),
                          value: <String>['Income', 'Income']),
                      PopupMenuItem<dynamic>(
                          child: Text('Expense'),
                          value: <String>['Expense', 'Expense']),
                    ]),
                CustomDropdown(
                    label: 'Category',
                    hintText: 'Select Category',
                    text: fCategory.toString(),
                    onChanged: (dynamic value) {
                      if (value != null) {
                        setState(() {
                          fCategory = value[1];
                          fCategoryID = value[0];
                        });
                      }
                    },
                    items: categoryList),
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    _selectDate.call();
                  },
                  child: DatePickerTextField(
                      hintText: 'Select Date',
                      label: 'Select date',
                      text: _date.toString(),
                      onChanged: (dynamic value) {
                        _date = value;
                      },
                      items: const <PopupMenuEntry<PopupMenuItem<dynamic>>>[]),
                ),
                CustomTextField(
                  label: 'Spent with this person',
                  hintText: 'Enter name of person',
                  controller: conPersonName,
                  onChanged: (dynamic value) {
                    fPersonName = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: const Text(
                          'Upload photo',
                          style:
                              TextStyle(color: Color(0xFFBBC3C9), fontSize: 12),
                        ),
                      )),
                ),
                if (transaction['photoURL'] != null)
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 190,
                      decoration: BoxDecoration(
                        color: ColorConstants.grey,
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(transaction['photoURL']!),
                        ),
                      )),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 100,
                    child: CustomButton(
                        text: 'Replace',
                        backgroundColor: ColorConstants.grey3,
                        onPressed: () {
                          selectFile();
                        }),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(fileName,
                      style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: ColorConstants.grey3)),
                ),
              ]),
        );
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
              child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F3F6),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  child: content()),
              hasScrollBody: true,
            )),
      ),
    );
  }
}
