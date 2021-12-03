import 'package:e_card/providers/curency_switch_provider.dart';
import 'package:e_card/providers/currency_converter_provider.dart';
import 'package:e_card/providers/filter_provider.dart';
import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/screens/details_page.dart';
import 'package:e_card/screens/filter.dart';
import 'package:e_card/screens/home.dart';
import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/filter_and_short_icons_icons.dart';
import 'package:e_card/utils/slide_route.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  final bool category;
  final int id;
  final String name;

  const ProductList(
      {Key key,
      @required this.category,
      @required this.id,
      @required this.name})
      : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  // WooCommerce woocommerce = WooCommerce(
  //     baseUrl: "https://auraqatar.com/projects/ecard/wordpress",
  //     consumerKey: "ck_d9b31fa60d4dffc9e8451b8489ffb427ac4af511",
  //     consumerSecret: "cs_7d36d2a164690c804db951e212b6bf53d56ea2cf",
  //     apiPath: "/wp-json/wc/v3/",
  //     isDebug: true);

  ScrollController scrollController = ScrollController();
  bool load = true;
  bool price = true;
  @override
  void initState() {
    WoocommerceProvider woocommerceProvider =
        Provider.of<WoocommerceProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 3), () {
      woocommerceProvider.makeEmpty();
      FilterProvider filter =
          Provider.of<FilterProvider>(context, listen: false);
      filter.makeNormal();

      woocommerceProvider
          .filter(widget.category ? widget.id : filter.selectedID, filter.low,
              filter.high, price, false)
          .then((value) {
        setState(() {
          load = false;
        });
      });
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          print(
              "######################${woocommerceProvider.filterProductsAll.length}######################");

          double index = (woocommerceProvider.filterProducts.length / 10) + 1;
          if (woocommerceProvider.filterProducts.length % 10 == 0)
            woocommerceProvider.filter(
              widget.category ? widget.id : filter.selectedID,
              filter.low,
              filter.high,
              price,
              false,
              index.floor(),
            );
        }
      });
    });

    super.initState();
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
              "${widget.name}",
              style: GoogleFonts.poppins(),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  child: load
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : woocommerceProvider.filterProductsAll.length > 0
                          ? Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: GridView.count(
                                controller: scrollController,
                                physics: BouncingScrollPhysics(),
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 25,
                                childAspectRatio: 1 / 1.8,
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                children: List.generate(
                                    woocommerceProvider
                                        .filterProductsAll.length,
                                    (index) => Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.80,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.40,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  SlideRightRoute(
                                                      page: DetailsPage(
                                                    wooProduct: woocommerceProvider
                                                            .filterProductsAll[
                                                        index],
                                                  )),
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      width: double.infinity,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        child: woocommerceProvider
                                                                    .filterProductsAll[
                                                                        index]
                                                                    .images
                                                                    .length >
                                                                0
                                                            ? Image.network(
                                                                woocommerceProvider
                                                                    .filterProductsAll[
                                                                        index]
                                                                    .images[0]
                                                                    .src,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.asset(
                                                                "assets/erro.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ProductName(
                                                          name:
                                                              "${woocommerceProvider.filterProductsAll[index].name}",
                                                          line: 1,
                                                        ),
                                                        // ProductName(
                                                        //   name: "${woocommerceProvider.productsAll[index].}",
                                                        // ),
                                                        // ProductName(
                                                        //   name: "Edition (Pc) -Key-",
                                                        // ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        ProductNameSmall(
                                                          name: "FROM",
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
                                                                "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: woocommerceProvider.filterProductsAll[index].price.toString(), selectedCurrency: snapshot.currencyName)}",
                                                                style:
                                                                    TextStylePage
                                                                        .price,
                                                              ),
                                                              Text(
                                                                "  ${snapshot.currencyName.toUpperCase()}",
                                                                style: TextStylePage
                                                                    .priceSmall,
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                              ),
                            )
                          : Center(
                              child: Text(
                                "Empty",
                                style: TextStylePage.productNameWhite,
                              ),
                            ),
                ),
              ),
              if (load != true &&
                  woocommerceProvider.filterProductsAll.length > 0 &&
                  woocommerceProvider.filterLoad)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (widget.category == false)
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
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    SlideRightRoute(
                                      page: Filter(
                                        from: true,
                                        price: price,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FilterAndShortIcons.sidelist,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          "FILTER",
                                          style: TextStylePage.headingHomeBold,
                                        )
                                      ],
                                    ),
                                    Text(
                                      " Category, Price",
                                      style: TextStylePage.productNameSmallGray,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 1.5,
                          color: Colors.grey.shade600,
                        ),
                        Expanded(
                          child: Container(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  showMaterialModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) => SingleChildScrollView(
                                      controller:
                                          ModalScrollController.of(context),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorsData.primaryColor,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            topLeft: Radius.circular(30),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      child: Center(
                                                        child: Text(
                                                          "SORT PRODUCTS",
                                                          style: TextStylePage
                                                              .bottomSheetText,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              // Material(
                                              //     color: Colors.transparent,
                                              //     child: InkWell(
                                              //         onTap: () {
                                              //
                                              //         },
                                              //         child: shortTile(
                                              //             name:
                                              //                 "Newer Products"))),
                                              Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                      onTap: () {
                                                        WoocommerceProvider
                                                            woocommerceProvider =
                                                            Provider.of<
                                                                    WoocommerceProvider>(
                                                                context,
                                                                listen: false);
                                                        woocommerceProvider
                                                            .short(true);
                                                        Navigator.pop(context);
                                                      },
                                                      child: shortTile(
                                                          name:
                                                              "Highest Price"))),
                                              Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                      onTap: () {
                                                        WoocommerceProvider
                                                            woocommerceProvider =
                                                            Provider.of<
                                                                    WoocommerceProvider>(
                                                                context,
                                                                listen: false);
                                                        woocommerceProvider
                                                            .short(false);
                                                        Navigator.pop(context);
                                                      },
                                                      child: shortTile(
                                                          name:
                                                              "Lower Price"))),
                                              // shortTile(name: "Other Products"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FilterAndShortIcons.sort_icon,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "SORT BY",
                                          style: TextStylePage.headingHomeBold,
                                        )
                                      ],
                                    ),
                                    Text(
                                      " Sort Products",
                                      style: TextStylePage.productNameSmallGray,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  Padding shortTile({String name}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        "$name",
        style: TextStylePage.productName,
      ),
    );
  }
}
