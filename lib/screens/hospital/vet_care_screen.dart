import 'package:flutter/material.dart';

import '../../utils/commonWidget/gradient_background.dart';

class VetCareScreen extends StatefulWidget {
  const VetCareScreen({super.key});

  @override
  State<VetCareScreen> createState() => _VetCareScreenState();
}

class _VetCareScreenState extends State<VetCareScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(child: Text("")),
    );
  }
}
