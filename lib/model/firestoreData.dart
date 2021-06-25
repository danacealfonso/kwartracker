import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  var walletType = [];
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

      var categoriesQuery = _fireStore.collection("categories")
          .where("uID", isEqualTo: _auth.currentUser!.uid)
          .orderBy("name");
      await categoriesQuery.get().then((documentSnapshot) {
        categoriesList.clear();
        if (documentSnapshot.docs.length > 0) {
          for (var category in documentSnapshot.docs) {
            String categoryName = category.data()["name"];
            String categoryID = category.id;
            categoriesList.add({
              "id": categoryID,
              "name":categoryName,
            });
          }
        }
      });

      var walletTypeQuery = _fireStore.collection("walletType");

      await walletTypeQuery.get().then((snapshot) {
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

      var walletsQuery = _fireStore.collection("wallets")
          .where("uID", isEqualTo: _auth.currentUser!.uid);

      await walletsQuery.get().then((snapshot) {
        walletsList.clear();
        walletIDs.clear();
        overallBalance.clear();
        for (var wallet in snapshot.docs) {
          String walletName = wallet.data()["name"];
          String walletTypeID = wallet.data()["type"];
          String walletCurrency = wallet.data()["currency"];
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
          walletIDs.add(wallet.id);
          overallBalance.add(wallet.data()["overallBalance"]);
          if(walletTypeName!.toLowerCase() == "goal") walletType.add(true);
          else walletType.add(false);

          walletsList.add({
            "id": wallet.id,
            "color": walletColor,
            "type": walletTypeName,
            "currency": walletCurrency,
            "name":walletName,
            "amount": 0.00
          });
        }
      });

      var qryTrans = _fireStore
          .collection('transactions')
          .where("uID", isEqualTo: uID);

      await qryTrans.get().then((documentSnapshot) {
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
            String categoryName = "";
            String walletTransactionID = transaction.data()['wallet'];
            String transactionType = transaction.data()['type'];

            for (var wallet in walletsList) {
              if (wallet["id"] == walletTransactionID) {
                currency = wallet["currency"];
                break;
              }
            }
            for (var category in categoriesList) {
              if (category["id"] == transaction.data()['category']) {
                categoryName = category["name"];
                break;
              }
            }
            Timestamp t = transaction.data()['fDate'];
            DateTime d = t.toDate();
            double amount = double.parse(transaction.data()['amount'].toString());

            transactionList.add({
              "amount": amount,
              "walletName": transaction.data()['name'],
              "category": categoryName,
              "walletID": walletTransactionID,
              "currency": currency,
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
    required File file,
    required DateTime transDate,
  }) async {
    showSpinner = true;
    final path = file.path;
    final ext = p.extension(path);
    final String fileName = DateTime.now().toString();
    final destination = 'images/transactions/$fileName.$ext';
    try{
      await FirebaseStorage.instance.ref(destination)
        .putFile(file).whenComplete(() => {
        _fireStore.collection("transactions").add({
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
        }).then((value) {
            showSpinner = false;
            var count = 0;
            getData(context: context);
            Navigator.popUntil(context, (route) {
              return count++ == 2;
            });
        })
      });
    } catch (e) {
      showSpinner = false;
    }
  }
}