import 'package:e_card/models/cart_model.dart';
import 'package:e_card/providers/bottom_navigation_bar_provider.dart';
import 'package:e_card/providers/wallet_provider.dart';
import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/screens/cart.dart';
import 'package:e_card/screens/home.dart';
import 'package:e_card/screens/profile.dart';
import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/tab_bar_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'search.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List<Widget> list = [
    Home(),
    Search(),
    Profile(),
    Cart(),
  ];

  @override
  void initState() {
    Provider.of<WoocommerceProvider>(context, listen: false)
        .getData()
        .then((value) {
      WoocommerceProvider woocommerceProvider =
          Provider.of<WoocommerceProvider>(context, listen: false);
      if (woocommerceProvider.userId != null) {
        Provider.of<WalletProvider>(context, listen: false)
            .getWalletDetails(userID: woocommerceProvider.userId.toString());
      }
    });

    cartBox = Hive.box<CartModel>("cart");
    Future.delayed(Duration(microseconds: 20), () {
      getCart();
    });

    super.initState();
  }

  Box<CartModel> cartBox;
  List<CartModel> cart;
  List<double> price = [];

  getCart() {
    setState(() {
      price = [];
      cart = cartBox.values.toList();
      Provider.of<WoocommerceProvider>(context, listen: false)
          .changeQuantity(cart.length);
      for (int i = 0; i < cart.length; i++) {
        price.add(cart[i].price * cart[i].quantity);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationBarProvider>(
        builder: (context, snapshot, _) {
      return Scaffold(
        backgroundColor: snapshot.index == 3
            ? Color(0xff0f0211)
            : snapshot.index == 2
                ? Color(0xff33113A)
                : ColorsData.primaryColor,
        body: list[snapshot.index],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Color(0xff230c28),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            // boxShadow: [
            //   BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            // ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                // sets the background color of the `BottomNavigationBar`
                canvasColor: ColorsData.textFieldColor.withOpacity(0.20),
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: Colors.white,
                textTheme: Theme.of(context).textTheme.copyWith(
                      caption: new TextStyle(
                        color: Colors.white.withOpacity(0.32),
                      ),
                    ),
              ),
              child: BottomNavigationBar(
                elevation: 2,
                type: BottomNavigationBarType.fixed,
                backgroundColor: ColorsData.textFieldColor.withOpacity(0.20),
                currentIndex: snapshot.index,
                onTap: (i) {
                  snapshot.changeIndex(i);
                },
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(TabBarIcons.home),
                      ),
                      label: 'HOME'),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(TabBarIcons.search__1_),
                      ),
                      label: 'SEARCH'),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(TabBarIcons.user__2_),
                      ),
                      label: 'PROFILE'),
                  BottomNavigationBarItem(
                      icon: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(TabBarIcons.bag),
                          ),
                          Consumer<WoocommerceProvider>(
                              builder: (context, snapshot, _) {
                            return Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "${snapshot.cartQuantity}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                      label: 'CART'),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
