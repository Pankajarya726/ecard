import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/screens/home.dart';
import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class RatingAndReview extends StatefulWidget {
  final int id;
  final String name;
  final String image;
  final int ratingCount;
  final dynamic rating;

  const RatingAndReview(
      {Key key,
      @required this.id,
      @required this.name,
      @required this.image,
      @required this.ratingCount,
      @required this.rating})
      : super(key: key);
  @override
  _RatingAndReviewState createState() => _RatingAndReviewState();
}

class _RatingAndReviewState extends State<RatingAndReview> {
  ScrollController scrollController = ScrollController();
  TextEditingController description = TextEditingController();
  @override
  void initState() {
    WoocommerceProvider woocommerceProvider =
        Provider.of<WoocommerceProvider>(context, listen: false);
    Future.delayed(Duration(microseconds: 10), () {
      woocommerceProvider.getReview(id: widget.id, index: 1);
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (woocommerceProvider.reviewModelAll.length > 10) {
          double index = (woocommerceProvider.reviewModelAll.length / 10) + 1;
          woocommerceProvider.getReview(id: widget.id, index: index.floor());
        }
      }
    });
    super.initState();
  }

  //here goes the function
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  @override
  void dispose() {
    scrollController.dispose();
    description.dispose();
    super.dispose();
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
              "Rating & Reviews",
              style: GoogleFonts.sourceSansPro(),
            ),
          ),
          body: Consumer<WoocommerceProvider>(builder: (context, snapshot, _) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    child: ListView(
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                          height: 200,
                          decoration: BoxDecoration(
                              color: Color(0xFF340633),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: double.infinity,
                                  margin: const EdgeInsets.only(
                                      top: 15, bottom: 15),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black38,
                                          blurRadius: 5.0,
                                        ),
                                      ]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      widget.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      HeadLineHome2(
                                        name: "${widget.name}",
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.amber,
                                                  shape: BoxShape.circle),
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
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
                                            Text(
                                              "${widget.rating}",
                                              style: TextStylePage.headingHome,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: SizedBox(),
                                            ),
                                            Text(
                                              "${widget.ratingCount} Reviews",
                                              style: TextStylePage.viewAll,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        if (snapshot.load && snapshot.reviewModelAll.isEmpty)
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        else
                          ListView.separated(
                            itemCount: snapshot.reviewModelAll.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (ctx, i) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, right: 25),
                                child: Divider(
                                  color: Colors.grey.shade700,
                                ),
                              );
                            },
                            itemBuilder: (ctx, i) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 50,
                                              child: Image.asset(
                                                  "assets/person.png"),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${_parseHtmlString(snapshot.reviewModelAll[i].reviewer)}",
                                              style: TextStylePage.productName,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                for (int k = 0; k < 5; k++)
                                                  Icon(
                                                    Icons.star,
                                                    color: snapshot
                                                                .reviewModelAll[
                                                                    i]
                                                                .rating >=
                                                            k + 1
                                                        ? Color(0xfff9b701)
                                                        : Colors.black12,
                                                    size: 15,
                                                  ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  "${snapshot.reviewModelAll[i].dateCreated.toString()}",
                                                  style: TextStylePage
                                                      .productNameSmall,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${_parseHtmlString(snapshot.reviewModelAll[i].review)}",
                                              style: TextStylePage
                                                  .productNameSmall,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            // Text(
                                            //   "Good ! Super Product fast delivery",
                                            //   style: TextStylePage.productNameSmall,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        if (snapshot.reviewModelAll.isNotEmpty &&
                            snapshot.paginationLoad)
                          Center(
                            child: CircularProgressIndicator(),
                          )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 55,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          showMaterialModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Consumer<WoocommerceProvider>(
                                  builder: (context, snapshot, _) {
                                return SingleChildScrollView(
                                  controller: ModalScrollController.of(context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Rate this Product",
                                            style: GoogleFonts.sourceSansPro(
                                              color: Colors.black38,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              for (int i = 0; i < 5; i++)
                                                Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      snapshot
                                                          .changeRating(i + 1);
                                                    },
                                                    child: Icon(
                                                      snapshot.rating >= i + 1
                                                          ? Icons.star
                                                          : Icons
                                                              .star_outline_outlined,
                                                      size: 40,
                                                      color: Color(0xfff9b701),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(
                                          //       top: 15, left: 15, right: 15),
                                          //   child: TextField(
                                          //     decoration: InputDecoration(
                                          //       border: OutlineInputBorder(
                                          //         borderRadius: BorderRadius.all(
                                          //           const Radius.circular(10.0),
                                          //         ),
                                          //       ),
                                          //       enabledBorder: OutlineInputBorder(
                                          //         borderSide: BorderSide(
                                          //             color: Colors.black12,
                                          //             width: 2),
                                          //         borderRadius: BorderRadius.all(
                                          //           const Radius.circular(10.0),
                                          //         ),
                                          //       ),
                                          //       disabledBorder:
                                          //           OutlineInputBorder(
                                          //         borderSide: BorderSide(
                                          //             color: Colors.black38,
                                          //             width: 2),
                                          //         borderRadius: BorderRadius.all(
                                          //           const Radius.circular(10.0),
                                          //         ),
                                          //       ),
                                          //       focusedBorder: OutlineInputBorder(
                                          //         borderRadius: BorderRadius.all(
                                          //             Radius.circular(4)),
                                          //         borderSide: BorderSide(
                                          //             color: Colors.black38,
                                          //             width: 2),
                                          //       ),
                                          //       hintStyle: TextStyle(
                                          //           color: Colors.black12),
                                          //       hintText: "Title",
                                          //     ),
                                          //   ),
                                          // ),
                                          // SizedBox(
                                          //   height: 10,
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, left: 15, right: 15),
                                            child: TextField(
                                              controller: description,
                                              maxLines: 5,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    const Radius.circular(10.0),
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black12,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    const Radius.circular(10.0),
                                                  ),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black38,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    const Radius.circular(10.0),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                  borderSide: BorderSide(
                                                      color: Colors.black38,
                                                      width: 2),
                                                ),
                                                hintStyle: TextStyle(
                                                    color: Colors.black12),
                                                hintText: "Description",
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          snapshot.creatingLoad
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : OutlineButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                  ),
                                                  onPressed: () {
                                                    snapshot.createRating(
                                                        email: snapshot.email,
                                                        name: snapshot.name,
                                                        ratings: snapshot.rating
                                                            .toString(),
                                                        review:
                                                            description.text,
                                                        id: widget.id
                                                            .toString(),
                                                        context: context);
                                                  },
                                                  borderSide: BorderSide(
                                                    color: Colors.black12,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: Text("SUBMIT"),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            "RATE THIS PRODUCT",
                            style: TextStyle(
                                color: ColorsData.primaryColor, fontSize: 20),
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
      ],
    );
  }
}
