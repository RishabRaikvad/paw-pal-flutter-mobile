import 'package:flutter/material.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(child: Column()),
    );
  }
}
