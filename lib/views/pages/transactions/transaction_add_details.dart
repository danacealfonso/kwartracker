// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:kwartracker/provider/firestore_data.dart';
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/views/widgets/custom_body.dart';
import 'package:kwartracker/views/widgets/custom_button.dart';
import 'package:kwartracker/views/widgets/custom_dropdown.dart';
import 'package:kwartracker/views/widgets/custom_text_field.dart';
import 'package:kwartracker/views/widgets/date_picker_text_field.dart';
import '../../widgets/header_nav.dart';

class TransactionAddDetailsPage extends StatefulWidget {
  const TransactionAddDetailsPage(this.walletID);
  final String? walletID;

  @override
  _TransactionAddDetailsPageState createState() =>
      _TransactionAddDetailsPageState();
}

class _TransactionAddDetailsPageState extends
  State<TransactionAddDetailsPage> {
  String fName = '';
  String fType = '';
  String fCategory = '';
  String fCategoryID = '';
  bool enableAddButton = false;
  String fPersonName = '';
  File? file;
  late final String fDate;
  late final String fPhoto;
  List<PopupMenuEntry<dynamic>> categoryList = <PopupMenuEntry<dynamic>>[];
  TextEditingController txtAmount = TextEditingController();
  List<Widget> actionButtons = <Widget>[
    TextButton(
        onPressed: () {  },
        child: const Text(''),
    ),
  ];

  bool validateFields () {
    bool validate = true;
    if(fName.isEmpty==true) {
      validate = false;
    }if(fType.isEmpty==true) {
      validate = false;
    }if(fCategory.isEmpty==true) {
      validate = false;
    }if(txtAmount.text.isEmpty==true) {
      validate = false;
    }if(file==null) {
      validate = false;
    }if(fName.isEmpty==true) {
      validate = false;
    }if(widget.walletID==null) {
      validate = false;
    }

    if (validate == true) {
      setState(() {
        enableAddButton = true;
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar( const SnackBar(
        content: Text('Please fill up all the fields.'),
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
    final FilePickerResult? result = await FilePicker
      .platform.pickFiles(
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
        .showSnackBar( const SnackBar(
        content: Text('Please fill up all the fields.'),
        duration: Duration(milliseconds: 2000),
      ), );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String fileName = file != null ? file!.path.split('/').last : '';

    Widget title() {
      return const Text(
        'Add Transaction',
      );
    }

    Widget content() {
      return Consumer<FirestoreData>(
          builder: (BuildContext context,
              FirestoreData firestoreData,
              Widget? child) {
            categoryList = firestoreData.categoriesList.map(
              (Map<String, dynamic> item) {
              return PopupMenuItem<dynamic>(
                  child: Text(item['name']),
                  value: <dynamic>[item['id'], item['name']]
              );
            }).toList();

            return Container(
              margin: const EdgeInsets.only(top: 30),
              child: ListView(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                  children: <Widget>[
                    const Center(child: Text('Enter amount'),),
                    Center(child: TextField(
                        autofocus: true,
                        keyboardType: const TextInputType
                          .numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 40,
                            color: ColorConstants.black
                        ),
                        controller: txtAmount,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        )
                    ),),
                    CustomTextField(
                      hintText: 'Enter transaction name',
                      label: 'Transaction name',
                      onChanged: (dynamic value) {
                        fName = value;
                      },
                    ),
                    CustomDropdown(
                        label: 'Transaction type',
                        hintText: 'Select transaction type',
                        text: fType,
                        onChanged: (dynamic value) {
                          if (value != null ) {
                            setState(() {
                              fType = value[1];
                            });
                          }
                        },
                        items: const <PopupMenuEntry<dynamic>>[
                          PopupMenuItem<dynamic>(
                              child: Text('Income'),
                              value: <String>['Income','Income']),
                          PopupMenuItem<dynamic>(
                              child: Text('Expense'),
                              value: <String>['Expense','Expense']),
                        ]
                    ),
                    CustomDropdown(
                        label: 'Category',
                        hintText: 'Select Category',
                        text: fCategory.toString(),
                        onChanged: (dynamic value) {
                          if (value != null ) {
                            setState(() {
                              fCategory = value[1];
                              fCategoryID = value[0];
                            });
                          }
                        },
                        items: categoryList
                    ),
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
                          items:
                          const <PopupMenuEntry<PopupMenuItem<dynamic>>>[]
                      ),
                    ),
                    CustomTextField(
                      label: 'Spent with this person',
                      hintText: 'Enter name of person',
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
                              style: TextStyle(
                                  color: Color(0xFFBBC3C9),
                                  fontSize: 12
                              ),
                            ),
                          )
                      ),
                    ),
                    if (file == null) Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 100,
                        child: CustomButton(
                            text: 'Browse',
                            backgroundColor: ColorConstants.grey3,
                            onPressed: () { selectFile(); }
                        ),
                      ),
                    ) else Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            selectFile();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            decoration: BoxDecoration(
                              color: ColorConstants.grey,
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(file!),
                              ),
                            )
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(fileName, style:
                            const TextStyle(fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: ColorConstants.grey3)
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Add',
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
          backgroundColor: const Color(0xFF03BED6),
          appBar: headerNav(
            title: title(),
            action: actionButtons
          ),
          body: CustomBody(child: content(),hasScrollBody: true,)
        ),
      ),
    );
  }
}
