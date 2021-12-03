import 'package:e_card/utils/colors_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStylePage {
  ///
  static TextStyle textFieldStyle = GoogleFonts.poppins(
      color: ColorsData.textFieldColorLightWhite.withOpacity(0.30),
      fontSize: 12);

  ///
  static TextStyle headingHome =
      GoogleFonts.sourceSansPro(color: Colors.white, fontSize: 18);

  ///
  static TextStyle bottomSheetText =
      GoogleFonts.sourceSansPro(color: Color(0xff89137D), fontSize: 18);

  ///
  static TextStyle headingHomeBold = GoogleFonts.sourceSansPro(
      color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

  ///
  static TextStyle headingHomeBold15 = GoogleFonts.sourceSansPro(
      color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold);

  ///
  static TextStyle headingHome15 = GoogleFonts.sourceSansPro(
    color: Colors.white,
    fontSize: 15,
  );

  ///
  static TextStyle whiteText = GoogleFonts.poppins(
      color: ColorsData.textFieldColorLightWhite, fontSize: 10);

  ///
  static TextStyle whiteTextBold = GoogleFonts.poppins(
      color: ColorsData.textFieldColorLightWhite,
      fontSize: 10,
      fontWeight: FontWeight.bold);

  ///
  static TextStyle viewAll = GoogleFonts.sourceSansPro(
      color: Colors.white.withOpacity(0.50), fontSize: 10);

  ///
  static TextStyle productName = GoogleFonts.poppins(
      color: ColorsData.textFieldColorLightWhite.withOpacity(0.50),
      fontSize: 15);

  ///
  static TextStyle productNameWhite =
      GoogleFonts.poppins(color: Colors.white, fontSize: 15);

  ///
  static TextStyle productNameSmall = GoogleFonts.poppins(
      color: ColorsData.textFieldColorLightWhite.withOpacity(0.50),
      fontSize: 10);

  ///
  static TextStyle price = GoogleFonts.poppins(
      color: ColorsData.priceColor, fontWeight: FontWeight.bold, fontSize: 16);

  ///
  static TextStyle priceSmall = GoogleFonts.poppins(
      color: ColorsData.priceColor, fontWeight: FontWeight.bold, fontSize: 10);

  ///
  static TextStyle priceSmallGreen = GoogleFonts.poppins(
      color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14);

  ///
  static TextStyle whiteSmall =
      GoogleFonts.sourceSansPro(color: Colors.white, fontSize: 10);

  ///
  static TextStyle whiteSmall15 =
      GoogleFonts.sourceSansPro(color: Colors.white, fontSize: 15);

  ///
  static TextStyle whiteSmall2 =
      GoogleFonts.sourceSansPro(color: Colors.white, fontSize: 14);

  ///
  static TextStyle headingHomeBig =
      GoogleFonts.sourceSansPro(color: Colors.white, fontSize: 24);

  ///
  static TextStyle headingHomeBig18 =
      GoogleFonts.sourceSansPro(color: Colors.white, fontSize: 18);

  ///
  static TextStyle headingHomeBigBold = GoogleFonts.sourceSansPro(
      color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold);

  ///
  static TextStyle productNameSmallGray = GoogleFonts.poppins(
      color: ColorsData.textFieldColorLightWhite.withOpacity(0.30),
      fontSize: 10);
}
