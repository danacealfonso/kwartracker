// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:kwartracker/provider/firestore_data.dart';
import 'package:kwartracker/util/color_constants.dart';
import 'package:kwartracker/views/widgets/custom_transaction_list_item.dart';

class CustomTransactionList extends StatefulWidget {
  const CustomTransactionList({
    Key? key,
    this.walletID = '',
    this.paddingItem = EdgeInsets.zero,
    this.buttonToTop = true,
    this.onAmountChanged,
  }) : super(key: key);

  final String walletID;
  final bool buttonToTop;
  final EdgeInsets paddingItem;
  final ValueChanged<double>? onAmountChanged;

  @override
  _CustomTransactionListState createState() => _CustomTransactionListState();
}

class _CustomTransactionListState extends State<CustomTransactionList> {
  ScrollController? _scrollController;
  bool goToTopButton = false;

  @override
  void initState() {
    Provider.of<FirestoreData>(context, listen: false).transactionList.clear();
    Provider.of<FirestoreData>(context, listen: false)
        .getTransactionList(walletID: widget.walletID, context: context);
    _scrollController = ScrollController()..addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirestoreData>(
      builder:
          (BuildContext context, FirestoreData firestoreData, Widget? child) {
        return NotificationListener<ScrollUpdateNotification>(
            onNotification: (ScrollUpdateNotification scroll) {
              final ScrollMetrics metrics = scroll.metrics;
              if (!firestoreData.isLoading) {
                if (metrics.atEdge) {
                  if (metrics.pixels == 0) {
                    if (mounted) {
                      setState(() {
                        goToTopButton = false;
                      });
                    }
                  } else {
                    firestoreData.getTransactionList(
                        walletID: widget.walletID, context: context);
                    if (mounted) {
                      setState(() {
                        firestoreData.isLoading = true;
                      });
                    }
                  }
                }
                if (metrics.pixels >= 10) {
                  if (mounted) {
                    setState(() {
                      goToTopButton = true;
                    });
                  }
                }
              }
              //_scrollListener();
              return true;
            },
            child: Stack(
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: false,
                  padding: const EdgeInsets.only(bottom: 50),
                  controller: _scrollController,
                  itemCount: firestoreData.transactionList.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < firestoreData.transactionList.length) {
                      final Map<String, dynamic> doc =
                          firestoreData.transactionList[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                              padding: widget.paddingItem,
                              child: const Divider()),
                          Padding(
                            padding: widget.paddingItem,
                            child: CustomTransactionListItem(
                              amount: doc['amount'],
                              walletName: doc['walletName'],
                              category: doc['category'],
                              transactionID: doc['transactionID'],
                              currency: doc['currency'],
                              transactionType: doc['transactionType'],
                              transactionDate: doc['transactionDate'],
                              categoryIcon: doc['categoryIcon'],
                            ),
                          ),
                        ],
                      );
                    }
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Opacity(
                        opacity: firestoreData.isLoading ? 1.0 : 0.0,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: SizedBox(
                              width: 32.0,
                              height: 32.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorConstants.cyan),
                              )),
                        ),
                      ),
                    );
                  },
                ),
                if (goToTopButton == true &&
                    firestoreData.isLoading == false &&
                    widget.buttonToTop == true)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: FloatingActionButton(
                          onPressed: () {
                            _scrollController!.animateTo(
                              0.0,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 300),
                            );
                          },
                          child: Image.asset('images/icons/ic_arrow_up.png',
                              width: 15, height: 10, fit: BoxFit.fill)),
                    ),
                  ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      child: const SizedBox(
                          width: double.infinity,
                          height: 5,
                          child: DecoratedBox(
                            decoration:
                                BoxDecoration(color: ColorConstants.grey),
                          )),
                      width: double.infinity,
                      decoration: (goToTopButton == true)
                          ? const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 5, color: ColorConstants.grey),
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(0, 6)),
                              ],
                            )
                          : const BoxDecoration(
                              border: Border(
                              bottom: BorderSide(
                                  width: 5, color: ColorConstants.grey),
                            ))),
                ),
              ],
            ));
      },
    );
  }
}
