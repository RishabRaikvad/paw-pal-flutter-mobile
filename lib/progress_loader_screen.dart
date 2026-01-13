import 'package:flutter/material.dart';

import 'core/AppColors.dart';

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (_) => LoadingDialog(key: key),
  ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("LoadingDialog-------------------------");
    return PopScope(
      canPop: false,
      child: Center(
        child: Card(
          child: Container(
            color: Colors.transparent,
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
