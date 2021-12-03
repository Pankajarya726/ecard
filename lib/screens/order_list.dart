import 'package:e_card/providers/order_details_provider.dart';
import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/screens/my_purchases.dart';
import 'package:e_card/utils/slide_route.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  void initState() {
    Provider.of<WoocommerceProvider>(context, listen: false).getOrder();
    super.initState();
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
              "My Purchases",
              style: GoogleFonts.poppins(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child:
                Consumer<WoocommerceProvider>(builder: (context, snapshot, _) {
              return snapshot.orderLoad
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: snapshot.orderList?.length,
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) {
                        return Container(
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 15),
                            height: 120,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF603a5a),
                                      Color(0xFF340633),
                                    ],
                                    begin: FractionalOffset(0.0, 3.0),
                                    end: FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0]),
                                borderRadius: BorderRadius.circular(10)),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Provider.of<OrderDetailsProvider>(context,
                                          listen: false)
                                      .makeLoad();
                                  Navigator.push(
                                    context,
                                    SlideRightRoute(
                                      page: MyPurchases(
                                        orderId:
                                            snapshot.orderList[i].id.toString(),
                                        paymentMethod: snapshot
                                            .orderList[i].paymentMethod
                                            .toString(),
                                        shipping:
                                            snapshot.orderList[i].shipping,
                                        status: snapshot.orderList[i].status,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3),
                                              child: Text(
                                                "${snapshot.orderList[i].status[0].toUpperCase()}${snapshot.orderList[i].status.substring(1)}",
                                                style: TextStylePage
                                                    .priceSmallGreen,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.edit,
                                              size: 15, color: Colors.white),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Order Id",
                                            style:
                                                TextStylePage.productNameWhite,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Expanded(child: SizedBox()),
                                          Text(
                                            "${snapshot.orderList[i].id}",
                                            style:
                                                TextStylePage.productNameWhite,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.date_range,
                                              size: 15, color: Colors.white),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Order Date",
                                            style:
                                                TextStylePage.productNameWhite,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Expanded(child: SizedBox()),
                                          Text(
                                            "${snapshot.orderList[i].dateCreated}",
                                            style:
                                                TextStylePage.productNameWhite,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      });
            }),
          ),
        ),
      ],
    );
  }
}
