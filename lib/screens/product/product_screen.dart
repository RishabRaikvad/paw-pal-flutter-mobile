import 'package:flutter/material.dart';

import '../../utils/commonWidget/gradient_background.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GradientBackground(child: Text("")));
  }
}
