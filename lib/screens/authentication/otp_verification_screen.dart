import 'package:flutter/material.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(child: Column()),
    );
  }
}
