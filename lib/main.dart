import 'dart:io';

import 'package:e_card/models/cart_model.dart';
import 'package:e_card/providers/best_selling_products_provider.dart';
import 'package:e_card/providers/bottom_navigation_bar_provider.dart';
import 'package:e_card/providers/braintree_provider.dart';
import 'package:e_card/providers/curency_switch_provider.dart';
import 'package:e_card/providers/currency_converter_provider.dart';
import 'package:e_card/providers/filter_provider.dart';
import 'package:e_card/providers/firebase_provider.dart';
import 'package:e_card/providers/order_cancel_provider.dart';
import 'package:e_card/providers/order_details_provider.dart';
import 'package:e_card/providers/paypal_provider.dart';
import 'package:e_card/providers/wallet_provider.dart';
import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Hive.registerAdapter(CartAdapter());
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);

  await Hive.openBox<CartModel>("cart");
  await Hive.openBox<CartModel>("favourites");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: WoocommerceProvider(),
        ),
        ChangeNotifierProvider.value(
          value: FirebaseProvider(),
        ),
        ChangeNotifierProvider.value(
          value: BottomNavigationBarProvider(),
        ),
        ChangeNotifierProvider.value(
          value: FilterProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PaypalProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CurrencySwitchProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CurrencyConverterProvider(),
        ),
        ChangeNotifierProvider.value(
          value: BraintreeProvider(),
        ),
        ChangeNotifierProvider.value(
          value: OrderDetailsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: BestSellingProvider(),
        ),
        ChangeNotifierProvider.value(
          value: WalletProvider(),
        ),
        ChangeNotifierProvider.value(
          value: OrderCancelProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.purple, visualDensity: VisualDensity.adaptivePlatformDensity, hintColor: Colors.white),
        builder: (context, child) {
          return MediaQuery(
            child: child,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.95),
          );
        },
        home: Splash(),
      ),
    );
  }
}
