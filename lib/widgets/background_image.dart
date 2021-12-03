import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Image.asset(
        "assets/splash.png",
        fit: BoxFit.fill,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
