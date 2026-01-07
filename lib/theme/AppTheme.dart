import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/AppColors.dart';
import '../routes/animated_page_route.dart';

class AppTheme {
  const AppTheme();

  static ThemeData lightThem() {
    return ThemeData(
      useMaterial3: true,
      // useMaterial3: true,
      appBarTheme: const AppBarTheme(
        //  backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.white,
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CustomOpenRightwardsPageTransitionsBuilder(),
        },
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),

        headlineMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
          //  fontFamily:Constants.boldFont
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
        bodyLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: AppColors.black,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
        labelSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.white,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
        displaySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.white,
        ),
        displayLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: AppColors.white,
        ),
        headlineLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.white,
        //  primary: const AppColors.primary,
        background: AppColors.black,

        /// set app background color
      ),
    );
  }

  /*static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CustomOpenUpwardsPageTransitionsBuilder(),
        },
      ),
     // fontFamily: Constants.appFontSatoshi,
      navigationBarTheme: const NavigationBarThemeData(backgroundColor: AppColors.bottomNavigationBarDark),
      colorScheme: const ColorScheme(
        background: AppColors.backgroundColorDark,
        onBackground: AppColors.onBackgroundColorDark,
        brightness: Brightness.dark,
        primary: AppColors.primaryDark,
        onPrimary: AppColors.onPrimaryDark,
        secondary: AppColors.secondaryDark,
        onSecondary: AppColors.onSecondaryDark,
        error: AppColors.errorDark,
        onError: AppColors.onErrorDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.onSurfaceDark,
      ),
    );
  }*/
}
