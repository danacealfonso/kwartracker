import 'package:flutter/material.dart';
import 'package:kwartracker/model/firestoreData.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/views/widgets/cTransactionListItem.dart';
import 'package:provider/provider.dart';

class CTransactionList extends StatefulWidget {
  final String walletID;
  final bool buttonToTop;
  final EdgeInsets paddingItem;
  final ValueChanged<double>? onAmountChanged;
  CTransactionList({Key? key,
    this.walletID="",
    this.paddingItem = EdgeInsets.zero,
    this.buttonToTop = true,
    this.onAmountChanged,
  }) : super(key: key);

  @override
  _CTransactionListState createState() => _CTransactionListState();
}

class _CTransactionListState extends State<CTransactionList> {
  ScrollController? _scrollController;
  bool goToTopButton = false;
  @override
  void initState() {
    Provider.of<FirestoreData>(context, listen: false)
        .transactionList.clear();
    Provider.of<FirestoreData>(context, listen: false)
        .getData(walletID: widget.walletID,context: context);
    _scrollController = new ScrollController()..addListener((){});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Consumer<FirestoreData>(
        builder: (context, firestoreData, child) {
          return NotificationListener<ScrollUpdateNotification>(
              onNotification: (scroll) {
                var metrics = scroll.metrics;

                if (!firestoreData.isLoading) {
                  if (metrics.atEdge) {
                    if (metrics.pixels == 0) {
                      if(mounted)
                        setState(() {
                          goToTopButton = false;
                        });
                    } else {
                      if(mounted)
                        setState(() {
                          firestoreData.isLoading = true;
                        });
                      firestoreData.getData(walletID: widget.walletID,context: context);
                    }
                  }
                  if (metrics.pixels >= 10) {
                    if(mounted)
                      setState(() {
                        goToTopButton = true;
                      });
                  }
                }
                //_scrollListener();
                return true;
              },child: Stack(
            children: [
              ListView.builder(
                padding: EdgeInsets.only(bottom: 50),
                controller: _scrollController,
                itemCount: firestoreData.transactionList.length + 1,
                itemBuilder: (context, int index) {

                  if (index < firestoreData.transactionList.length) {
                    var doc = firestoreData.transactionList[index];
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
                            amount: doc['amount'],
                            walletName: doc['walletName'],
                            category: doc['category'],
                            transactionID: doc['transactionID'],
                            currency: doc['currency'],
                            transactionType: doc['transactionType'],
                            transactionDate: doc['transactionDate'],
                          ),
                        ),
                      ],
                    );
                  }
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Opacity(
                      opacity: firestoreData.isLoading ? 1.0 : 0.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top:15),
                        child: SizedBox(
                            width: 32.0,
                            height: 32.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorConstants.cyan
                              ),
                            )),
                      ),
                    ),
                  );
                },
              ),
              (goToTopButton==true &&
                  firestoreData.isLoading==false &&
                  widget.buttonToTop==true)? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 40),
                  child: FloatingActionButton(
                      onPressed: () {
                        _scrollController!.animateTo(
                          0.0,
                          curve: Curves.easeOut,
                          duration: Duration(milliseconds: 300),
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
                    decoration: (goToTopButton==true)? BoxDecoration(
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
        },
      );
  }
}