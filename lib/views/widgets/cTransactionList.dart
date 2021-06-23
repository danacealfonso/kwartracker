import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/widgets/cTransactionListItem.dart';

class CTransactionList extends StatefulWidget {
  final String? walletID;
  final bool buttonToTop;
  final EdgeInsets paddingItem;
  CTransactionList({Key? key,
    this.walletID,
    this.paddingItem = EdgeInsets.zero,
    this.buttonToTop = true,
  }) : super(key: key);

  @override
  _CTransactionListState createState() => _CTransactionListState();
}

class _CTransactionListState extends State<CTransactionList> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  ScrollController? _scrollController;
  DocumentSnapshot? _lastVisible;
  bool _isLoading = true;
  bool _goToTopButton = false;
  CollectionReference get homeFeeds => _fireStore.collection('transactions');
  List _data = [];

  @override
  void initState() {
    _scrollController = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _getData();
  }

  Future<Null> _getData() async {
    var query;

    if (_lastVisible == null)
      query = _fireStore
        .collection('transactions')
        .where("wallet",isEqualTo: widget.walletID)
        .orderBy('created_at', descending: true)
        .limit(20);
    else
      query = _fireStore
        .collection('transactions')
        .where("wallet",isEqualTo: widget.walletID)
        .orderBy('created_at', descending: true)
        .startAfterDocument(_lastVisible!)
        .limit(20);

    query.get().then((documentSnapshot) {
      if (documentSnapshot.docs.length > 0) {
        _lastVisible = documentSnapshot.docs[documentSnapshot.docs.length-1];
        if (mounted) {
          setState(() {
            _isLoading = false;
            for (var transaction in documentSnapshot.docs) {
              _data.add(transaction.data());
            }
          });
        }
      } else {
        setState(() => _isLoading = false);
      }
    });
    return null;
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (_scrollController?.position.pixels == _scrollController?.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
      if (_scrollController!.position.pixels >= 10) {
        setState(() => _goToTopButton = true);
      } else if (_scrollController!.position.pixels ==_scrollController?.position.minScrollExtent) {
        setState(() {
          _goToTopButton = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
      return NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
        _scrollListener();
        return true;
      },child: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: _data.length + 1,
            itemBuilder: (_, int index) {
              if (index < _data.length) {
                var doc = _data[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: widget.paddingItem,
                      child: Divider()
                    ),
                    Padding(
                      padding: widget.paddingItem,
                      child: CTransactionListItem(
                          amount: 2222,
                          walletName: doc['name'],
                          walletType: doc['type'],
                          month: 'Mar',
                          day: 12,
                        currency: doc['currency'],
                        transactionType: doc['type'],),
                    ),
                  ],
                );
              }
              return Align(
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: _isLoading ? 1.0 : 0.0,
                  child: SizedBox(
                    width: 32.0,
                    height: 32.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ColorConstants.cyan
                      ),
                    )),
                ),
              );
            },
          ),
          (_goToTopButton==true &&
              _isLoading==false &&
              widget.buttonToTop==true)? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(bottom: 50),
              child: FloatingActionButton(
                  onPressed: () {
                    _scrollController!.animateTo(
                      0.0,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300),
                    );
                  },
                  child: Image.asset(
                      'images/icons/ic_arrow_up.png',
                      width: 15,
                      height: 10,
                      fit:BoxFit.fill
                  )
              ),
            ),
          ):SizedBox(),
         Align(
            alignment: Alignment.topCenter,
            child: Container(
              child: SizedBox(
                width: double.infinity,
                height: 5,
                child: const DecoratedBox(
                  decoration: const BoxDecoration(
                      color: ColorConstants.grey
                  ),
                )
              ),
              width: double.infinity,
              decoration: (_goToTopButton==true)? BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 5, color: ColorConstants.grey),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0,6)
                  ),
                ],
              )
              : BoxDecoration(border: Border(
                bottom: BorderSide(width: 5, color: ColorConstants.grey),
              ))
            ),
          ),
        ],
      )
    );
  }

  @override
  void dispose() {
    _scrollController!.removeListener(_scrollListener);
    super.dispose();
  }
}