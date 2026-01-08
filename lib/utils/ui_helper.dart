import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/AppImages.dart';

class UIHelper {
  // Screen Height and Width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
