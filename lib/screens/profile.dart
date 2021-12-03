import 'package:e_card/providers/curency_switch_provider.dart';
import 'package:e_card/providers/currency_converter_provider.dart';
import 'package:e_card/providers/wallet_provider.dart';
import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/screens/about_us.dart';
import 'package:e_card/screens/contact_us.dart';
import 'package:e_card/screens/order_list.dart';
import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/profile_icon_icons.dart';
import 'package:e_card/utils/slide_route.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'favourite.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    WoocommerceProvider woocommerceProvider =
        Provider.of<WoocommerceProvider>(context, listen: false);

    if (woocommerceProvider.userId != null) {
      Provider.of<WalletProvider>(context, listen: false)
          .getWalletDetails(userID: woocommerceProvider.userId.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WoocommerceProvider>(builder: (context, snapshot, _) {
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
                "Profile",
                style: GoogleFonts.poppins(),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: Image.asset("assets/profile.png"),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (snapshot.userId != null)
                                Text(
                                  "${snapshot.name}",
                                  style: TextStylePage.headingHome,
                                )
                              else
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        SlideRightRoute(
                                          page: Login(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "LOGIN",
                                      style: TextStylePage.headingHome,
                                    ),
                                  ),
                                ),
                              if (snapshot.userId != null)
                                Text(
                                  "${snapshot.email}",
                                  style: TextStylePage.productNameSmallGray,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff33113A),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50)),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 25),
                      child: Consumer<WalletProvider>(
                          builder: (context, walletData, _) {
                        return ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            if (walletData.walletModel != null)
                              const SizedBox(
                                height: 20,
                              ),
                            if (walletData.walletModel != null)
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF5055AC),
                                          Color(0xFF841981),
                                        ],
                                        begin: FractionalOffset(0.0, 0.0),
                                        end: FractionalOffset(1.0, 0.0),
                                        stops: [0.0, 1.0]),
                                    borderRadius: BorderRadius.circular(19)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            color: Colors.black26,
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: Image.asset(
                                            "assets/walletNew.png",
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "BaLance".toUpperCase(),
                                                style: GoogleFonts.poppins(
                                                    color: Color(0xffE1E1E1),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Consumer<
                                                      CurrencyConverterProvider>(
                                                  builder:
                                                      (context, currency, _) {
                                                return Consumer<
                                                        CurrencySwitchProvider>(
                                                    builder:
                                                        (context, snapshot, _) {
                                                  return Text(
                                                    "${snapshot.currencyName.toUpperCase()} ${currency.getConvertedRate(rate: walletData.walletModel.data.balance.toString(), selectedCurrency: snapshot.currencyName)}"
                                                        .toUpperCase(),
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  );
                                                });
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    SlideRightRoute(page: Favourites()),
                                  );
                                },
                                child: ProfileTile(
                                  name: "MY WISH LIST",
                                  description: "Check your wish list",
                                  icon: Icons.favorite_outline,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (snapshot.userId != null)
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      SlideRightRoute(
                                        page: OrderList(),
                                      ),
                                    );
                                  },
                                  child: ProfileTile(
                                    name: "MY PURCHASES",
                                    description: "Check your purchase list",
                                    icon: ProfileIcon.package__1_,
                                  ),
                                ),
                              ),
                            if (snapshot.userId != null)
                              const SizedBox(
                                height: 10,
                              ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    SlideRightRoute(
                                      page: AboutUs(),
                                    ),
                                  );
                                },
                                child: ProfileTile(
                                  name: "ABOUT",
                                  description: "About ecards.com",
                                  icon: ProfileIcon.address,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    SlideRightRoute(
                                      page: ContactUs(),
                                    ),
                                  );
                                },
                                child: ProfileTile(
                                  name: "CONTACT US",
                                  description: "get in touch",
                                  icon: ProfileIcon.support,
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Material(
                            //   color: Colors.transparent,
                            //   child: InkWell(
                            //     onTap: () {
                            //       Navigator.push(
                            //         context,
                            //         SlideRightRoute(
                            //           page: Notifications(),
                            //         ),
                            //       );
                            //     },
                            //     child: ProfileTile(
                            //       name: "NOTIFICATION",
                            //       description: "Notification",
                            //       icon: ProfileIcon.bell,
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 30,
                            ),
                            // Padding(
                            //   padding: EdgeInsets.symmetric(
                            //     vertical: 25,
                            //     horizontal:
                            //         MediaQuery.of(context).size.width * 0.15,
                            //   ),
                            //   child: Container(
                            //     width: MediaQuery.of(context).size.width * 0.85,
                            //     height: 55,
                            //     decoration: BoxDecoration(
                            //         color: Colors.transparent,
                            //         border: Border.all(
                            //             color: ColorsData.primaryColor, width: 1.5),
                            //         borderRadius: BorderRadius.circular(100)),
                            //     child: Material(
                            //       color: Colors.transparent,
                            //       child: InkWell(
                            //         onTap: () {
                            //           Navigator.push(
                            //             context,
                            //             SlideRightRoute(
                            //               page: ForgetPassword(),
                            //             ),
                            //           );
                            //         },
                            //         child: Center(
                            //           child: Text(
                            //             "CHANGE PASSWORD",
                            //             style: TextStylePage.headingHomeBold,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Consumer<WoocommerceProvider>(
                                builder: (context, snapshot, _) {
                              return snapshot.token != null
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        height: 55,
                                        decoration: BoxDecoration(
                                            color: ColorsData.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              // snapshot.logout();
                                              showAlertDialog(context, () {
                                                snapshot.logout().then((value) {
                                                  Provider.of<WalletProvider>(
                                                          context,
                                                          listen: false)
                                                      .makeNull();
                                                  Navigator.pop(context);
                                                });
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                "LOG OUT",
                                                style: TextStylePage
                                                    .headingHomeBold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox();
                            }),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  showAlertDialog(BuildContext context, Function f) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Logout"),
      onPressed: f,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure"),
      content: Text("Are you sure to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  const ProfileTile({
    Key key,
    this.name,
    this.description,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorsData.primaryColor,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$name",
                      style: TextStylePage.headingHome,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "$description",
                      style: TextStylePage.productNameSmallGray,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
