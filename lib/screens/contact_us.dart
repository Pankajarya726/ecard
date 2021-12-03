import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
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
              "Contact Us",
              style: GoogleFonts.poppins(),
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff33113A),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: Text(
                          "Contact Us",
                          style: TextStylePage.headingHome15,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 20, bottom: 20),
                        child: Text(
                          "Get In Touch.",
                          style: TextStylePage.headingHomeBigBold,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: Text(
                          "4554/71, street 80, Doha-Qatar",
                          style: TextStylePage.headingHome15,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: Text(
                          "Info@ecardsstore.com",
                          style: TextStylePage.headingHome15,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: Text(
                          "+974 3388 0097",
                          style: TextStylePage.headingHome15,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: Text(
                          "FOLLOW US",
                          style: TextStylePage.headingHome15,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: Row(
                          children: List.generate(
                            4,
                            (index) => Container(
                                height: 20,
                                width: 20,
                                margin: EdgeInsets.only(right: 15),
                                child: Image.asset("assets/$index.png")),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Container(
                      //   height: 3,
                      //   color: ColorsData.primaryColor,
                      // ),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.only(left: 15, right: 15, top: 5),
                      //   child: Text(
                      //     "REQUEST A CALL BACK",
                      //     style: TextStylePage.headingHome15,
                      //   ),
                      // ),
                      // doubleLieTextField(
                      //     name: "Subject", subTitle: "Purchase Process"),
                      // textField(name: "Note"),
                      // Padding(
                      //   padding: const EdgeInsets.all(25.0),
                      //   child: Container(
                      //     width: MediaQuery.of(context).size.width * 0.85,
                      //     height: 55,
                      //     decoration: BoxDecoration(
                      //         gradient: const LinearGradient(
                      //             colors: [
                      //               Color(0xFF0FA3E4),
                      //               Color(0xFF841981),
                      //             ],
                      //             begin: FractionalOffset(0.0, 0.0),
                      //             end: FractionalOffset(1.0, 0.0),
                      //             stops: [0.0, 1.0]),
                      //         borderRadius: BorderRadius.circular(100)),
                      //     child: Material(
                      //       color: Colors.transparent,
                      //       child: InkWell(
                      //         onTap: () {},
                      //         child: Center(
                      //           child: Text(
                      //             "SUBMIT",
                      //             style: TextStylePage.headingHomeBold,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
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

  Padding doubleLieTextField({String name, String subTitle}) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsData.primaryColor,
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
                height: 10,
              ),
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "$subTitle",
                              hintStyle: TextStylePage.productName,
                              counterStyle: TextStylePage.productName),
                          style: TextStylePage.productName,
                          maxLines: 1,
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

  Padding textField({String name}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsData.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "$name",
                      hintStyle: TextStylePage.textFieldStyle),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
