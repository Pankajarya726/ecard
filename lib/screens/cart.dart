import 'package:e_card/models/cart_model.dart';
import 'package:e_card/providers/curency_switch_provider.dart';
import 'package:e_card/providers/currency_converter_provider.dart';
import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/screens/home.dart';
import 'package:e_card/utils/slide_route.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'billing_address.dart';
import 'login.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  Box<CartModel> cartBox;
  List<CartModel> cart;
  List<double> price = [];

  @override
  void initState() {
    cartBox = Hive.box<CartModel>("cart");
    Future.delayed(Duration(microseconds: 20), () {
      getCart();
    });

    super.initState();
  }

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
    WoocommerceProvider woocommerceProvider =
        Provider.of<WoocommerceProvider>(context);
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Cart",
              style: GoogleFonts.poppins(),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Color(0xff0f0211),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50), topLeft: Radius.circular(50)),
              // boxShadow: [
              //   BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              // ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: cart == null || cart.isEmpty
                  ? Center(
                      child: Text(
                        "CART IS EMPTY",
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: Colors.white),
                      ),
                    )
                  : ListView(
                      children: [
                        ListView.builder(
                          itemBuilder: (ctx, index) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 150,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      children: [
                                        Container(
                                          color: Colors.black,
                                          height: 150,
                                          width: 100,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Image.network(
                                              cart[index].image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ProductName(
                                                  name: "${cart[index].name}",
                                                  line: 3,
                                                ),
                                                // ProductName(
                                                //   name: "Premium Online",
                                                // ),
                                                // ProductName(
                                                //   name: "Edition (Pc) -Key-",
                                                // ),
                                                Expanded(
                                                  child: SizedBox(),
                                                ),
                                                ProductNameSmall(
                                                  name: "PRICE",
                                                ),
                                                Consumer<
                                                        CurrencySwitchProvider>(
                                                    builder:
                                                        (context, snapshot, _) {
                                                  return Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: cart[index].price.toString(), selectedCurrency: snapshot.currencyName)}",
                                                        style:
                                                            TextStylePage.price,
                                                      ),
                                                      Text(
                                                        "  ${snapshot.currencyName}",
                                                        style: TextStylePage
                                                            .priceSmall,
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(),
                                                      ),
                                                      Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (cart[index]
                                                                    .quantity ==
                                                                1) {
                                                              cart[index]
                                                                  .delete()
                                                                  .then(
                                                                      (value) {
                                                                getCart();
                                                              });
                                                            } else {
                                                              cart[index]
                                                                  .quantity -= 1;
                                                              cart[index]
                                                                  .save()
                                                                  .then(
                                                                      (value) {
                                                                getCart();
                                                              });
                                                            }
                                                          },
                                                          child: Icon(
                                                            Icons.remove_circle,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 25,
                                                        width: 30,
                                                        child: Center(
                                                          child: Text(
                                                            "${cart[index].quantity}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                      Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            cart[index]
                                                                .quantity += 1;
                                                            cart[index]
                                                                .save()
                                                                .then((value) {
                                                              getCart();
                                                            });
                                                          },
                                                          child: Icon(
                                                            Icons.add_circle,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                })
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                CustomDivider2(),
                              ],
                            );
                          },
                          itemCount: cart.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Cart Total",
                            style: TextStylePage.productName,
                          ),
                        ),
                        Consumer<CurrencySwitchProvider>(
                            builder: (context, snapshot, _) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: price.reduce((value, element) => value + element).toStringAsFixed(2), selectedCurrency: snapshot.currencyName)} ${snapshot.currencyName.toUpperCase()}",
                              style: TextStylePage.headingHomeBig,
                            ),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: 55,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0FA3E4),
                                      Color(0xFF841981),
                                    ],
                                    begin: FractionalOffset(0.0, 0.0),
                                    end: FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0]),
                                borderRadius: BorderRadius.circular(100)),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  if (woocommerceProvider.token == null) {
                                    Navigator.push(
                                      context,
                                      SlideRightRoute(
                                        page: Login(),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      SlideRightRoute(
                                        page: BillingAddress(
                                          total:
                                              "${price.reduce((value, element) => value + element).toStringAsFixed(2)}",
                                          list: cart,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    "CHECKOUT",
                                    style: TextStylePage.headingHomeBold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
