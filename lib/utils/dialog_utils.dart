import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';


class DialogUtils {
  static final DialogUtils _instance = DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static Future<T?> openBottomSheetDialog<T>({
    required BuildContext context,
    required Widget contentWidget,
    bool isScrollControlled = false,
    bool isDismissible = false,
    Color backgroundColor = AppColors.white,
    double horizontalPadding = 12,
    bool useFlexible = true,
  }) {
    return showModalBottomSheet<T>(
      isScrollControlled: isScrollControlled,
      useSafeArea: true,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 10),
              if (useFlexible)
                Flexible(child: contentWidget)
              else
                contentWidget,
            ],
          ),
        );
      },
    );
  }
}
