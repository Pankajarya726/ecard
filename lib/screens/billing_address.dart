import 'package:country_picker/country_picker.dart';
import 'package:e_card/models/cart_model.dart';
import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/screens/payment.dart';
import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/slide_route.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/utils/toast_util.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BillingAddress extends StatefulWidget {
  final String total;
  final List<CartModel> list;

  const BillingAddress({Key key, @required this.total, @required this.list})
      : super(key: key);
  @override
  _BillingAddressState createState() => _BillingAddressState();
}

class _BillingAddressState extends State<BillingAddress> {
  String selectedCountry = "Qatar";
  String selectedPhone = "974";

  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController zipCode = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    mobile.dispose();
    city.dispose();
    address.dispose();
    state.dispose();
    zipCode.dispose();
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
              "Billing Address",
              style: GoogleFonts.poppins(),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Color(0xff0f0211),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50), topLeft: Radius.circular(50)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
              child: ListView(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "BILLING ADDRESS",
                      style: TextStylePage.productName,
                    ),
                  ),
                  textField(name: "Name", textEditingController: name),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 80,
                          decoration: BoxDecoration(
                            color: ColorsData.textFieldColor.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Center(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    showCountryPicker(
                                      context: context,
                                      showPhoneCode:
                                          true, // optional. Shows phone code before the country name.
                                      onSelect: (Country country) {
                                        setState(() {
                                          selectedPhone = country.phoneCode;
                                        });
                                      },
                                    );
                                  },
                                  child: Text(
                                    "+$selectedPhone",
                                    style: TextStylePage.textFieldStyle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color:
                                  ColorsData.textFieldColor.withOpacity(0.20),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                controller: mobile,
                                keyboardType: TextInputType.phone,
                                style: TextStylePage.productNameWhite,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: "Mobile Number",
                                    hintStyle: TextStylePage.textFieldStyle),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorsData.textFieldColor.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Country",
                              style: TextStylePage.productNameSmallGray,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: Container(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      showCountryPicker(
                                        context: context,
                                        showPhoneCode:
                                            false, // optional. Shows phone code before the country name.
                                        onSelect: (Country country) {
                                          setState(() {
                                            selectedCountry = country.name;
                                          });
                                        },
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        // Container(
                                        //   height: 25,
                                        //   width: 25,
                                        //   child: Image.asset("assets/qatar.png"),
                                        // ),
                                        // SizedBox(
                                        //   width: 10,
                                        // ),
                                        Text(
                                          selectedCountry,
                                          style: TextStylePage.headingHomeBold,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  doubleLieTextField(
                      name: "City", space: false, textEditingController: city),
                  doubleLieTextField(
                      name: "Address",
                      space: false,
                      textEditingController: address),
                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       width: 15,
                  //     ),
                  //     Expanded(
                  //       child: doubleLieTextField(
                  //           name: "State",
                  //           space: true,
                  //           textEditingController: state),
                  //     ),
                  //     // Expanded(
                  //     //   child: doubleLieTextField(
                  //     //       name: "Flat No: (optional no need*)", space: true),
                  //     // ),
                  //   ],
                  // ),
                  // doubleLieTextField(
                  //     name: "Zip code",
                  //     space: false,
                  //     textEditingController: zipCode),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 55,
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
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (name.text.isEmpty) {
                              successToast("Give Your name");
                            } else if (mobile.text.length < 5) {
                              successToast("Enter Valid Number");
                            } else if (selectedCountry == "COUNTRY") {
                              successToast("Please Select a Country");
                            } else if (city.text.isEmpty) {
                              successToast("Please Give city Name");
                            } else if (address.text.isEmpty) {
                              successToast("Enter Valid Address");
                            }
                            // else
                            //   if (state.text.isEmpty) {
                            //   successToast("Please Enter State Name");
                            // } else if (zipCode.text.isEmpty) {
                            //   successToast("Please Enter Zip code");
                            // }
                            else {
                              WoocommerceProvider woocommerce =
                                  Provider.of<WoocommerceProvider>(context,
                                      listen: false);
                              final Map<String, String> billingAddress = {
                                "first_name": name.text,
                                "last_name": name.text,
                                "address_1": address.text,
                                "city": city.text,
                                // "state": state.text,
                                // "postcode": zipCode.text,
                                "country": selectedCountry,
                                "email": woocommerce.email,
                                "phone": "$selectedPhone${mobile.text}",
                              };

                              // {
                              //   "name": name.text,
                              //   "countryCode": selectedPhone,
                              //   "mobile": mobile.text,
                              //   "country": selectedCountry,
                              //   "city": city.text,
                              //   "address": address.text,
                              //   "state": state.text,
                              //   ""
                              // }

                              Navigator.push(
                                context,
                                SlideRightRoute(
                                  page: Payment(
                                    billingAddress: billingAddress,
                                    total: widget.total,
                                    list: widget.list,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Center(
                            child: Text(
                              "CONTINUE",
                              style: TextStylePage.headingHomeBold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding doubleLieTextField(
      {@required String name,
      @required bool space,
      @required TextEditingController textEditingController}) {
    return Padding(
      padding: EdgeInsets.only(left: space ? 0 : 15, right: 15, top: 15),
      child: Container(
        height: 65,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsData.textFieldColor.withOpacity(0.20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$name",
                style: TextStylePage.productNameSmallGray,
              ),
              SizedBox(
                height: 0,
              ),
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "",
                                hintStyle: TextStylePage.headingHomeBold,
                                counterStyle: TextStylePage.headingHomeBold,
                                contentPadding:
                                    EdgeInsets.only(left: 0, right: 0)),
                            style: TextStylePage.headingHomeBold,
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
      ),
    );
  }

  Padding textField(
      {@required String name,
      @required TextEditingController textEditingController}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsData.textFieldColor.withOpacity(0.20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  style: TextStylePage.productNameWhite,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "$name",
                    hintStyle: TextStylePage.textFieldStyle,
                    counterStyle: TextStylePage.productNameWhite,
                    labelStyle: TextStylePage.productNameWhite,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
