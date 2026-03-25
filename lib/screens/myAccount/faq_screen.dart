import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';

import '../../bloc/faqBloc/faq_cubit.dart';
import '../../utils/widget_helper.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late FaqCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<FaqCubit>();
    cubit.getFaqs();
  }

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
            commonBackWithHeader(
              context: context,
              title: "FAQ’s",
              isShowTitle: true,
            ),
            const SizedBox(height: 20),
            commonTitle(
              title: "Quick Answer for Pet Lovers",
              fontSize: 22,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 4),
            commonTitle(
              title:
                  "Get quick answers to make your PawPal experience smooth and easy.",
              fontSize: 16,
              textAlign: TextAlign.start,
              color: AppColors.grey,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: BlocBuilder<FaqCubit, FaqState>(
                builder: (context, state) {
                  if(state is FaqLoadState){
                    return CustomScrollView(
                      slivers: [
                        shimmerListSliver(
                          height: 50,

                        )
                      ],
                    );
                  }
                  return commonRefreshIndicator(
                    onRefresh: cubit.getFaqs,
                      child: CustomScrollView(slivers: [faqList()]));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverList faqList() {
    return SliverList.separated(
      itemCount: cubit.lstFaq.length,
      itemBuilder: (context, index) {
        final faq = cubit.lstFaq[index];
        final isExpanded = cubit.expandedIndexes.contains(index);

        return faqView(
          index: index,
          isExpanded: isExpanded,
          question: faq.question,
          answer: faq.answer,
        );
      },
      separatorBuilder: (context, index) {
        return Divider(color: AppColors.grey.withValues(alpha: 0.5));
      },
    );
  }

  Widget faqView({
    required int index,
    required bool isExpanded,
    required String question,
    required String answer,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          cubit.toggleFaq(index);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: commonTitle(
                    title: question,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    maxLines: isExpanded ? null : 1,
                    overFlow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                ),

                const SizedBox(width: 10),

                GestureDetector(
                  onTap: () {
                    cubit.toggleFaq(index);
                  },
                  child: Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Icon(
                        isExpanded ? Icons.remove : Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: commonTitle(
                  title: answer,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                  textAlign: TextAlign.start,
                ),
              ),
              secondChild: const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
