import 'package:e_card/providers/bottom_navigation_bar_provider.dart';
import 'package:e_card/providers/filter_provider.dart';
import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/screens/filter.dart';
import 'package:e_card/screens/home.dart';
import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/filter_icon_icons.dart';
import 'package:e_card/utils/slide_route.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'details_page.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                BottomNavigationBarProvider naveProvider =
                    Provider.of<BottomNavigationBarProvider>(context,
                        listen: false);
                FocusScope.of(context).requestFocus(FocusNode());
                naveProvider.changeIndex(0);
              },
              icon: Icon(Icons.arrow_back),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Search",
              style: GoogleFonts.poppins(),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: ColorsData.primaryColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50), topLeft: Radius.circular(50)),
              // boxShadow: [
              //   BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              // ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color:
                                  ColorsData.textFieldColor.withOpacity(0.20),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                      style: TextStylePage.headingHome15,
                                      onChanged: (v) {
                                        FilterProvider filter =
                                            Provider.of<FilterProvider>(context,
                                                listen: false);
                                        filter.changeText(v);
                                        Provider.of<WoocommerceProvider>(
                                                context,
                                                listen: false)
                                            .searchProduct(v, filter.selectedID,
                                                filter.low, filter.high);
                                      },
                                      onEditingComplete: () {},
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          hintText: "Search games, apps..",
                                          hintStyle:
                                              TextStylePage.textFieldStyle),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                SlideRightRoute(
                                  page: Filter(
                                    from: false,
                                    price: true,
                                  ),
                                ),
                              );
                            },
                            child: Center(
                              child: Icon(FilterIcon.filter),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                  Expanded(
                    child: Consumer<WoocommerceProvider>(
                        builder: (context, snapshot, _) {
                      return Container(
                        child: snapshot.searchLoad
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView(
                                children: [
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (ctx, i) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          color: Color(0xff230c30),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  SlideRightRoute(
                                                    page: DetailsPage(
                                                      wooProduct: snapshot
                                                          .searchList[i],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8,
                                                        vertical: 5),
                                                    child: Container(
                                                      height: width * 0.25,
                                                      width: width * 0.20,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        child: snapshot
                                                                .searchList[i]
                                                                .images
                                                                .isEmpty
                                                            ? Image.asset(
                                                                "assets/erro.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.network(
                                                                snapshot
                                                                    .searchList[
                                                                        i]
                                                                    .images[0]
                                                                    .src,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: HeadLineHome(
                                                      name:
                                                          "${snapshot.searchList[i].name}",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: snapshot.searchList.length,
                                  )
                                ],
                              ),
                      );
                    }),
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
