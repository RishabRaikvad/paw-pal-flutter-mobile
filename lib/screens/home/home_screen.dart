import 'package:flutter/material.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';

import '../../utils/commonWidget/gradient_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(child: Text("")),
    );
  }
}
