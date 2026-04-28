import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/bloc/connectivityBloc/connectivity_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

import '../../core/CommonMethods.dart';

class NoInternetScreen extends StatelessWidget {
  final Future<void> Function() onRetry;

  const NoInternetScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GradientBackground(child: mainView(context)));
  }

  Widget mainView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppImages.icNoInternet),
          const SizedBox(height: 10,),
          commonTitle(
            title: "Lost Connection",
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 5,),
          commonTitle(
            title:
                "Whoops, no internet connection found. Please check your connection",
            color: AppColors.grey,
            fontSize: 16
          ),
          const SizedBox(height: 30,),
          commonButtonView(context: context, buttonText: "Try Again",
            onClicked: () async {
              await onRetry();
              if (context.mounted) {
                final isConnected = context.read<ConnectivityCubit>().state;
                if (!isConnected && context.mounted) {
                  CommonMethods().showErrorToast("No Internet Connection !");
                }
              }
            },
          )
        ],
      ),
    );
  }
}
