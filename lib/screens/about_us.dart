import 'package:e_card/utils/text_style.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
                          Container(
                            margin: EdgeInsets.all(15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Color(0xff33113A),
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "About Us",
                                    style: TextStylePage.headingHome,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    """ecardsstore.com is the online portal of Digital goods. We offering the latest collection of Gifting cards,Gaming cards.

With over a decade of experience in IT Online store, ecardsstore has been able to create the most trusted digital brand not just in Doha, but all over Qatar. Our deep understanding of what the customers want and an unmatched product knowledge helps us in providing a satisfying shopping experience.

ecardsstore.com  promises to offer you a hassle-free shopping experience of digital gadgets at the comfort of your choice with competitive pricing, multiple payment options, great after purchase assistance. Online shopping at ecardsstore.com  is simple, fast and 100% secure.""",
                                    style: TextStylePage.whiteText,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
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
}
