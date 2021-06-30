import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/widgets/cDialog.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/views/widgets/cCardWallets.dart';

class FirestoreData extends ChangeNotifier {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var walletIDs = [];
  bool resetState = false;
  double totalAmount = 0;
  DocumentSnapshot? _lastVisible;
  bool isLoading = true;
  bool showSpinner = false;
  List transactionList = [];
  List overallBalance = [];
  List<Map<String, dynamic>> walletIDAmount = [];
  List<Map<String, dynamic>> walletsList = [];
  List<Map<String, dynamic>> categoriesList = [];
  List<Map<String, dynamic>> walletTypeData = [];
  List<Map<String, dynamic>> currenciesList = [];

  Future<Map<String, dynamic>> getTransaction(String transactionID) async {
    Map<String, dynamic> transaction = Map<String, dynamic>();
    String photo = "";
    String currencyID = 'php';
    await _fireStore.collection('transactions')
      .doc(transactionID)
      .get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        transaction = documentSnapshot.data()!;

        var walletIndex = walletsList.indexWhere((element) =>
        element["id"] == documentSnapshot.data()!["wallet"]);
        String walletName = walletsList[walletIndex]["name"];
        transaction.addAll({"walletName": walletName});

        var categoryIndex = categoriesList.indexWhere((element) =>
        element["id"] == documentSnapshot.data()!["category"]);
        String categoryName = categoriesList[categoryIndex]["name"];
        photo = documentSnapshot.data()!["photo"];

        transaction.addAll({"categoryName": categoryName});
        transaction.addAll({"categoryIcon": categoriesList[categoryIndex]["icon"]});
        var fileName = "";
        if(documentSnapshot.data()!["photo"] != null) {
          var completePath = documentSnapshot.data()!["photo"];
          var fileName = (completePath
              .split('/')
              .last);
          transaction.addAll({"photo": completePath});
        }
        transaction.addAll({"fileName": fileName});
        String stringAmount = NumberFormat
          .currency(customPattern: '#,###.##')
          .format(documentSnapshot.data()!["amount"]);
        transaction.addAll({"stringAmount": stringAmount});

        for (var wallet in walletsList) {
          if (wallet["id"] == documentSnapshot.data()!["wallet"]) {
            currencyID = wallet["currencyID"];
            break;
          }
        }
        var currencyIndex = currenciesList.indexWhere((element) =>
        element["id"] == currencyID);
        String currencySign = currenciesList[currencyIndex]["sign"];
        transaction.addAll({"currencySign": currencySign});
      }
    });

    if(photo != null)
    {
      final ref = FirebaseStorage.instance
          .ref()
          .child(photo);
      try {
        await ref.getDownloadURL().then((url) {
          transaction.addAll({"photoURL": url});
        });
      } catch(e) {}
    }else{
      transaction.addAll({"photoURL": ""});
    }


    return transaction;
  }

  Future<void> getData({String walletID = "",
    required BuildContext context}) async {
    if(_auth.currentUser != null) {
      isLoading = true;
      if(transactionList.isEmpty) _lastVisible = null;
      var query;
      String uID = _auth.currentUser!.uid;
      List<Map<String, dynamic>> colorData = [];

      for (CardColor cColor in CardColor.values) {
        var cColorLast = cColor.toString().split('.').last;
        colorData.add({
          "color": cColorLast,
          "cardColor": cColor,
        });
      }

      await _fireStore.collection("categories")
        .where("uID", isEqualTo: _auth.currentUser!.uid)
        .orderBy("name").get().then((documentSnapshot) {
        categoriesList.clear();
        if (documentSnapshot.docs.length > 0) {
          for (var category in documentSnapshot.docs) {
            String categoryName = category.data()["name"];
            String icon = category.data()["icon"];
            String categoryID = category.id;
            categoriesList.add({
              "id": categoryID,
              "name":categoryName,
              "icon": icon
            });
          }
        }
      });

      await _fireStore.collection("walletType")
        .get().then((snapshot) {
        walletTypeData.clear();
        for (var walletType in snapshot.docs) {
          String walletTypeName = walletType.data()["name"];
          String walletTypeId = walletType.id;
          String walletTypeColor = walletType.data()["colorName"];
          walletTypeData.add({
            "id": walletTypeId,
            "color": walletTypeColor,
            "name":walletTypeName,
          });
        }
      });

      await _fireStore.collection("currencies")
        .get().then((snapshot) {
        currenciesList.clear();
        for (var currency in snapshot.docs) {
          String name = currency.data()["name"];
          String id = currency.id;
          String sign = currency.data()["sign"];
          currenciesList.add({
            "id": id,
            "sign": sign,
            "name":name
          });
        }
      });

      await _fireStore.collection("wallets")
        .where("uID", isEqualTo: _auth.currentUser!.uid)
        .get().then((snapshot) {
        walletsList.clear();
        walletIDs.clear();
        overallBalance.clear();
        for (var wallet in snapshot.docs) {
          String walletName = wallet.data()["name"];
          String walletTypeID = wallet.data()["type"];
          String walletCurrencyID = wallet.data()["currency"];
          bool overAllBalance = wallet.data()["overAllBalance"];
          String savedTo = wallet.data()["savedTo"];
          double targetAmount = wallet.data()["targetAmount"];
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
          if(walletCurrencyID != null){
            var currencyIndex = currenciesList.indexWhere((element) =>
            element["id"] == walletCurrencyID);
            String walletCurrency = currenciesList[currencyIndex]["name"];
            String currencySign = currenciesList[currencyIndex]["sign"];

            overallBalance.add(wallet.data()["overallBalance"]);
            walletIDs.add(wallet.id);
            walletsList.add({
              "id": wallet.id,
              "color": walletColor,
              "type": walletTypeName,
              "typeID": walletTypeID,
              "currency": walletCurrency,
              "currencyID": walletCurrencyID,
              "currencySign": currencySign,
              "name": walletName,
              "overAllBalance": overAllBalance != null ? overAllBalance : false,
              "savedTo": savedTo != null ? savedTo : "",
              "amount": 0.00,
              "targetAmount": targetAmount != null ? targetAmount : 0.00,
            });
          }
        }
      });

      await _fireStore.collection('transactions')
        .where("uID", isEqualTo: uID).
        get().then((documentSnapshot) {
        if (documentSnapshot.docs.length > 0) {
          for (var transaction in documentSnapshot.docs) {
            String walletTransactionID = transaction.data()['wallet'];
            String transactionType = transaction.data()['type'];
            double amount =
            double.parse(transaction.data()['amount'].toString());

            var walletsListIndex = walletsList
                .indexWhere((element) => element["id"] == walletTransactionID);

            if (transactionType.toLowerCase() == "income")
              walletsList[walletsListIndex]["amount"] += amount;
            else
              walletsList[walletsListIndex]["amount"] -= amount;
          }
        }
      });

      if (_lastVisible == null) {
        query = (walletID.isEmpty)? _fireStore
            .collection('transactions')
            .where("uID", isEqualTo: uID)
            .orderBy('created_at', descending: true)
            .limit(20)
            : _fireStore
            .collection('transactions')
            .where("wallet", isEqualTo: walletID)
            .where("uID", isEqualTo: uID)
            .orderBy('created_at', descending: true)
            .limit(20);
      } else {
        query = (walletID.isEmpty)? _fireStore.collection('transactions')
            .where("uID", isEqualTo: uID)
            .orderBy('created_at', descending: true)
            .startAfterDocument(_lastVisible!)
            .limit(20)
            : _fireStore.collection('transactions')
            .where("wallet", isEqualTo: walletID)
            .where("uID", isEqualTo: uID)
            .orderBy('created_at', descending: true)
            .startAfterDocument(_lastVisible!)
            .limit(20);
      }

      await query.get().then((documentSnapshot) {
        if (documentSnapshot.docs.length > 0) {
          _lastVisible = documentSnapshot.docs[documentSnapshot.docs.length-1];
          for (var transaction in documentSnapshot.docs) {
            String currency = "";
            String currencyID = "";
            String categoryName = "";
            String categoryID = "";
            String walletID = transaction.data()['wallet'];
            String transactionType = transaction.data()['type'];

            for (var wallet in walletsList) {
              if (wallet["id"] == walletID) {
                currency = wallet["currency"];
                currencyID = wallet["id"];
                break;
              }
            }
            for (var category in categoriesList) {
              if (category["id"] == transaction.data()['category']) {
                categoryName = category["name"];
                categoryID = category["id"];
                break;
              }
            }
            Timestamp t = transaction.data()['fDate'];
            DateTime d = t.toDate();
            double amount = double.parse(transaction.data()['amount'].toString());

            transactionList.add({
              "transactionID": transaction.id,
              "amount": amount,
              "walletName": transaction.data()['name'],
              "walletID": walletID,
              "category": categoryName,
              "categoryID": categoryID,
              "currency": currency,
              "currencyID": currencyID,
              "transactionType": transactionType,
              "transactionDate": d,
            });
          }
        } else {
          ScaffoldMessenger.of(context)
            .showSnackBar( SnackBar(
            content: Text("No transaction data to load."),
            duration: Duration(milliseconds: 1000),
          ), );
        }
      });
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveTransaction({
    required BuildContext context,
    required String walletID,
    required double amount,
    required String transName,
    required String transType,
    required String catID,
    required String spentPerson,
    String? fPhoto,
    File? file,
    required DateTime transDate,
    String transID = ""
  }) async {
    showSpinner = true;
    Map<String,dynamic> trans = {};
    String destination = "";
    var query;
    try{
      if(file != null) {
        final path = file.path;
        final ext = p.extension(path);
        final String fileName = DateTime.now().toString();
        destination = 'images/transactions/$fileName$ext';
        await FirebaseStorage.instance.ref(destination)
          .putFile(file).whenComplete((){
          trans = {
            'uID' : _auth.currentUser!.uid,
            'wallet' : walletID,
            'amount' : amount,
            'name' : transName,
            'type' : transType,
            'category' : catID,
            'fDate' : transDate,
            'spentPerson' : spentPerson,
            'photo' : destination,
            'created_at': FieldValue.serverTimestamp()
          };
        });
      } else {
        trans = {
          'uID' : _auth.currentUser!.uid,
          'wallet' : walletID,
          'amount' : amount,
          'name' : transName,
          'type' : transType,
          'category' : catID,
          'fDate' : transDate,
          'photo' : fPhoto,
          'spentPerson' : spentPerson,
          'created_at': FieldValue.serverTimestamp()
          };
      }

      if(transID.isNotEmpty)
        query = _fireStore.collection("transactions").doc(transID).set(trans);
      else
        query = _fireStore.collection("transactions").add(trans);
      await query.then((value) {
        var count = 0;
        Navigator.popUntil(context, (route) {
          return count++ == 2;
        });
        showSpinner = false;
        cDialog(
          context,
          "Success",
          (transID.isEmpty)? "It has been successfully added.":
          "It has been successfully saved.",
          "Cool",
          Icon(
            Icons.check_circle, size: 80,
            color: ColorConstants.cyan,
          )
        );
      });
    } catch (e) {
      print("test $e");
      showSpinner = false;
    }

  }

  Future<void> saveWallet({
    required BuildContext context,
    String? walletID,
    double? targetAmount,
    String? walletName,
    String? walletTypeID,
    bool? overAllBalance,
    String? walletCurrency,
    String? savedTo,
  }) async {
    showSpinner = true;
    try{
      var query;
      var wallet = {
        'uID': _auth.currentUser!.uid,
        'name': walletName,
        'currency': walletCurrency,
        'type': walletTypeID,
        'targetAmount': targetAmount,
        'overAllBalance': overAllBalance,
        'savedTo': savedTo,
        'created_at': FieldValue.serverTimestamp()
      };
      if(walletID!.isNotEmpty)
        query = _fireStore.collection("wallets").doc(walletID).set(wallet);
      else
        query = _fireStore.collection("wallets").add(wallet);
      await query.then((value) {
        showSpinner = false;
        Navigator.pop(context);
        cDialog(context,"Success",
          (walletID.isEmpty)? "It has been successfully added.":
          "It has been successfully saved.",
          "Cool",
          Icon(
            Icons.check_circle, size: 80,
            color: ColorConstants.cyan,
          )
        );
      });
    } catch (e) {
      print(e);
      showSpinner = false;
    }

  }
}