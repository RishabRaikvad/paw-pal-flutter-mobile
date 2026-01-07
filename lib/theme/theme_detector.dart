import 'package:flutter/material.dart';

class ThemeDetector {
  const ThemeDetector();

  static void init(BuildContext context) {
    try {
      listen(context);
      View.of(context).platformDispatcher.onPlatformBrightnessChanged = () {
        listen(context);
      };
    } catch (e) {
      return;
    }
  }

  static void listen(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    bool isDark = (brightness == Brightness.dark) ? true : false;
    // ThemeData themeData = isDark ? AppTheme.darkTheme() : AppTheme.lightThem();
    //  BlocProvider.of<ThemeCubit>(context).setThemeData(themeData, false);
  }
}
