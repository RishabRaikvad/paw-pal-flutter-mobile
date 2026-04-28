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
  static const Color dividerColor = Color(0xffC8C8C8);
  static const Color primaryBgColor = Color(0xffF2F2F2);
  static const Color startColor = Color(0xffFFC107);
  static const Color petDetailBgColor = Color(0xffEFEFEF);
  static const Color redColor = Color(0xffFF3333);
  static const Color rejectedColor = Color(0xffEF4444);
  static const Color greenColor = Color(0xff34C759);
  static const Color approvedColor = Color(0xff22C55E);
  static const Color pendingColor = Color(0xff6366F1);
  static const Color completeColor = Color(0xff3B82F6);
  static const Color orderDeliveredColor = Color(0xffE3F9E6);
  static const Color orderPendingColor = Color(0xffFFEAD4);
  static const Color orderCancelColor = Color(0xffFEECEC);
  static const linearBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [linearBgColor, Color(0xFFD6D6D6)],
    stops: [0.1, 1.0],
  );
}
