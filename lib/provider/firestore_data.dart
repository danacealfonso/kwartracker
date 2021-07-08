// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

// Project imports:
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/views/widgets/card_wallets.dart';
import 'package:kwartracker/views/widgets/custom_dialog.dart';
import 'package:kwartracker/model/category_model.dart';

class FirestoreData extends ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? uID;
  double totalAmount = 0;
  DocumentSnapshot<dynamic>? _lastVisible;
  bool isLoading = true;
  bool showSpinner = false;
  bool resetState = false;
  List<String> walletIDs = <String>[];
  List<dynamic> overallBalance = <dynamic>[];
  List<Map<String, dynamic>> walletIDAmount = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> walletsList = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> categoriesList = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> categoriesParent = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> categoriesChild = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> walletTypeData = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> currenciesList = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> colorData = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> transactionList = <Map<String, dynamic>>[];

  Future<Map<String, dynamic>> getTransaction(String transactionID) async {
    Map<String, dynamic> transaction = <String, dynamic>{};
    String? photo;
    String currencyID = 'php';
    await _fireStore
        .collection('transactions')
        .doc(transactionID)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
      if (documentSnapshot.exists) {
        transaction = documentSnapshot.data()!;

        final int walletIndex = walletsList.indexWhere(
            (Map<String, dynamic> element) =>
                element['id'] == documentSnapshot.data()!['wallet']);
        final String walletName = walletsList[walletIndex]['name'];
        transaction.addAll(<String, dynamic>{'walletName': walletName});

        final int categoryIndex = categoriesList.indexWhere(
            (Map<String, dynamic> element) =>
                element['id'] == documentSnapshot.data()!['category']);
        final String categoryName = categoriesList[categoryIndex]['name'];
        photo = documentSnapshot.data()!['photo'];

        transaction.addAll(<String, dynamic>{'categoryName': categoryName});
        transaction.addAll(<String, dynamic>{
          'categoryIcon': categoriesList[categoryIndex]['icon']
        });
        const String fileName = '';
        if (documentSnapshot.data()!['photo'] != null) {
          final String completePath = documentSnapshot.data()!['photo'];
          transaction.addAll(<String, dynamic>{'photo': completePath});
        }
        transaction.addAll(<String, dynamic>{'fileName': fileName});
        final String stringAmount =
            NumberFormat.currency(customPattern: '#,###.##')
                .format(documentSnapshot.data()!['amount']);
        transaction.addAll(<String, dynamic>{'stringAmount': stringAmount});

        for (final Map<String, dynamic> wallet in walletsList) {
          if (wallet['id'] == documentSnapshot.data()!['wallet']) {
            currencyID = wallet['currencyID'];
            break;
          }
        }
        final int currencyIndex = currenciesList.indexWhere(
            (Map<String, dynamic> element) => element['id'] == currencyID);
        final String currencySign = currenciesList[currencyIndex]['sign'];
        transaction.addAll(<String, dynamic>{'currencySign': currencySign});
      }
    });

    if (photo != null) {
      final Reference ref = FirebaseStorage.instance.ref().child(photo!);
      try {
        await ref.getDownloadURL().then((String url) {
          transaction.addAll(<String, dynamic>{'photoURL': url});
        });
      } catch (e) {
        print(e);
      }
    } else {
      transaction.addAll(<String, dynamic>{'photoURL': ''});
    }

    return transaction;
  }

  Future<List<Map<String, dynamic>>> getWalletType() async {
    await _fireStore
        .collection('walletType')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      walletTypeData.clear();
      for (final QueryDocumentSnapshot<Map<String, dynamic>> walletType
          in snapshot.docs) {
        final String walletTypeName = walletType.data()['name'];
        final String walletTypeId = walletType.id;
        final String walletTypeColor = walletType.data()['colorName'];
        walletTypeData.add(<String, dynamic>{
          'id': walletTypeId,
          'color': walletTypeColor,
          'name': walletTypeName,
        });
      }
    });

    return walletTypeData;
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    await _fireStore
        .collection('categories')
        .where('uID', isEqualTo: _auth.currentUser!.uid)
        .orderBy('parentID')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> documentSnapshot) {
      if (documentSnapshot.docs.isNotEmpty) {
        categoriesParent.clear();
        categoriesChild.clear();
        categoriesList.clear();
        for (final QueryDocumentSnapshot<Map<String, dynamic>> category
            in documentSnapshot.docs) {
          final String categoryName = category.data()['name'];
          final String categoryID = category.id;

          if (category.data()['parentID'].toString().isEmpty) {
            final Map<String, dynamic> categoryP = category.data();
            categoryP.addAll(<String, dynamic>{'id': categoryID});
            categoriesParent.add(categoryP);
          } else {
            final Map<String, dynamic> categoryC = category.data();
            categoryC.addAll(<String, dynamic>{'id': categoryID});
            categoriesChild.add(categoryC);
          }

          categoriesList.add(<String,dynamic>{
            'id': categoryID,
            'name': categoryName,
            'icon': category.data()['icon']
          });
        }
      }
    });

    return categoriesList;
  }

  Future<List<Map<String, dynamic>>> getCurrencies() async {
    await _fireStore
        .collection('currencies')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      currenciesList.clear();
      for (final QueryDocumentSnapshot<Map<String, dynamic>> currency
          in snapshot.docs) {
        final String name = currency.data()['name'];
        final String id = currency.id;
        final String sign = currency.data()['sign'];
        currenciesList
            .add(<String, dynamic>{'id': id, 'sign': sign, 'name': name});
      }
    });
    return currenciesList;
  }

  Future<List<Map<String, dynamic>>> getWallets() async {
    isLoading = true;
    if (categoriesList.isEmpty) {
      await getCurrencies();
    }
    if (walletTypeData.isEmpty) {
      await getWalletType();
    }

    colorData.clear();
    for (final CardColor cColor in CardColor.values) {
      final String cColorLast = cColor.toString().split('.').last;
      colorData.add(<String, dynamic>{
        'color': cColorLast,
        'cardColor': cColor,
      });
    }

    await _fireStore
        .collection('wallets')
        .where('uID', isEqualTo: _auth.currentUser!.uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      walletsList.clear();
      walletIDs.clear();
      overallBalance.clear();
      for (final QueryDocumentSnapshot<Map<String, dynamic>> wallet
          in snapshot.docs) {
        final String walletName = wallet.data()['name'];
        final String walletTypeID = wallet.data()['type'];
        final String? walletCurrencyID = wallet.data()['currency'];
        final bool? overAllBalance = wallet.data()['overAllBalance'];
        final String? savedTo = wallet.data()['savedTo'];
        final double? targetAmount = wallet.data()['targetAmount'];
        CardColor? walletColor;
        String? walletTypeName = '';

        for (final Map<String, dynamic> walletType in walletTypeData) {
          if (walletTypeID == walletType['id']) {
            final int colorIndex = colorData.indexWhere(
                (Map<String, dynamic> element) =>
                    element['color'] == walletType['color']);

            walletTypeName = walletType['name'];
            walletColor = colorData[colorIndex]['cardColor'];
            break;
          }
        }
        if (walletCurrencyID != null) {
          final int currencyIndex = currenciesList.indexWhere(
              (Map<String, dynamic> element) =>
                  element['id'] == walletCurrencyID);
          final String walletCurrency = currenciesList[currencyIndex]['name'];
          final String currencySign = currenciesList[currencyIndex]['sign'];

          overallBalance.add(wallet.data()['overallBalance']);
          walletIDs.add(wallet.id);
          walletsList.add(<String, dynamic>{
            'id': wallet.id,
            'color': walletColor,
            'type': walletTypeName,
            'typeID': walletTypeID,
            'currency': walletCurrency,
            'currencyID': walletCurrencyID,
            'currencySign': currencySign,
            'name': walletName,
            'overAllBalance': overAllBalance ?? false,
            'savedTo': savedTo ?? '',
            'amount': 0.00,
            'targetAmount': targetAmount ?? 0.00,
          });
        }
      }
    });
    await loadWalletAmount();
    isLoading = false;
    notifyListeners();
    return walletsList;
  }

  Future<void> loadWalletAmount() async {
    await _fireStore
        .collection('transactions')
        .where('uID', isEqualTo: uID)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> documentSnapshot) {
      if (documentSnapshot.docs.isNotEmpty) {
        for (final QueryDocumentSnapshot<Map<String, dynamic>> transaction
            in documentSnapshot.docs) {
          final String walletTransactionID = transaction.data()['wallet'];
          final String transactionType = transaction.data()['type'];
          final double amount =
              double.parse(transaction.data()['amount'].toString());

          final int walletsListIndex = walletsList.indexWhere(
              (Map<String, dynamic> element) =>
                  element['id'] == walletTransactionID);

          if (transactionType.toLowerCase() == 'income') {
            walletsList[walletsListIndex]['amount'] += amount;
          } else {
            walletsList[walletsListIndex]['amount'] -= amount;
          }
        }
      }
    });
  }

  Future<List<Map<String, dynamic>>?> getTransactionList(
      {String walletID = '', required BuildContext context}) async {
    isLoading = true;
    await getWallets();
    if (transactionList.isEmpty) {
      _lastVisible = null;
    }
    uID ??= _auth.currentUser!.uid;
    if (categoriesList.isEmpty) {
      await getCategories();
    }
    if (walletsList.isEmpty) {
      await getWallets();
    }

    Query<Map<String, dynamic>> query;
    if (_lastVisible == null) {
      query = (walletID.isEmpty)
          ? _fireStore
              .collection('transactions')
              .where('uID', isEqualTo: uID)
              .orderBy('created_at', descending: true)
              .limit(20)
          : _fireStore
              .collection('transactions')
              .where('wallet', isEqualTo: walletID)
              .where('uID', isEqualTo: uID)
              .orderBy('created_at', descending: true)
              .limit(20);
    } else {
      query = (walletID.isEmpty)
          ? _fireStore
              .collection('transactions')
              .where('uID', isEqualTo: uID)
              .orderBy('created_at', descending: true)
              .startAfterDocument(_lastVisible!)
              .limit(20)
          : _fireStore
              .collection('transactions')
              .where('wallet', isEqualTo: walletID)
              .where('uID', isEqualTo: uID)
              .orderBy('created_at', descending: true)
              .startAfterDocument(_lastVisible!)
              .limit(20);
    }

    await query.get().then((dynamic documentSnapshot) {
      if (documentSnapshot.docs.length > 0) {
        _lastVisible = documentSnapshot.docs[documentSnapshot.docs.length - 1];
        for (final dynamic transaction in documentSnapshot.docs) {
          String currency = '';
          String currencyID = '';
          String categoryName = '';
          String categoryID = '';
          Map<String, dynamic> categoryIcon = <String, dynamic>{};
          final String walletID = transaction.data()['wallet'];
          final String transactionType = transaction.data()['type'];

          for (final Map<String, dynamic> wallet in walletsList) {
            if (wallet['id'] == walletID) {
              currency = wallet['currency'];
              currencyID = wallet['id'];
              break;
            }
          }
          for (final Map<String, dynamic> category in categoriesList) {
            if (category['id'] == transaction.data()['category']) {
              categoryName = category['name'];
              categoryID = category['id'];
              categoryIcon = category['icon'];
              break;
            }
          }
          final Timestamp t = transaction.data()['fDate'];
          final DateTime d = t.toDate();
          final double amount =
              double.parse(transaction.data()['amount'].toString());

          transactionList.add(<String, dynamic>{
            'transactionID': transaction.id,
            'amount': amount,
            'walletName': transaction.data()['name'],
            'walletID': walletID,
            'category': categoryName,
            'categoryID': categoryID,
            'categoryIcon': categoryIcon,
            'currency': currency,
            'currencyID': currencyID,
            'transactionType': transactionType,
            'transactionDate': d,
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No transaction data to load.'),
            duration: Duration(milliseconds: 1000),
          ),
        );
      }
    });
    isLoading = false;
    notifyListeners();
    return transactionList;
  }

  Future<void> getData({required BuildContext context}) async {
    uID = _auth.currentUser!.uid;
    if (_auth.currentUser != null) {
      isLoading = true;
      if (transactionList.isEmpty) {
        _lastVisible = null;
      }
      await getTransactionList(walletID: '', context: context);
      notifyListeners();
    }
  }

  Future<void> saveTransaction(
      {required BuildContext context,
      required String walletID,
      required double amount,
      required String transName,
      required String transType,
      required String catID,
      required String spentPerson,
      String? fPhoto,
      File? file,
      required DateTime transDate,
      String transID = ''}) async {
    showSpinner = true;
    Map<String, dynamic> trans = <String, dynamic>{};
    String destination = '';

    try {
      if (file != null) {
        final String path = file.path;
        final String ext = p.extension(path);
        final String fileName = DateTime.now().toString();
        destination = 'images/transactions/$fileName$ext';
        await FirebaseStorage.instance
            .ref(destination)
            .putFile(file)
            .whenComplete(() {
          trans = <String, dynamic>{
            'uID': _auth.currentUser!.uid,
            'wallet': walletID,
            'amount': amount,
            'name': transName,
            'type': transType,
            'category': catID,
            'fDate': transDate,
            'spentPerson': spentPerson,
            'photo': destination,
            'created_at': FieldValue.serverTimestamp()
          };
        });
      } else {
        trans = <String, dynamic>{
          'uID': _auth.currentUser!.uid,
          'wallet': walletID,
          'amount': amount,
          'name': transName,
          'type': transType,
          'category': catID,
          'fDate': transDate,
          'photo': fPhoto,
          'spentPerson': spentPerson,
          'created_at': FieldValue.serverTimestamp()
        };
      }

      Future<dynamic> query = _fireStore.collection('transactions').add(trans);

      if (transID.isNotEmpty) {
        query = _fireStore.collection('transactions').doc(transID).set(trans);
      }
      await query.then((dynamic value) {
        int count = 0;
        Navigator.popUntil(context, (Route<dynamic> route) {
          return count++ == 2;
        });
        showSpinner = false;
        customDialog(
            context,
            'Success',
            (transID.isEmpty)
                ? 'It has been successfully added.'
                : 'It has been successfully saved.',
            'Cool',
            const Icon(
              Icons.check_circle,
              size: 80,
              color: ColorConstants.cyan,
            ));
      });
    } catch (e) {
      print('test $e');
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
    try {
      Future<dynamic> query;
      final Map<String, dynamic> wallet = <String, dynamic>{
        'uID': _auth.currentUser!.uid,
        'name': walletName,
        'currency': walletCurrency,
        'type': walletTypeID,
        'targetAmount': targetAmount,
        'overAllBalance': overAllBalance,
        'savedTo': savedTo,
        'created_at': FieldValue.serverTimestamp()
      };
      if (walletID!.isNotEmpty) {
        query = _fireStore.collection('wallets').doc(walletID).set(wallet);
      } else {
        query = _fireStore.collection('wallets').add(wallet);
      }
      await query.then((dynamic value) {
        showSpinner = false;
        Navigator.pop(context);
        customDialog(
            context,
            'Success',
            (walletID.isEmpty)
                ? 'It has been successfully added.'
                : 'It has been successfully saved.',
            'Cool',
            const Icon(
              Icons.check_circle,
              size: 80,
              color: ColorConstants.cyan,
            ));
      });
    } catch (e) {
      print(e);
      showSpinner = false;
    }
  }

  Future<void> saveCategory({
    required BuildContext context,
    String categoryID = '',
    String categoryName = '',
    Map<String, dynamic>? categoryIcon,
    String categoryParentID = '',
  }) async {
    showSpinner = true;
    try {
      Future<dynamic> query;
      final Map<String, dynamic> category = <String, dynamic>{
        'uID': _auth.currentUser!.uid,
        'name': categoryName,
        'icon': categoryIcon,
        'parentID': categoryParentID,
        'created_at': FieldValue.serverTimestamp()
      };
      if (categoryID.isNotEmpty) {
        query =
            _fireStore.collection('categories').doc(categoryID).set(category);
      } else {
        query = _fireStore.collection('categories').add(category);
      }
      await query.then((dynamic value) {
        showSpinner = false;
        Navigator.pop(context);
        customDialog(
            context,
            'Success',
            (categoryID.isEmpty)
                ? 'It has been successfully added.'
                : 'It has been successfully saved.',
            'Cool',
            const Icon(
              Icons.check_circle,
              size: 80,
              color: ColorConstants.cyan,
            ));
        getData(context: context);
      });
    } catch (e) {
      print(e);
      showSpinner = false;
    }
  }
}
