import 'package:e_card/providers/best_selling_products_provider.dart';
import 'package:e_card/providers/bottom_navigation_bar_provider.dart';
import 'package:e_card/providers/curency_switch_provider.dart';
import 'package:e_card/providers/currency_converter_provider.dart';
import 'package:e_card/providers/firebase_provider.dart';
import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/screens/details_page.dart';
import 'package:e_card/screens/product_list.dart';
import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/slide_route.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/utils/toast_util.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/woocommerce.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedInt = -100;
  bool banner2 = false;
  bool banner3 = false;
  int indexSelected = -100;

  WooCommerce woocommerce = WooCommerce(
      baseUrl: "https://auraqatar.com/projects/ecard/wordpress",
      consumerKey: "ck_d9b31fa60d4dffc9e8451b8489ffb427ac4af511",
      consumerSecret: "cs_7d36d2a164690c804db951e212b6bf53d56ea2cf",
      apiPath: "/wp-json/wc/v3/",
      isDebug: true);

  ScrollController scrollController = ScrollController();
  ScrollController scrollController2 = ScrollController();

  @override
  void initState() {
    Provider.of<CurrencyConverterProvider>(context, listen: false).getRates().then((value) {
      Future.delayed(Duration(microseconds: 20), () {
        FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context, listen: false);
        if (firebaseProvider.bannerList.isEmpty) {
          firebaseProvider.getBanner();
        }

        WoocommerceProvider woocommerceProvider = Provider.of<WoocommerceProvider>(context, listen: false);
        woocommerceProvider.getAllProducts();
        woocommerceProvider.getCategory();
        Provider.of<BestSellingProvider>(context, listen: false).getBestSellingProducts();
        scrollController.addListener(() {
          if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
            double index = (woocommerceProvider.productsAll.length / 10) + 1;
            woocommerceProvider.getAllProducts(index.floor());
          }
        });
        scrollController2.addListener(() {
          if (scrollController2.position.pixels == scrollController2.position.maxScrollExtent) {
            double index = (woocommerceProvider.productCategoryAll.length / 10) + 1;
            woocommerceProvider.getCategory(index.floor());
          }
        });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    scrollController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WoocommerceProvider woocommerceProvider = Provider.of<WoocommerceProvider>(context);
    FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: ListView(
              children: [
                const SizedBox(
                  height: 10,
                ),
                searchWidget(context),
                homeBanners(context, woocommerceProvider),
                CustomDivider(),
                HeadLineHome(
                  name: "Categories",
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.95,
                    child: woocommerceProvider.productCategoryAll.length <= 0
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : GridView.count(
                            controller: scrollController2,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            crossAxisCount: 3,
                            childAspectRatio: 1 / 1,
                            children: List.generate(
                              woocommerceProvider.productCategoryAll.length + 1,
                              (index) => woocommerceProvider.productCategoryAll.length == index
                                  ? Container(
                                      child: woocommerceProvider.categoryLoad
                                          ? Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Center(
                                                child: CircularProgressIndicator(),
                                              ),
                                            )
                                          : const SizedBox(),
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(top: 5, bottom: 5, right: 10),
                                      height: MediaQuery.of(context).size.width * 0.21,
                                      width: MediaQuery.of(context).size.width * 0.21,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Color(0xff2e1234),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                SlideRightRoute(
                                                  page: ProductList(
                                                    category: true,
                                                    id: woocommerceProvider.productCategoryAll[index].id,
                                                    name: woocommerceProvider.productCategoryAll[index].name,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    child: Center(
                                                      child: woocommerceProvider.productCategoryAll[index].image != null
                                                          ? Container(
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                image: DecorationImage(
                                                                    image: NetworkImage(
                                                                      woocommerceProvider.productCategoryAll[index].image.src,
                                                                    ),
                                                                    fit: BoxFit.cover),
                                                              ),
                                                              width: MediaQuery.of(context).size.width * 0.2,
                                                              height: MediaQuery.of(context).size.width * 0.2,
                                                            )
                                                          : Icon(
                                                              Icons.error,
                                                              color: Colors.white,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: Text(
                                                      "${woocommerceProvider.productCategoryAll[index].name}",
                                                      textAlign: TextAlign.center,
                                                      style: TextStylePage.whiteText,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                  ),
                ),
                CustomDivider(),
                ListHeading(
                  name: "Popular Items",
                ),
                HomeList(),
                if (firebaseProvider.banner2 != null) CustomDivider(),
                if (firebaseProvider.banner2 != null)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.70,
                          width: double.infinity,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: banner2
                                  ? null
                                  : () async {
                                      setState(() {
                                        banner2 = true;
                                      });
                                      WooProduct wooProduct =
                                          await woocommerceProvider.getProduct(firebaseProvider.banner2.id.toString());
                                      setState(() {
                                        banner2 = false;
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
                                        successToast("Product unavailable");
                                      }
                                    },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  firebaseProvider.banner2.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (banner2) Align(alignment: Alignment.center, child: CircularProgressIndicator()),
                    ],
                  ),
                CustomDivider(),
                ListHeading(
                  name: "Featured Products",
                ),
                HomeListCustom(),
                // CustomDivider(),
                // ListHeading(
                //   name: "",
                // ),
                // HomeList(),
                if (firebaseProvider.banner3 != null) CustomDivider(),
                if (firebaseProvider.banner3 != null)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.50,
                          width: double.infinity,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: banner3
                                  ? null
                                  : () async {
                                      setState(() {
                                        banner3 = true;
                                      });
                                      WooProduct wooProduct =
                                          await woocommerceProvider.getProduct(firebaseProvider.banner3.id.toString());
                                      setState(() {
                                        banner3 = false;
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
                                        successToast("Product unavailable");
                                      }
                                    },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  firebaseProvider.banner3.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (banner3) Align(alignment: Alignment.center, child: CircularProgressIndicator()),
                    ],
                  ),

                Consumer<BestSellingProvider>(builder: (context, bestSellingData, _) {
                  return bestSellingData.bestSellingModel != null && !bestSellingData.loading
                      ? Column(
                          children: [
                            CustomDivider(),
                            ListHeading(
                              name: "Bestselling Items",
                            ),
                          ],
                        )
                      : SizedBox();
                }),
                Consumer<BestSellingProvider>(builder: (context, bestSellingData, _) {
                  return bestSellingData.bestSellingModel != null && !bestSellingData.loading
                      ? Container(
                          margin: const EdgeInsets.all(15),
                          height: MediaQuery.of(context).size.width * 0.73,
                          child: ListView.builder(
                            controller: scrollController,
                            itemBuilder: (ctx, index) {
                              return Container(
                                margin: const EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: indexSelected == index
                                        ? null
                                        : () async {
                                            setState(() {
                                              indexSelected = index;
                                            });
                                            WooProduct wooProduct = await woocommerceProvider
                                                .getProduct(bestSellingData.bestSellingModel.data[index].id.toString());
                                            setState(() {
                                              indexSelected = -100;
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
                                              successToast("Product unavailable");
                                            }
                                          },
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            width: double.infinity,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(4),
                                                    child: Image.network(
                                                      bestSellingData.bestSellingModel.data[index].image,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                if (indexSelected == index)
                                                  Align(alignment: Alignment.center, child: CircularProgressIndicator()),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ProductName(
                                                name: "${bestSellingData.bestSellingModel.data[index].name}",
                                                line: 1,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ProductNameSmall(
                                                name: "FROM",
                                              ),
                                              Consumer<CurrencySwitchProvider>(builder: (context, snapshot, _) {
                                                return Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: bestSellingData.bestSellingModel.data[index].sellPrice.toString(), selectedCurrency: snapshot.currencyName)}",
                                                      style: TextStylePage.price,
                                                    ),
                                                    Text(
                                                      "  ${snapshot.currencyName.toUpperCase()}",
                                                      style: TextStylePage.priceSmall,
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
                              );
                            },
                            itemCount: bestSellingData.bestSellingModel.data.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                          ),
                        )
                      : SizedBox();
                }),
                CustomDivider(),
                ListHeading(
                  name: "Latest Releases",
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  height: MediaQuery.of(context).size.width * 0.73,
                  child: ListView.builder(
                    controller: scrollController,
                    itemBuilder: (ctx, index) {
                      return Container(
                        margin: const EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                SlideRightRoute(
                                    page: DetailsPage(
                                  wooProduct: woocommerceProvider.newReleases[index],
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
                                      borderRadius: BorderRadius.circular(6),
                                      child: woocommerceProvider.newReleases[index].images.length > 0
                                          ? Image.network(
                                              woocommerceProvider.newReleases[index].images[0].src,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "assets/erro.png",
                                              fit: BoxFit.cover,
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ProductName(
                                        name: "${woocommerceProvider.newReleases[index].name}",
                                        line: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ProductNameSmall(
                                        name: "FROM",
                                      ),
                                      Consumer<CurrencySwitchProvider>(builder: (context, snapshot, _) {
                                        return Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: woocommerceProvider.newReleases[index].price.toString(), selectedCurrency: snapshot.currencyName)}",
                                              style: TextStylePage.price,
                                            ),
                                            Text(
                                              "  ${snapshot.currencyName.toUpperCase()}",
                                              style: TextStylePage.priceSmall,
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
                      );
                    },
                    itemCount: woocommerceProvider.newReleases.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Consumer homeBanners(BuildContext context, WoocommerceProvider woocommerceProvider) {
    return Consumer<FirebaseProvider>(builder: (context, snapshot, _) {
      return Container(
        height: MediaQuery.of(context).size.width * 0.40,
        child: snapshot.bannerList.length <= 0
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                controller: scrollController,
                itemBuilder: (ctx, index) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.only(left: 15),
                        height: MediaQuery.of(context).size.width * 0.40,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: selectedInt == snapshot.bannerList[index].id
                                ? null
                                : () async {
                                    setState(() {
                                      selectedInt = snapshot.bannerList[index].id;
                                    });
                                    WoocommerceProvider woocommerceProvider = Provider.of<WoocommerceProvider>(context, listen: false);
                                    WooProduct wooProduct =
                                        await woocommerceProvider.getProduct(snapshot.bannerList[index].id.toString());
                                    setState(() {
                                      selectedInt = -100;
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
                                      successToast("Product unavailable");
                                    }
                                  },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: snapshot.bannerList.length > 0
                                  ? Image.network(
                                      snapshot.bannerList[index].image,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "assets/erro.png",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      if (selectedInt == snapshot.bannerList[index].id)
                        Align(alignment: Alignment.center, child: CircularProgressIndicator()),
                    ],
                  );
                },
                itemCount: snapshot.bannerList.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
              ),
      );
    });
  }

  Padding searchWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: ColorsData.textFieldColor.withOpacity(0.20),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        onTap: () {
                          Provider.of<BottomNavigationBarProvider>(context, listen: false).changeIndex(1);
                        },
                        style: TextStylePage.headingHome15,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Search games, apps..",
                            hintStyle: TextStylePage.textFieldStyle),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorsData.textFieldColor.withOpacity(0.20),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            height: 55,
            width: 100,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  showMaterialModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => SingleChildScrollView(
                      controller: ModalScrollController.of(context),
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
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: Colors.transparent,
                                  ),
                                  Expanded(child: SizedBox()),
                                  Text(
                                    "CHOOSE CURRENCY",
                                    style: TextStylePage.headingHomeBold,
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
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
                              const SizedBox(
                                height: 40,
                              ),
                              CurrencyTile(
                                name: "QAR",
                                image: "qar",
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CurrencyTile(
                                name: "USD",
                                image: "usd",
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CurrencyTile(
                                name: "AED",
                                image: "aed",
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CurrencyTile(
                                name: "KWD",
                                image: "kwd",
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CurrencyTile(
                                name: "GCC",
                                image: "gcc",
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CurrencyTile(
                                name: "UK",
                                image: "uk",
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CurrencyTile(
                                name: "EU",
                                image: "eu",
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CurrencyTile(
                                name: "JOD",
                                image: "jod",
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Consumer<CurrencySwitchProvider>(builder: (context, snapshot, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(border: Border.all(color: Colors.white30, width: 2), shape: BoxShape.circle),
                        child: Image.asset("assets/${snapshot.currencyName}\.png"),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${snapshot.currencyName}".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStylePage.headingHome15,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                      )
                    ],
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CurrencyTile extends StatelessWidget {
  final String name;
  final String image;

  const CurrencyTile({
    Key key,
    this.name,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencySwitchProvider>(builder: (context, snapshot, _) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                name.toLowerCase().contains(snapshot.currencyName) ? Color(0xFF841981) : Colors.transparent,
                name.toLowerCase().contains(snapshot.currencyName) ? Color(0xFF0FA3E4) : Colors.transparent,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0]),
          border: Border.all(color: Colors.white30),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              snapshot.changeCurrency(image);
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(border: Border.all(color: Colors.white24, width: 2), shape: BoxShape.circle),
                    child: Image.asset("assets/$image\.png"),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    "$name",
                    style: name.toLowerCase().contains(snapshot.currencyName)
                        ? TextStylePage.productNameWhite
                        : TextStylePage.productName,
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  if (name.toLowerCase().contains(snapshot.currencyName))
                    Icon(
                      Icons.check_circle,
                      color: Color(0xff89137d),
                      size: 25,
                    )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class HomeList extends StatefulWidget {
  const HomeList({
    Key key,
  }) : super(key: key);

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    WoocommerceProvider woocommerceProvider = Provider.of<WoocommerceProvider>(context, listen: false);
    woocommerceProvider.getAllProducts();
    woocommerceProvider.getCategory();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        double index = (woocommerceProvider.productsAll.length / 10) + 1;
        woocommerceProvider.getAllProducts(index.floor());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WoocommerceProvider woocommerceProvider = Provider.of<WoocommerceProvider>(context);
    return Container(
      margin: const EdgeInsets.all(15),
      height: MediaQuery.of(context).size.width * 0.73,
      child: woocommerceProvider.productsAll.length <= 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              controller: scrollController,
              itemBuilder: (ctx, index) {
                return woocommerceProvider.productsAll.length == index
                    ? Container(
                        child: woocommerceProvider.productLoad
                            ? Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SizedBox(),
                      )
                    : Container(
                        margin: const EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                SlideRightRoute(
                                    page: DetailsPage(
                                  wooProduct: woocommerceProvider.productsAll[index],
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
                                      borderRadius: BorderRadius.circular(4),
                                      child: woocommerceProvider.productsAll[index].images.length > 0
                                          ? Image.network(
                                              woocommerceProvider.productsAll[index].images[0].src,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "assets/erro.png",
                                              fit: BoxFit.cover,
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ProductName(
                                        name: "${woocommerceProvider.productsAll[index].name}",
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
                                      Consumer<CurrencySwitchProvider>(builder: (context, snapshot, _) {
                                        return Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: woocommerceProvider.productsAll[index].price.toString(), selectedCurrency: snapshot.currencyName)}",
                                              style: TextStylePage.price,
                                            ),
                                            Text(
                                              "  ${snapshot.currencyName.toUpperCase()}",
                                              style: TextStylePage.priceSmall,
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
                      );
              },
              itemCount: woocommerceProvider.productsAll.length + 1,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
            ),
    );
  }
}

class HomeListCustom extends StatefulWidget {
  const HomeListCustom({
    Key key,
  }) : super(key: key);

  @override
  _HomeListCustomState createState() => _HomeListCustomState();
}

class _HomeListCustomState extends State<HomeListCustom> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    WoocommerceProvider woocommerceProvider = Provider.of<WoocommerceProvider>(context, listen: false);
    woocommerceProvider.getAllProductsFuture();

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        double index = (woocommerceProvider.productsAll.length / 10) + 1;
        woocommerceProvider.getAllProductsFuture(index.floor());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WoocommerceProvider woocommerceProvider = Provider.of<WoocommerceProvider>(context);
    return Container(
      margin: const EdgeInsets.all(15),
      height: MediaQuery.of(context).size.width * 0.73,
      child: woocommerceProvider.popularProductAll.length <= 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              controller: scrollController,
              itemBuilder: (ctx, index) {
                return woocommerceProvider.popularProductAll.length == index
                    ? Container(
                        child: woocommerceProvider.productLoadFuture
                            ? Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SizedBox(),
                      )
                    : Container(
                        margin: const EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                SlideRightRoute(
                                    page: DetailsPage(
                                  wooProduct: woocommerceProvider.popularProductAll[index],
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
                                      borderRadius: BorderRadius.circular(4),
                                      child: woocommerceProvider.popularProductAll[index].images.length > 0
                                          ? Image.network(
                                              woocommerceProvider.popularProductAll[index].images[0].src,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "assets/erro.png",
                                              fit: BoxFit.cover,
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ProductName(
                                        name: "${woocommerceProvider.popularProductAll[index].name}",
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
                                      Consumer<CurrencySwitchProvider>(builder: (context, snapshot, _) {
                                        return Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: woocommerceProvider.popularProductAll[index].price.toString(), selectedCurrency: snapshot.currencyName)}",
                                              style: TextStylePage.price,
                                            ),
                                            Text(
                                              "  ${snapshot.currencyName.toUpperCase()}",
                                              style: TextStylePage.priceSmall,
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
                      );
              },
              itemCount: woocommerceProvider.popularProductAll.length + 1,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
            ),
    );
  }
}

class ListHeading extends StatelessWidget {
  const ListHeading({
    Key key,
    @required this.name,
  }) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        HeadLineHome(
          name: "$name",
        ),
        name == "Featured Products" || name == "Bestselling Items" || name == "Latest Releases"
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideRightRoute(
                          page: ProductList(
                            category: false,
                            id: 0,
                            name: name,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "VIEW ALL",
                      style: TextStylePage.viewAll,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}

class ProductName extends StatelessWidget {
  const ProductName({Key key, this.name, @required this.line}) : super(key: key);
  final String name;
  final int line;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Text(
        name,
        maxLines: line,
        overflow: TextOverflow.ellipsis,
        style: TextStylePage.productName,
      ),
    );
  }
}

class ProductNameSmall extends StatelessWidget {
  const ProductNameSmall({
    Key key,
    this.name,
  }) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStylePage.productNameSmall,
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Divider(
        color: Colors.white.withOpacity(0.20),
      ),
    );
  }
}

class CustomDivider2 extends StatelessWidget {
  const CustomDivider2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Divider(
        color: Colors.white.withOpacity(0.20),
      ),
    );
  }
}

class HeadLineHome extends StatelessWidget {
  final String name;
  const HeadLineHome({
    Key key,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        name,
        style: TextStylePage.headingHome,
      ),
    );
  }
}

class HeadLineHome2 extends StatelessWidget {
  final String name;
  const HeadLineHome2({
    Key key,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        name,
        style: TextStylePage.productName,
      ),
    );
  }
}

class Popular {
  final String name;
  final IconData iconData;

  Popular({this.name, this.iconData});
}
