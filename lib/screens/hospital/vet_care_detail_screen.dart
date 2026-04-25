import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/bloc/hospitalBloc/hospital_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/hospital_model.dart';
import 'package:paw_pal_mobile/utils/ui_helper.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

class VetCareDetailScreen extends StatefulWidget {
  const VetCareDetailScreen({super.key});

  @override
  State<VetCareDetailScreen> createState() => _VetCareDetailScreenState();
}

class _VetCareDetailScreenState extends State<VetCareDetailScreen> {
  late HospitalCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<HospitalCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<HospitalCubit, HospitalState>(
        builder: (context, state) {
          final model = cubit.model;
          if (model == null) return commonTitle(title: "No Hospital");
          return Stack(
            children: [
              commonNetworkImage(
                imageUrl: model.imageUrl,
                height: UIHelper.screenHeight(context) * 0.45,
                width: double.infinity,
              ),

              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: UIHelper.screenHeight(context) * 0.35,
                    ),
                  ),
                  SliverToBoxAdapter(child: hospitalDetailView(model)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget hospitalDetailView(HospitalModel model) {
    final today = cubit.getTodayAvailability(model);
    final isOpen = cubit.isOpenNow(model);
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 800),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonTitle(
                title: model.hospitalName,
                fontSize: 19,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  SvgPicture.asset(AppImages.icLocation),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Flexible(
                          child: commonTitle(
                            title:
                            model.address,
                            color: AppColors.grey,
                            fontSize: 14,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  SvgPicture.asset(AppImages.icTime),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Flexible(
                          child: commonTitle(
                            title:
                                "${today?.day ?? ""} | ${today?.startTime ?? ""} - ${today?.endTime ?? ""}",
                            color: AppColors.grey,
                            fontSize: 14,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: AppColors.grey,
                          radius: 3,
                        ),
                        commonTitle(
                          title: isOpen ? "Open Now" : "Closed Now",
                          color: isOpen
                              ? AppColors.greenColor
                              : AppColors.redColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 1),
              commonDottedLine(),
              const SizedBox(height: 1),
              description(model),
              const SizedBox(height: 1),
              commonDottedLine(),
              const SizedBox(height: 1),
              specialization(model),
              const SizedBox(height: 1),
              commonDottedLine(),
              const SizedBox(height: 1),
              workingHours(model),
              buildShareAndCall(model),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget description(HospitalModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Description",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        commonTitle(
          title: model.aboutHospital,
          fontSize: 14,
          color: AppColors.grey,
          maxLines: 4,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget specialization(HospitalModel model) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Specialization",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(model.specializations.length, (index) {
            final spec = model.specializations[index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: commonTitle(
                title: spec,
                color: AppColors.white,
                fontSize: 13,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget workingHours(HospitalModel model) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        commonTitle(
          title: "Working Hours",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final data = model.availability[index];
            final isOpen = cubit.isOpenNow(model);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  commonTitle(
                    title: data.day,
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                  commonTitle(
                    title: isOpen
                        ? "${data.startTime} - ${data.endTime}"
                        : "Close Now",
                    color: isOpen ? AppColors.grey : AppColors.redColor,
                    fontSize: 14,
                    fontWeight: isOpen ? FontWeight.w400 : FontWeight.w600,
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => commonDottedLine(),
          itemCount: model.availability.length,
        ),
      ],
    );
  }

  Widget buildShareAndCall(HospitalModel model) {
    return Row(
      spacing: 20,
      children: [
        Flexible(
          child: GestureDetector(
            onTap: () => cubit.shareHospital(),
            child: SvgPicture.asset(AppImages.icShare),
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              CommonMethods.call(model.contactNumber);
            },
            child: SvgPicture.asset(AppImages.icCall),
          ),
        ),
      ],
    );
  }
}
