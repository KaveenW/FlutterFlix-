import 'package:flutter/material.dart';

class Colours {
  static const scaffoldBgColor = Color(0xFF23272E);
  static const ratingColor = Color(0xFFFFC107);
}

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16));
}
