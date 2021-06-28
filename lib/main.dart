import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kwartracker/views/pages/home/home.dart';
import 'package:flutter/rendering.dart';
import 'package:kwartracker/util/colorConstants.dart';
import 'package:kwartracker/util/globals.dart' as globals;
import 'package:kwartracker/views/pages/signIn/signIn.dart';
import 'package:kwartracker/views/pages/signUp/signUp.dart';
import 'package:kwartracker/views/pages/transactions/transactionAddDetails.dart';
import 'package:kwartracker/views/pages/transactions/transactionChooseWallet.dart';
import 'package:kwartracker/views/pages/transactions/transactionDetails.dart';
import 'package:kwartracker/views/pages/transactions/transactions.dart';
import 'package:kwartracker/views/pages/wallets/walletSave.dart';
import 'package:kwartracker/views/pages/wallets/wallets.dart';
import 'package:provider/provider.dart';
import 'model/firestoreData.dart';

var homeNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(KwartrackerApp());
}

class KwartrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FirestoreData(),
      child: MaterialApp(
        title: 'Kwartracker App',
        initialRoute: (globals.isLoggedIn) ? '/': '/signIn',
        routes: {
          '/': (context) => HomePage(),
          '/signIn': (context) => SignInPage(),
          '/signUp': (context) => SignUpPage(),
          '/transactions': (context) => TransactionsPage(),
          '/transactionChooseWallet': (context) => TransactionChooseWalletPage(),
          '/transactionAddDetails': (context) => TransactionAddDetailsPage(null),
          '/wallets': (context) => WalletsPage(),
          '/walletSave': (context) => WalletSavePage(),
          '/transactionDetailsPage': (context) => TransactionDetailsPage(null),
        },
        debugShowCheckedModeBanner: false,
        //TODO: Flutter Themes
        theme: ThemeData(
          primaryColor: ColorConstants.cyan,
          accentColor: Color(0xFF03BED6),
          primaryTextTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.white
              )
          ),
        ),
      ),
    );
  }
}