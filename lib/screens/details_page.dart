import 'package:carousel_pro/carousel_pro.dart';
import 'package:e_card/models/cart_model.dart';
import 'package:e_card/providers/bottom_navigation_bar_provider.dart';
import 'package:e_card/providers/curency_switch_provider.dart';
import 'package:e_card/providers/currency_converter_provider.dart';
import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/screens/home.dart';
import 'package:e_card/screens/rating_and_reviews.dart';
import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/slide_route.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/models/products.dart';

import 'bottom_navigation.dart';

class DetailsPage extends StatefulWidget {
  final WooProduct wooProduct;

  const DetailsPage({Key key, @required this.wooProduct}) : super(key: key);
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Box<CartModel> cartBox;
  List<CartModel> cart;
  Box<CartModel> favouritesBox;
  List<CartModel> favourites;
  bool inCart = false;
  bool inFavourites = false;
  int favouritesIndex;

  @override
  void initState() {
    cartBox = Hive.box<CartModel>("cart");
    favouritesBox = Hive.box<CartModel>("favourites");
    Future.delayed(Duration(microseconds: 20), () {
      checkCart();
    });

    super.initState();
  }

  checkCart() {
    setState(() {
      inFavourites = false;
    });
    cart = cartBox.values.toList();
    Provider.of<WoocommerceProvider>(context, listen: false)
        .changeQuantity(cart.length);
    for (int i = 0; i < cart.length; i++) {
      if (cart[i].id == widget.wooProduct.id) {
        setState(() {
          inCart = true;
        });
      }
    }
    favourites = favouritesBox.values.toList();
    for (int i = 0; i < favourites.length; i++) {
      if (favourites[i].id == widget.wooProduct.id) {
        setState(() {
          inFavourites = true;
          favouritesIndex = i;
        });
      }
    }
  }

