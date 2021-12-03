import 'package:dotted_line/dotted_line.dart';
import 'package:e_card/models/order_model.dart';
import 'package:e_card/providers/curency_switch_provider.dart';
import 'package:e_card/providers/currency_converter_provider.dart';
import 'package:e_card/providers/order_cancel_provider.dart';
import 'package:e_card/providers/order_details_provider.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyPurchases extends StatefulWidget {
  final String orderId;
  final Ing shipping;
  final String status;
  final String paymentMethod;

  const MyPurchases({
    Key key,
    this.orderId,
    this.shipping,
    this.status,
    @required this.paymentMethod,
  }) : super(key: key);
  @override
  _MyPurchasesState createState() => _MyPurchasesState();
}

class _MyPurchasesState extends State<MyPurchases> {
  @override
  void initState() {
    Provider.of<OrderDetailsProvider>(context, listen: false)
        .getOrderDetails(orderId: widget.orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CurrencySwitchProvider currencySwitchProvider =
        Provider.of<CurrencySwitchProvider>(context);
    CurrencyConverterProvider currencyConverterProvider =
        Provider.of<CurrencyConverterProvider>(context);
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
              "My Purchases",
              style: GoogleFonts.poppins(),
            ),
          ),
          body: Consumer<OrderDetailsProvider>(builder: (context, snapshot, _) {
            return snapshot.load
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.asset(
                                    "assets/ecardLogo.png",
                                    width: 50,
                                  ),
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              if (snapshot.orderDetailsModel.data.refund == 0)
                                if (widget.status != "refunded")
                                  Consumer<OrderCancelProvider>(
                                      builder: (context, orderCancel, _) {
                                    return orderCancel.loadTop
                                        ? Container(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator(),
                                          )
                                        : Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                orderCancel.cancelOrder(
                                                    orderID: widget.orderId
                                                        .toString(),
                                                    from: true,
                                                    context: context);
                                              },
                                              child: Text(
                                                "Refund".toUpperCase(),
                                                style: GoogleFonts.poppins(
                                                    color: Color(0xff89137D),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                          );
                                  })
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order NO: #${snapshot.orderDetailsModel.data.id}",
                                    style: GoogleFonts.poppins(
                                        color: Color(0xff39103E),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    "Order Placed :${snapshot.orderDetailsModel.data.orderPlaced}",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 9,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    "${snapshot.orderDetailsModel.data.totalItems} items",
                                    style: GoogleFonts.poppins(
                                        color: Color(0xffA8A8A8),
                                        fontSize: 8,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              Text(
                                "${currencySwitchProvider.currencyName.toUpperCase()} ${currencyConverterProvider.getConvertedRate(rate: snapshot.orderDetailsModel.data.total.toString(), selectedCurrency: currencySwitchProvider.currencyName)}",
                                style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xffF6F6F6),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  topLeft: Radius.circular(50)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ListView(
                                physics: BouncingScrollPhysics(),
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          topLeft: Radius.circular(30)),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15,
                                              left: 15,
                                              top: 35,
                                              bottom: 10),
                                          child: ListView.separated(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (ctx, i) {
                                                return Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${snapshot.orderDetailsModel.data.products[i].quantity}x",
                                                      style: GoogleFonts.roboto(
                                                          color:
                                                              Color(0xff7A7A7A),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${snapshot.orderDetailsModel.data.products[i].name}",
                                                              style: GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            if (snapshot
                                                                        .orderDetailsModel
                                                                        .data
                                                                        .products[
                                                                            i]
                                                                        .voucher !=
                                                                    null &&
                                                                snapshot
                                                                    .orderDetailsModel
                                                                    .data
                                                                    .products[i]
                                                                    .voucher
                                                                    .isNotEmpty)
                                                              ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    NeverScrollableScrollPhysics(),
                                                                itemCount: snapshot
                                                                    .orderDetailsModel
                                                                    .data
                                                                    .products[i]
                                                                    .voucher
                                                                    .length,
                                                                itemBuilder:
                                                                    (ctx, index) =>
                                                                        Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Pin :  ${snapshot.orderDetailsModel.data.products[i].voucher[index].pin}",
                                                                      style: GoogleFonts.poppins(
                                                                          color: Color(
                                                                              0xffAFAFAF),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Text(
                                                                      "Serial :  ${snapshot.orderDetailsModel.data.products[i].voucher[index].serial}",
                                                                      style: GoogleFonts.poppins(
                                                                          color: Color(
                                                                              0xffAFAFAF),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Text(
                                                                      "Expires on : ${snapshot.orderDetailsModel.data.products[i].voucher[index].expires}",
                                                                      style: GoogleFonts.poppins(
                                                                          color: Color(
                                                                              0xffAFAFAF),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              5),
                                                                      child: snapshot.orderDetailsModel.data.products[i].voucher.length - 1 ==
                                                                              index
                                                                          ? SizedBox()
                                                                          : Divider(),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "${currencySwitchProvider.currencyName.toUpperCase()} ${currencyConverterProvider.getConvertedRate(rate: snapshot.orderDetailsModel.data.products[i].subTotal.toString(), selectedCurrency: currencySwitchProvider.currencyName)}",
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder: (ctx, i) =>
                                                  Divider(),
                                              itemCount: snapshot
                                                  .orderDetailsModel
                                                  .data
                                                  .products
                                                  .length),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: DottedLine(
                                            direction: Axis.horizontal,
                                            lineLength: double.infinity,
                                            lineThickness: 1.0,
                                            dashLength: 4.0,
                                            dashColor: Colors.black26,
                                            dashRadius: 0.0,
                                            dashGapLength: 4.0,
                                            dashGapColor: Colors.transparent,
                                            dashGapRadius: 0.0,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15, top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Sub Total",
                                                style: GoogleFonts.poppins(
                                                    color: Color(0xFFA8A8A8),
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              Text(
                                                "${currencySwitchProvider.currencyName.toUpperCase()} ${currencyConverterProvider.getConvertedRate(rate: snapshot.orderDetailsModel.data.subTotal.toString(), selectedCurrency: currencySwitchProvider.currencyName)}",
                                                style: GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              )
                                            ],
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(
                                        //       left: 15, right: 15, top: 10),
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.spaceBetween,
                                        //     children: [
                                        //       Text(
                                        //         "Shipping",
                                        //         style: GoogleFonts.poppins(
                                        //             color: Color(0xFFA8A8A8),
                                        //             fontSize: 13,
                                        //             fontWeight:
                                        //                 FontWeight.normal),
                                        //       ),
                                        //       Text(
                                        //         "${currencySwitchProvider.currencyName.toUpperCase()} 00.00",
                                        //         style: GoogleFonts.roboto(
                                        //             color: Color(0xFFF93C01),
                                        //             fontSize: 16,
                                        //             fontWeight:
                                        //                 FontWeight.w600),
                                        //       )
                                        //     ],
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15, top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Total".toUpperCase(),
                                                style: GoogleFonts.poppins(
                                                    color: Color(0xFFA8A8A8),
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              Text(
                                                "${currencySwitchProvider.currencyName.toUpperCase()} ${currencyConverterProvider.getConvertedRate(rate: snapshot.orderDetailsModel.data.total.toString(), selectedCurrency: currencySwitchProvider.currencyName)}",
                                                style: GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Divider(),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/card.png",
                                                height: 20,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Payment Method",
                                                        style: GoogleFonts.roboto(
                                                            color: Color(
                                                                    0xff989898)
                                                                .withOpacity(
                                                                    0.5),
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                        widget.paymentMethod
                                                            .toUpperCase(),
                                                        style:
                                                            GoogleFonts.roboto(
                                                                color: Color(
                                                                    0xff989898),
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(30),
                                          bottomRight: Radius.circular(30)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "Shipping to :".toUpperCase(),
                                            style: GoogleFonts.roboto(
                                                color: Color(0xff989898)
                                                    .withOpacity(0.5),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${widget.shipping.firstName ?? ""} ${widget.shipping.lastName ?? ""} ${widget.shipping.email ?? ""} ${widget.shipping.phone ?? ""} ${widget.shipping.address1 ?? ""}",
                                            style: GoogleFonts.roboto(
                                                color: Color(0xff989898),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  if (snapshot.orderDetailsModel.data.refund ==
                                      0)
                                    if (widget.status != "refunded")
                                      Consumer<OrderCancelProvider>(
                                          builder: (context, orderCancel, _) {
                                        return Container(
                                          height: 50,
                                          child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              elevation: 0,
                                              color: Color(0xff39103E),
                                              child: orderCancel.loadBottom
                                                  ? Container(
                                                      height: 30,
                                                      width: 30,
                                                      child:
                                                          CircularProgressIndicator())
                                                  : Text(
                                                      "REQUEST REFUND",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                              onPressed: orderCancel.loadBottom
                                                  ? () {}
                                                  : () {
                                                      orderCancel.cancelOrder(
                                                          orderID: widget
                                                              .orderId
                                                              .toString(),
                                                          from: false,
                                                          context: context);
                                                    }),
                                        );
                                      }),
                                  SizedBox(
                                    height: 50,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          }),
        ),
      ],
    );
  }
}

// class ListViewPurchaseOld extends StatelessWidget {
//   const ListViewPurchaseOld({
//     Key key,
//     @required this.widget,
//     @required this.widget,
//     @required this.widget,
//   }) : super(key: key);
//
//   final MyPurchases widget;
//   final MyPurchases widget;
//   final MyPurchases widget;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: widget.lineItems.length,
//         shrinkWrap: true,
//         itemBuilder: (ctx, i) {
//           return Container(
//             margin: EdgeInsets.only(left: 15, right: 15, top: 15),
//             height: 110,
//             decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                     colors: [
//                       Color(0xFF603a5a),
//                       Color(0xFF340633),
//                     ],
//                     begin: FractionalOffset(0.0, 3.0),
//                     end: FractionalOffset(1.0, 0.0),
//                     stops: [0.0, 1.0]),
//                 borderRadius: BorderRadius.circular(10)),
//             child: Row(
//               children: [
//                 const SizedBox(
//                   width: 15,
//                 ),
//                 // Expanded(
//                 //   flex: 1,
//                 //   child: Container(
//                 //     height: double.infinity,
//                 //     margin: const EdgeInsets.only(top: 15, bottom: 15),
//                 //     decoration: BoxDecoration(
//                 //         color: Colors.transparent,
//                 //         boxShadow: [
//                 //           BoxShadow(
//                 //             color: Colors.black38,
//                 //             blurRadius: 5.0,
//                 //           ),
//                 //         ]),
//                 //     child: ClipRRect(
//                 //       borderRadius: BorderRadius.circular(6),
//                 //       child: Image.network(
//                 //         "https://i.pinimg.com/736x/60/a1/9c/60a19cba95c35d6ac6913607cbb6e5b8.jpg",
//                 //         fit: BoxFit.cover,
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         HeadLineHome(
//                           name: "${widget.lineItems[i].name}",
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 15),
//                           child: ProductNameSmall(
//                             name: "PRICE",
//                           ),
//                         ),
//                         Consumer<CurrencySwitchProvider>(
//                             builder: (context, snapshot, _) {
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 15),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: widget.lineItems[i].price.toString(), selectedCurrency: snapshot.currencyName)}",
//                                   style: TextStylePage.price,
//                                 ),
//                                 Text(
//                                   "  ${snapshot.currencyName}",
//                                   style: TextStylePage.priceSmall,
//                                 ),
//                               ],
//                             ),
//                           );
//                         }),
//                         // const SizedBox(
//                         //   height: 20,
//                         // ),
//                         // Padding(
//                         //   padding:
//                         //       const EdgeInsets.symmetric(horizontal: 15),
//                         //   child: Row(
//                         //     crossAxisAlignment: CrossAxisAlignment.start,
//                         //     children: [
//                         //       Text(
//                         //         "Expire On ",
//                         //         style: TextStylePage.whiteText,
//                         //       ),
//                         //       Text(
//                         //         " 29 AUG 2021",
//                         //         style: TextStylePage.whiteTextBold,
//                         //       )
//                         //     ],
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }
// }
