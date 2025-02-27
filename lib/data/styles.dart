import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color primary = const Color.fromRGBO(0,0,0,1);

Color primary = const Color(0xff1890ff);


class Styles {
  static Color primaryColor = primary;
  static Color accentColor = const Color(0xffb2ffff);
  static Color secondaryColor = const Color(0xff1D2B32);
  static Color whiteBackground = const Color(0xfff2f2f2);
  static Color textColor = const Color(0xff333333);
  static Color grayTextColor = const Color(0xff808080);
  static Color lightGrayTextColor = const Color(0xffbdbdbd);
  static Color whiteTextColor = const Color(0xffffffff);
  static Color successTextColor = const Color(0xff189A18);
  static Color successBackgroundColor = const Color(0xffD3F8D3);
  static Color infoTextColor = const Color(0xff047aa5);
  static Color infoBackgroundColor = const Color(0xffd5d5ff);
  static Color failureTextColor = const Color(0xffFF4D4D);
  static Color failureBackgroundColor = const Color(0xffFFCCCC);
  static Color darkerBackgroundColor = const Color(0xffe2e4e2);
  static Color darkestBackgroundColor = const Color(0xffcecece);
  static Color primarySlightColor = const Color(0xffffabb5);
  static Color creamyGray = const Color(0xffE2E3E2);
  static Color tan = const Color(0xfff2b883);
  static Color darkTan = const Color(0xffc06834);
  static Color darkGreen = const Color(0xff64814d);

  static TextStyle normalStyle = GoogleFonts.roboto(fontSize: 14, color: textColor, fontWeight: FontWeight.w500);
  static TextStyle header1 = GoogleFonts.roboto(fontSize: 24, color: textColor, fontWeight: FontWeight.w500);
  static TextStyle header2 = GoogleFonts.roboto(fontSize: 18, color: textColor, fontWeight: FontWeight.w500);
  static TextStyle header3 = GoogleFonts.roboto(fontSize: 15, color: textColor, fontWeight: FontWeight.w500);
  static TextStyle header4 = GoogleFonts.roboto(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500);

}