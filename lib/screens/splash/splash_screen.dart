import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';

import '../home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuthService authService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    navigateToScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(child: SvgPicture.asset(AppImages.icSplash)),
      ),
    );
  }

  void navigateToScreen() {
    Future.delayed(Duration(seconds: 4), () {
      checkAuth();
    });
  }

  Future<void> checkAuth() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      context.goNamed(Routes.welcomeScreen);
    } else {
      bool isProfileComplete = await authService.isProfileCompleted(user.uid);
      if (!mounted) return;
      if (isProfileComplete) {
        context.goNamed(Routes.homeScreen);
      } else {
        context.goNamed(Routes.setupProfileScreen);
      }
    }
  }
}
