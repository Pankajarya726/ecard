import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/screens/sign_up.dart';
import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/slide_route.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  bool load = false;
  bool passwordHide = true;
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
              "Sign in",
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
                            child: Image.asset("assets/splashIcon.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 15, right: 15),
                            child: TextField(
                              controller: userName,
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
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "Email",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 15, right: 15),
                            child: TextField(
                              controller: password,
                              obscureText: passwordHide,
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
                                suffixIcon: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        passwordHide = !passwordHide;
                                      });
                                    },
                                    child: Icon(
                                      passwordHide
                                          ? Icons.visibility_off
                                          : Icons.remove_red_eye_outlined,
                                      color: Color(0xff89137D),
                                    ),
                                  ),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "Password",
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
                              child: load
                                  ? Center(child: CircularProgressIndicator())
                                  : Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          // Navigator.push(
                                          //   context,
                                          //   SlideRightRoute(
                                          //     page: BillingAddress(),
                                          //   ),
                                          // );
                                          setState(() {
                                            load = true;
                                          });
                                          Provider.of<WoocommerceProvider>(
                                                  context,
                                                  listen: false)
                                              .loginUser(
                                                  userName: userName.text,
                                                  password: password.text,
                                                  context: context)
                                              .then((value) {
                                            WoocommerceProvider
                                                woocommerceProvider = Provider
                                                    .of<WoocommerceProvider>(
                                                        context,
                                                        listen: false);

                                            if (woocommerceProvider.userId !=
                                                null) {}
                                            setState(() {
                                              load = false;
                                            });
                                          });
                                        },
                                        child: Center(
                                          child: Text(
                                            "Login",
                                            style:
                                                TextStylePage.headingHomeBold,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        SlideRightRoute(page: SignUp()),
                                      );
                                    },
                                    child: Text(
                                      "Don't have an account? ",
                                      style: TextStylePage.whiteSmall15,
                                    ),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        SlideRightRoute(page: SignUp()),
                                      );
                                    },
                                    child: Text(
                                      "SIGN UP",
                                      style: TextStylePage.whiteSmall15,
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
