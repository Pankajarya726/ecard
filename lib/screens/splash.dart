import 'package:e_card/screens/bottom_navigation.dart';
import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/slide_route.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, SlideRightRoute(page: BottomNavigation()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: ColorsData.primaryColor,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Center(
                      child: Container(
                        height: 150,
                        width: 150,
                        child: Image.asset("assets/splashIcon.png"),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    child: Image.asset(
                      "assets/splashImage.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
