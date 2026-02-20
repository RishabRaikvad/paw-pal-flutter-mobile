import 'package:flutter/material.dart';

import '../../utils/commonWidget/gradient_background.dart';
import '../../utils/widget_helper.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GradientBackground(child: mainView()));
  }

  Widget mainView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: commonTitle(
                title: "Find Your New Furry Friend",
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),
            commonSearchBar(
              controller: searchController,
              onSearchChange: (String? value) {},
              onSearch: (String value) {},
              title: "Search pets, products & care...",
            ),
            const SizedBox(height: 30),
            Flexible(
              child: CustomScrollView(
                slivers: [
                  buildShopView(),
                  SliverToBoxAdapter(child: const SizedBox(height: 100)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverGrid buildShopView() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 14,
        childAspectRatio: 0.65,
        // mainAxisExtent: 245,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        return commonProductCard(index);
      }, childCount: 10),
    );
  }
}
