import 'package:flutter/material.dart';

class CText {
  static Text small(
      String text, {
        FontWeight fontWeight = FontWeight.normal,
        Color color = Colors.black,
        TextDecoration decoration = TextDecoration.none,
        double fontSize = 0
      }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize == 0 ? 14.0 : fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration
      ),
    );
  }

  static Text medium(
      String text, {
        FontWeight fontWeight = FontWeight.normal,
        Color color = Colors.black,
        TextDecoration decoration = TextDecoration.none,
        double fontSize = 0
      }) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontSize == 0 ? 16.0 : fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration
      ),
    );
  }

  static Text large(
      String text, {
        FontWeight fontWeight = FontWeight.normal,
        Color color = Colors.black,
        TextDecoration decoration = TextDecoration.none,
        double fontSize = 0
      }) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontSize == 0 ? 24.0 : fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration
      ),
    );
  }
}
