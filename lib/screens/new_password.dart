import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewPassword extends StatefulWidget {
  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
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
              "New Password",
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
                            child: Image.asset("assets/lock.png"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          textField(name: "Password"),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 15, right: 15),
                            child: TextField(
                              style: TextStylePage.headingHome15,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorsData.textFieldColorLightWhite
                                          .withOpacity(
                                        0.40,
                                      ),
                                      width: 2),
                                  borderRadius: BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      color: Color(0xff89137D), width: 2),
                                ),
                                suffixIcon: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Color(0xff89137D),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "Confirm Password",
                              ),
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
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Submit",
                                          style: TextStylePage.headingHomeBold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
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

  Padding textField({String name}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: TextField(
        style: TextStylePage.headingHome15,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorsData.textFieldColorLightWhite.withOpacity(
                  0.40,
                ),
                width: 2),
            borderRadius: BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(color: Color(0xff89137D), width: 2),
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          hintText: "$name",
        ),
      ),
    );
  }
}
