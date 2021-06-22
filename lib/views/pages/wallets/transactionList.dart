import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatefulWidget {

  @override
  _FTransactionListState createState() => _FTransactionListState();
}

class _FTransactionListState extends State<TransactionList> {
  late ScrollController controller;
  late DocumentSnapshot? _lastVisible;
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  CollectionReference get homeFeeds => _fireStore.collection('transactions');
  List<DocumentSnapshot> _data = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }

  Future<Null> _getData() async {
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await _fireStore
          .collection('transactions')
          .orderBy('created_at', descending: true)
          .limit(3)
          .get();
    else
      data = await _fireStore
          .collection('transactions')
          .orderBy('created_at', descending: true)
          .startAfter([_lastVisible!['created_at']])
          .limit(3)
          .get();

    if (data != null && data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _data.addAll(data.docs);
        });
      }
    } else {
      setState(() => _isLoading = false);
      scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('No more posts!'),
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(),
      body: RefreshIndicator(
        child: ListView.builder(
          controller: controller,
          itemCount: _data.length + 1,
          itemBuilder: (_, int index) {
            if (index < _data.length) {
              final DocumentSnapshot document = _data[index];
              return new Container(
                height: 200.0,
                child: new Text(document['question']),
              );
            }
            return Center(
              child: new Opacity(
                opacity: _isLoading ? 1.0 : 0.0,
                child: new SizedBox(
                    width: 32.0,
                    height: 32.0,
                    child: new CircularProgressIndicator()),
              ),
            );
          },
        ),
        onRefresh: ()async{
          _data.clear();
          _lastVisible=null;
          await _getData();
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }
}