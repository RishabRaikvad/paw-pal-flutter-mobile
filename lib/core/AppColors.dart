import 'package:flutter/material.dart';

abstract class AppColors {
  const AppColors();

  static const Color primaryColor = Color(0xffFD6C02);
  static const Color secondaryColor = Color(0xff04845E);
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff120B06);
  static const Color grey = Color(0xff7A7A7A);
  static const Color shadowColor = Color(0xff8E939F);
  static const Color lightGrey = Color(0xff98A2B3);
  static const Color linearBgColor = Color(0xffFFE5D0);
  static const Color inputBgColor = Color(0xff555555);
  static const Color plashHolderColor = Color(0xff454545);
  static const Color dividerColor = Color(0xffECECEC);
  static const linearBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [linearBgColor, Color(0xFFD6D6D6)
    ],
    stops: [0.1, 1.0],
  );
}
