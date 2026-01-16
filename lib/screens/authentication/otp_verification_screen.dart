import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/bloc/authBloc/auth_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  TextEditingController otpController = TextEditingController();
  final focusNode = FocusNode();
  final ValueNotifier<int> _secondsRemaining = ValueNotifier<int>(60);
  final ValueNotifier<bool> _canResend = ValueNotifier<bool>(false);
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  Timer? _timer;
  final defaultPinTheme = PinTheme(
    width: 46,
    height: 44,
    textStyle: TextStyle(color: AppColors.primaryColor),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(13),
      color: AppColors.plashHolderColor.withValues(alpha: 0.1),
    ),
  );

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _secondsRemaining.dispose();
    _canResend.dispose();
    otpController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GradientBackground(child: mainView()));
  }

  Widget mainView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Icon(Icons.arrow_back, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 30),
            commonTitle(
              title: "Verify Your Phone Number",
              fontSize: 24,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 8),
            commonTitle(
              title:
                  "Enter the 6-digit code sent to your mobile number to continue.",
              textAlign: TextAlign.start,
              color: AppColors.grey,
            ),
            SizedBox(height: 20),
            buildOtpFiled(),
            Spacer(),
            _buildResendSection(),
            SizedBox(height: 10),
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (context, isLoading, child) {
                return commonButtonView(
                  context: context,
                  buttonText: "Verify & Continue",
                  onClicked: () {
                    btnClick();
                  },
                  isLoading: isLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOtpFiled() {
    return Align(
      alignment: Alignment.center,
      child: Pinput(
        controller: otpController,
        focusNode: focusNode,
        defaultPinTheme: defaultPinTheme,
        length: 6,
        separatorBuilder: (index) => const SizedBox(width: 15),
        hapticFeedbackType: HapticFeedbackType.lightImpact,
        onCompleted: (pin) {},
        onChanged: (value) {},
        cursor: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 9),
              width: 15,
              height: 1,
              color: AppColors.primaryColor,
            ),
          ],
        ),

        focusedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        submittedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }

  Widget _buildResendSection() {
    return Center(
      child: ValueListenableBuilder<bool>(
        valueListenable: _canResend,
        builder: (_, canResend, __) {
          return ValueListenableBuilder<int>(
            valueListenable: _secondsRemaining,
            builder: (_, seconds, __) {
              return RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(text: "Don’t Receive Verification Code ? "),
                    canResend
                        ? TextSpan(
                            text: "Resend Code",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _startTimer();
                              },
                          )
                        : TextSpan(
                            text:
                                "Resend in 00:${seconds.toString().padLeft(2, '0')}",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _startTimer() {
    _secondsRemaining.value = 60;
    _canResend.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining.value > 0) {
        _secondsRemaining.value--;
      } else {
        timer.cancel();
        _canResend.value = true;
      }
    });
  }

  void btnClick() async {
    final otp = otpController.text.trim();
    if (otp.isEmpty) {
      CommonMethods().showErrorToast("Please enter the OTP");
      return;
    }
    if (otp.length < 6) {
      CommonMethods().showErrorToast("Please enter valid OTP");
      return;
    }
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 5));
    if (mounted) {
      await context.read<AuthCubit>().onVerifyOtp(
        smsCode: otp,
        context: context,
      );
    }
    isLoading.value = false;
  }
}
