import 'dart:ui';

import 'package:e_card/providers/bottom_navigation_bar_provider.dart';
import 'package:e_card/screens/bottom_navigation.dart';
import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/slide_route.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPlaced extends StatefulWidget {
  final String id;

  const OrderPlaced({Key key, @required this.id}) : super(key: key);
  @override
  _OrderPlacedState createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
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
          ),
          body: Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     IconButton(
              //         icon: Icon(
              //           Icons.close,
              //           color: Colors.white,
              //         ),
              //         onPressed: () {}),
              //   ],
              // ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff0f0211),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50)),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 100,
                                child: Image.asset("assets/done.png"),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Order Placed",
                                style: TextStylePage.headingHomeBold,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Your Order #${widget.id} was placed with SUCCESS.\n You can see the status of the order at any time",
                                style: TextStylePage.productNameSmall,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 25,
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.15,
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: ColorsData.textFieldColor
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Provider.of<BottomNavigationBarProvider>(
                                                context,
                                                listen: false)
                                            .changeIndex(0);
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            SlideRightRoute(
                                                page: BottomNavigation()),
                                            (route) => false);
                                      },
                                      child: Center(
                                        child: Text(
                                          "CLOSE",
                                          style: TextStylePage.headingHomeBold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          child: Image.asset(
                            "assets/splashImage.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
