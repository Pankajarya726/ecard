import 'dart:async';

import 'package:e_card/screens/new_password.dart';
import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/slide_route.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterOtp extends StatefulWidget {
  @override
  _EnterOtpState createState() => _EnterOtpState();
}

class _EnterOtpState extends State<EnterOtp> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
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
              "Forgot Password",
              style: GoogleFonts.poppins(),
            ),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(),
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
                Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            child: Image.asset("assets/email.png"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 40, left: 20, right: 20),
                            child: PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.bold,
                              ),
                              length: 6,
                              obscureText: false,
                              obscuringCharacter: '*',
                              animationType: AnimationType.fade,

                              pinTheme: PinTheme(
                                activeColor: ColorsData.textFieldColor,
                                inactiveFillColor: Colors.black26,
                                disabledColor: Colors.white,
                                shape: PinCodeFieldShape.box,
                                selectedColor: Colors.white30,
                                inactiveColor: Colors.white30,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight:
                                    MediaQuery.of(context).size.width * 0.12,
                                fieldWidth:
                                    MediaQuery.of(context).size.width * 0.12,
                                activeFillColor:
                                    hasError ? Colors.orange : Colors.white,
                              ),
                              cursorColor: Colors.white38,
                              animationDuration: Duration(milliseconds: 300),
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  height: 1.6,
                                  color: Colors.white),
                              backgroundColor: Colors.transparent,
                              enableActiveFill: false,
                              errorAnimationController: errorController,
                              controller: textEditingController,
                              keyboardType: TextInputType.number,
                              boxShadows: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 10,
                                )
                              ],
                              onCompleted: (v) {
                                print("Completed");
                              },
                              // onTap: () {
                              //   print("Pressed");
                              // },
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  currentText = value;
                                });
                              },
                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              width: double.infinity,
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
                                  borderRadius: BorderRadius.circular(5)),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      SlideRightRoute(
                                        page: NewPassword(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.transparent,
                                        ),
                                        Text(
                                          "Next",
                                          style: TextStylePage.headingHomeBold,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Didn't receive an email?",
                                  style: TextStylePage.whiteText,
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Text(
                                      "RESEND",
                                      style: TextStylePage.whiteText,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