  //here goes the function
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsData.primaryColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.red, Colors.transparent],
                          ).createShader(
                              Rect.fromLTRB(0, 0, rect.width, rect.height));
                        },
                        blendMode: BlendMode.dstIn,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: double.infinity,
                          child: Carousel(
                            images: List.generate(
                              widget.wooProduct.images.length,
                              (index) => Image.network(
                                widget.wooProduct.images[index].src,
                                fit: BoxFit.cover,
                              ),
                            ),
                            showIndicator: false,
                            borderRadius: false,
                            moveIndicatorFromBottom: 180.0,
                            noRadiusForIndicator: true,
                            overlayShadow: true,
                            overlayShadowColors: Colors.white,
                            overlayShadowSize: 0.7,
                            autoplay: true,
                            autoplayDuration: Duration(seconds: 2),
                            animationDuration: Duration(seconds: 1),
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                color: Colors.black,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.width * 0.30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: widget.wooProduct.images != null &&
                                          widget.wooProduct.images.isNotEmpty
                                      ? Image.network(
                                          widget.wooProduct.images[0].src,
                                          fit: BoxFit.cover,
                                        )
                                      : SizedBox(),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      HeadLineHome(
                                        name: "${widget.wooProduct.name}",
                                      ),
                                      // HeadLineHome(
                                      //   name: "Premium Online",
                                      // ),
                                      // HeadLineHome(
                                      //   name: "Edition (PC) QATAR",
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 5),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle_outline,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Icon In stock",
                                              style: TextStylePage.whiteSmall,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.amber, shape: BoxShape.circle),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Icon(
                                Icons.star_rate,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                SlideRightRoute(
                                  page: RatingAndReview(
                                    id: widget.wooProduct.id,
                                    name: widget.wooProduct.name,
                                    image: widget.wooProduct.images[0].src,
                                    rating: widget.wooProduct.averageRating,
                                    ratingCount: widget.wooProduct.ratingCount,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "${widget.wooProduct.averageRating}",
                              style: TextStylePage.headingHome,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${widget.wooProduct.ratingCount} Reviews",
                          style: TextStylePage.viewAll,
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0xff2e1234), shape: BoxShape.circle),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    if (inFavourites) {
                                      favourites[favouritesIndex]
                                          .delete()
                                          .then((value) {
                                        checkCart();
                                        successToast(
                                            "Item removed from wishlist");
                                      });
                                    } else {
                                      favouritesBox
                                          .add(
                                        CartModel(
                                          id: widget.wooProduct.id,
                                          price: double.parse(
                                            widget.wooProduct.price.toString(),
                                          ),
                                          name: widget.wooProduct.name,
                                          image:
                                              widget.wooProduct.images[0].src,
                                          discription:
                                              widget.wooProduct.description,
                                          quantity: 1,
                                        ),
                                      )
                                          .then((value) {
                                        successToast("Item added to wishlist");
                                        checkCart();
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                    size: 20,
                                    color: inFavourites
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Icon(
                        //   Icons.ios_share,
                        //   size: 25,
                        //   color: Colors.white,
                        // ),
                      ],
                    ),
                  ),
                  CustomDivider2(),
                  HeadLineHome(
                    name: "Product Description",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "${_parseHtmlString(widget.wooProduct.description)}",
                      style: TextStylePage.productNameSmall,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15),
                  //   child: Text(
                  //     "VIEW MORE +",
                  //     style: TextStylePage.whiteSmall,
                  //   ),
                  // ),
                  CustomDivider2(),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Container(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             Container(
                  //               // margin: EdgeInsets.only(left: 10),
                  //               height:
                  //                   MediaQuery.of(context).size.width * 0.20,
                  //               width: MediaQuery.of(context).size.width * 0.20,
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 color: Color(0xff2e1234),
                  //               ),
                  //               child: Padding(
                  //                 padding: const EdgeInsets.only(right: 25),
                  //                 child: Center(
                  //                   child: Icon(
                  //                     DetailsIcon.group_9776,
                  //                     color: Colors.white,
                  //                     size: MediaQuery.of(context).size.width *
                  //                         0.06,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               height: 10,
                  //             ),
                  //             Text(
                  //               "FREE\nDELIVERY",
                  //               textAlign: TextAlign.center,
                  //               style: TextStylePage.whiteSmall2,
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Container(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             Container(
                  //               // margin: EdgeInsets.only(left: 10),
                  //               height:
                  //                   MediaQuery.of(context).size.width * 0.20,
                  //               width: MediaQuery.of(context).size.width * 0.20,
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 color: Color(0xff2e1234),
                  //               ),
                  //               child: Center(
                  //                 child: Icon(
                  //                   DetailsIcon.group_10052,
                  //                   color: Colors.white,
                  //                   size: MediaQuery.of(context).size.width *
                  //                       0.08,
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               height: 10,
                  //             ),
                  //             Text(
                  //               "24/7\nSUPPORT",
                  //               textAlign: TextAlign.center,
                  //               style: TextStylePage.whiteSmall2,
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Container(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             Container(
                  //               // margin: EdgeInsets.only(left: 10),
                  //               height:
                  //                   MediaQuery.of(context).size.width * 0.20,
                  //               width: MediaQuery.of(context).size.width * 0.20,
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 color: Color(0xff2e1234),
                  //               ),
                  //               child: Center(
                  //                 child: Icon(
                  //                   DetailsIcon.group_9777,
                  //                   color: Colors.white,
                  //                   size: MediaQuery.of(context).size.width *
                  //                       0.08,
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               height: 10,
                  //             ),
                  //             Text(
                  //               "FREE\nRETURN",
                  //               textAlign: TextAlign.center,
                  //               style: TextStylePage.whiteSmall2,
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Container(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             Container(
                  //               // margin: EdgeInsets.only(left: 10),
                  //               height:
                  //                   MediaQuery.of(context).size.width * 0.20,
                  //               width: MediaQuery.of(context).size.width * 0.20,
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 color: Color(0xff2e1234),
                  //               ),
                  //               child: Padding(
                  //                 padding: const EdgeInsets.only(right: 10),
                  //                 child: Center(
                  //                   child: Icon(
                  //                     DetailsIcon.credit,
                  //                     color: Colors.white,
                  //                     size: MediaQuery.of(context).size.width *
                  //                         0.06,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               height: 10,
                  //             ),
                  //             Text(
                  //               "PAYMENT\nMETHODS",
                  //               textAlign: TextAlign.center,
                  //               style: TextStylePage.whiteSmall2,
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Color(0xff33113A),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Consumer<CurrencySwitchProvider>(
                          builder: (context, snapshot, _) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: widget.wooProduct.price.toString(), selectedCurrency: snapshot.currencyName)}",
                              style: TextStylePage.headingHomeBigBold,
                            ),
                            Text(
                              "${snapshot.currencyName.toUpperCase()}",
                              style: TextStylePage.whiteTextBold,
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Consumer<WoocommerceProvider>(
                          builder: (context, snapshot, _) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                height: 40,
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(100),
                                    child: InkWell(
                                      onTap: () {
                                        if (inCart) {
                                          Provider.of<BottomNavigationBarProvider>(
                                                  context,
                                                  listen: false)
                                              .changeIndex(3);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              SlideRightRoute(
                                                  page: BottomNavigation()),
                                              (route) => false);
                                        } else {
                                          cartBox
                                              .add(
                                            CartModel(
                                              id: widget.wooProduct.id,
                                              price: double.parse(
                                                widget.wooProduct.price
                                                    .toString(),
                                              ),
                                              name: widget.wooProduct.name,
                                              image: widget
                                                  .wooProduct.images[0].src,
                                              discription:
                                                  widget.wooProduct.description,
                                              quantity: 1,
                                            ),
                                          )
                                              .then((value) {
                                            successToast("Item added to Cart");
                                            checkCart();
                                          });
                                        }
                                      },
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.shopping_cart,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              inCart
                                                  ? "GO TO CART"
                                                  : "ADD TO CART",
                                              style:
                                                  TextStylePage.whiteTextBold,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
