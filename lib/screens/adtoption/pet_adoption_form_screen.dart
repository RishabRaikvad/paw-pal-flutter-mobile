import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_mobile/bloc/adoptionBloc/adoption_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/pet_model.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/dialog_utils.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

class PetAdoptionFormScreen extends StatefulWidget {
  const PetAdoptionFormScreen({super.key});

  @override
  State<PetAdoptionFormScreen> createState() => _PetAdoptionFormScreenState();
}

class _PetAdoptionFormScreenState extends State<PetAdoptionFormScreen> {
  late AdoptionCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<AdoptionCubit>();
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
              title: "Adoption Form",
              isShowTitle: true,
            ),
            const SizedBox(height: 20),
            commonTitle(
              title: "Send Adoption Request",
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            commonTitle(
              title:
                  "Provide a few details to help the owner review your request.",
              color: AppColors.grey,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: BlocBuilder<AdoptionCubit, AdoptionState>(
                builder: (context, state) {
                  final model = cubit.model;
                  if (model == null) return SizedBox.shrink();
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: petSummaryView(model.pet)),
                      SliverToBoxAdapter(child: const SizedBox(height: 20)),
                      SliverToBoxAdapter(child: commonDottedLine()),
                      SliverToBoxAdapter(child: const SizedBox(height: 20)),
                      SliverToBoxAdapter(child: adoptionFormView()),
                      SliverToBoxAdapter(child: const SizedBox(height: 20)),
                      SliverToBoxAdapter(child: petExperienceView()),
                      SliverToBoxAdapter(child: const SizedBox(height: 20)),
                      SliverToBoxAdapter(child: commonDottedLine()),
                      SliverToBoxAdapter(child: const SizedBox(height: 20)),
                      SliverToBoxAdapter(child: agreeView()),
                      SliverToBoxAdapter(child: const SizedBox(height: 20)),
                      SliverToBoxAdapter(child: reviewView(),),
                      SliverToBoxAdapter(child: const SizedBox(height: 30)),
                      SliverToBoxAdapter(child: requestToAdoptBtn(),),
                      SliverToBoxAdapter(child: const SizedBox(height: 30)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget petSummaryView(PetModel model) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Pet Summary",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBgColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 60,
                    minHeight: 60,
                    maxWidth: 70,
                    maxHeight: 70,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: commonNetworkImage(
                      imageUrl: model.mainImageUrl,
                      borderRadius: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 5,
                        children: [
                          Flexible(
                            child: commonTitle(
                              title: model.name,
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                              overFlow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Flexible(
                            child: commonTitle(
                              title: model.breed,
                              maxLines: 1,
                              overFlow: TextOverflow.ellipsis,
                              color: AppColors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      commonTitle(
                        title:
                            "${model.gender} ${AppStrings.dot} ${model.age} ${AppStrings.old}",
                        fontSize: 14,
                        color: AppColors.grey,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    commonTitle(
                      title: CommonMethods().formatPrice(model.petPrice),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                    commonTitle(
                      title: AppStrings.adoptionPrice,
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget adoptionFormView() {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 15,
          children: [
            Expanded(
              child: commonTextFieldWithLabel(
                label: "First Name",
                hint: "Enter First Name",
                context: context,
                controller: cubit.firstNameController,
              ),
            ),
            Expanded(
              child: commonTextFieldWithLabel(
                label: "Last Name",
                hint: "Enter Last Name",
                context: context,
                controller: cubit.lastNameController,
              ),
            ),
          ],
        ),
        commonTextFieldWithLabel(
          label: "Email",
          hint: "Enter Email",
          context: context,
          controller: cubit.emailController,
        ),
        commonTextFieldWithLabel(
          label: "Mobile Number",
          hint: "Enter Mobile Number",
          context: context,
          controller: cubit.phoneController,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: commonTitle(
              title: "+91",
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        commonDottedLine(),
        commonTextFieldWithLabel(
          label: "Adoption Message",
          hint: "Why do you want to adopt this pet?",
          context: context,
          controller: cubit.adoptionMsgController,
          maxLines: 4,
          maxLength: 200,
        ),
      ],
    );
  }

  Widget petExperienceView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        commonTitle(title: "Do you have a pet experience?"),
        RadioGroup<bool>(
          groupValue: cubit.hasPetExperience,
          onChanged: (value) {
            cubit.selectPetExperience(value!);
          },
          child: Row(
            children: [
              _radioItem("I have a experience", true),
              const SizedBox(width: 10),
              _radioItem("No, not right now", false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _radioItem(String title, bool value) {
    return Expanded(
      child: Row(
        spacing: 5,
        children: [
          Radio<bool>(
            value: value,
            activeColor: AppColors.primaryColor,

            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),

            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (!states.contains(WidgetState.selected)) {
                return AppColors.plashHolderColor.withValues(alpha: 0.1);
              }
              return AppColors.primaryColor.withValues(alpha: 0.1);
            }),

            fillColor: WidgetStateProperty.resolveWith(
              (states) => AppColors.primaryColor,
            ),
          ),
          Flexible(
            child: commonTitle(
              title: title,
              fontSize: 12,
              color: AppColors.grey,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget agreeView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Checkbox(
          value: cubit.isAgree,
          onChanged: (value) {
            if (value != null) {
              cubit.onAgreeChange(value);
            }
          },
          activeColor: AppColors.primaryColor,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          side: BorderSide(color: AppColors.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(5),
          ),
        ),
        Expanded(
          child: commonTitle(
            title:
                "I agree to provide a loving, safe, and responsible home for this pet.",
            color: AppColors.grey,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget reviewView() {
    return commonTitle(
      title:
          "Please review your details carefully. Adoption requests cannot be cancelled after submission.",
      color: AppColors.grey,
        textAlign: TextAlign.center
    );
  }

  Widget requestToAdoptBtn(){
    return commonButtonView(context: context, buttonText: "Request to Adopt", onClicked: (){
      DialogUtils.adoptionRequestDialog(context: context);
    });
  }
}
