import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';

import '../home/home_screen.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(child: RepaintBoundary(child: SvgPicture.asset(AppImages.icSplash))),
      ),
    );
  }

  Future<void> checkAuth() async {
    User? user = FirebaseAuth.instance.currentUser;
    await Future.delayed(const Duration(milliseconds: 800));
    if(!mounted) return;
    if (user == null) {
      context.goNamed(Routes.welcomeScreen);
    } else {
      bool isProfileComplete = await authService.isProfileCompleted(user.uid);
      if (!mounted) return;
      if (isProfileComplete) {
        context.goNamed(Routes.dashBoardScreen);
      } else {
        context.goNamed(Routes.setupProfileScreen);
      }
    }
  }
}
