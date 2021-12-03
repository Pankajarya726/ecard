import 'package:e_card/screens/enter_otp.dart';
import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/slide_route.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';

class MassageSent extends StatefulWidget {
  @override
  _MassageSentState createState() => _MassageSentState();
}

class _MassageSentState extends State<MassageSent> {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                ],
              ),
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
                                child: Image.asset("assets/mail.png"),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Message Sent",
                                style: TextStylePage.headingHomeBold,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "A message has been sent\nto yo by email with instructions on\nhow to reset your password.",
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
                                        Navigator.push(
                                          context,
                                          SlideRightRoute(
                                            page: EnterOtp(),
                                          ),
                                        );
                                      },
                                      child: Center(
                                        child: Text(
                                          "DONE",
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
