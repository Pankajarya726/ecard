import 'package:e_card/models/cart_model.dart';
import 'package:e_card/providers/curency_switch_provider.dart';
import 'package:e_card/providers/currency_converter_provider.dart';
import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/screens/home.dart';
import 'package:e_card/utils/slide_route.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/utils/toast_util.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/models/products.dart';

import 'details_page.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  Box<CartModel> favouritesBox;
  List<CartModel> favourites;
  int selectedInt = -1;
  @override
  void initState() {
    favouritesBox = Hive.box<CartModel>("favourites");
    getCart();
    super.initState();
  }

  getCart() {
    setState(() {
      favourites = favouritesBox.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              "Wishlist",
              style: GoogleFonts.poppins(),
            ),
          ),
          body: Container(
            child: favourites.isEmpty
                ? Center(
                    child: Text(
                      "WISHLIST IS EMPTY",
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: Colors.white),
                    ),
                  )
                : ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GridView.count(
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 25,
                          childAspectRatio: 1 / 1.7,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          children: List.generate(
                              favourites.length,
                              (index) => Container(
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF340633),
                                              Color(0xFF603a5a),
                                            ],
                                            begin: FractionalOffset(.0, 0.0),
                                            end: FractionalOffset(0.0, 1.0),
                                            stops: [0.0, 1.0]),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: selectedInt ==
                                                favourites[index].id
                                            ? null
                                            : () async {
                                                setState(() {
                                                  selectedInt =
                                                      favourites[index].id;
                                                });
                                                WoocommerceProvider
                                                    woocommerceProvider =
                                                    Provider.of<
                                                            WoocommerceProvider>(
                                                        context,
                                                        listen: false);
                                                WooProduct wooProduct =
                                                    await woocommerceProvider
                                                        .getProduct(
                                                            favourites[index]
                                                                .id
                                                                .toString());
                                                setState(() {
                                                  selectedInt = -1;
                                                });
                                                if (wooProduct != null) {
                                                  Navigator.push(
                                                    context,
                                                    SlideRightRoute(
                                                      page: DetailsPage(
                                                        wooProduct: wooProduct,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  favourites[index]
                                                      .delete()
                                                      .then((value) {
                                                    getCart();
                                                  });
                                                }
                                              },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black,
                                                          blurRadius: 20.0,
                                                          offset: Offset(
                                                              -1.0, 10.0),
                                                        ),
                                                      ]),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    child: Image.network(
                                                      favourites[index].image,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ProductName(
                                                      name:
                                                          "${favourites[index].name}",
                                                      line: 1,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    ProductNameSmall(
                                                      name:
                                                          "Price".toUpperCase(),
                                                    ),
                                                    Consumer<
                                                            CurrencySwitchProvider>(
                                                        builder: (context,
                                                            snapshot, _) {
                                                      return Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: favourites[index].price.toString(), selectedCurrency: snapshot.currencyName)}",
                                                            style: TextStylePage
                                                                .headingHomeBold,
                                                          ),
                                                          Text(
                                                            "  ${snapshot.currencyName}",
                                                            style: TextStylePage
                                                                .whiteText,
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  SizedBox()),
                                                          selectedInt ==
                                                                  favourites[
                                                                          index]
                                                                      .id
                                                              ? Container(
                                                                  height: 25,
                                                                  width: 25,
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                )
                                                              : Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Color(
                                                                          0xFF340633),
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            5.0),
                                                                    child:
                                                                        Material(
                                                                      color: Colors
                                                                          .transparent,
                                                                      child:
                                                                          InkWell(
                                                                        onTap: selectedInt ==
                                                                                favourites[index].id
                                                                            ? null
                                                                            : () {
                                                                                favourites[index].delete().then((value) {
                                                                                  successToast("Item removed from wishList");
                                                                                  getCart();
                                                                                });
                                                                              },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                        ],
                                                      );
                                                    })
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
