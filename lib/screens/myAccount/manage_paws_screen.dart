import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../bloc/mangePawBloc/manage_paw_cubit.dart';
import '../../bloc/profileBloc/profile_cubit.dart';
import '../../core/CommonMethods.dart';
import '../../core/constant.dart';

class ManagePawsScreen extends StatefulWidget {
  const ManagePawsScreen({super.key});

  @override
  State<ManagePawsScreen> createState() => _ManagePawsScreenState();
}

class _ManagePawsScreenState extends State<ManagePawsScreen> {
  late ManagePawCubit cubit;
  late Razorpay razorpay;
  String phone = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    cubit = context.read<ManagePawCubit>();
    cubit.loadMyPets();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  String? currentPetId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GradientBackground(child: mainView()));
  }

  Widget mainView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            commonBackWithHeader(
              context: context,
              title: AppStrings.managePaws,
              isShowTitle: true,
            ),
            const SizedBox(height: 30),
            commonTitle(
              title: "Adoption Control",
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            const SizedBox(height: 3),
            commonTitle(
              title: "Add new pets and control their visibility for adoption",
              color: AppColors.grey,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: BlocBuilder<ManagePawCubit, ManagePawState>(
                builder: (context, state) {
                  if (state is ManagePawLoadState) {
                    return loadMyPets();
                  } else if (state is ManagePawErrorState) {
                    commonTitle(title: state.error);
                  } else if (cubit.lstMyPets.isEmpty) {
                    return Center(child: addMorePet());
                  }
                  return commonRefreshIndicator(
                    onRefresh: cubit.loadMyPets,
                    child: CustomScrollView(
                      slivers: [
                        myPawList(),
                        SliverToBoxAdapter(child: const SizedBox(height: 20)),
                        if (cubit.lstMyPets.isNotEmpty)
                          SliverToBoxAdapter(child: addMorePet()),
                        SliverToBoxAdapter(child: const SizedBox(height: 100)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverList myPawList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final pet = cubit.lstMyPets[index];
        return myPawCard(
          petName: pet.name,
          price: pet.petPrice,
          age: pet.age,
          gender: pet.gender,
          imgUrl: pet.mainImageUrl,
          petBread: pet.breed,
          isAvailable: pet.isAvailable,
          petId: pet.id,
          isAdopted: pet.isAdopted,
        );
      }, childCount: cubit.lstMyPets.length),
    );
  }

  Widget myPawCard({
    required String imgUrl,
    required String petName,
    required String petBread,
    required int price,
    required String gender,
    required String age,
    required bool isAvailable,
    required String petId,
    required bool isAdopted,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.inputBgColor.withValues(alpha: 0.1),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.1),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                commonNetworkImage(
                  imageUrl: imgUrl,
                  width: 70,
                  height: 70,
                  borderRadius: 16,
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
                              title: petName,
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                              overFlow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Flexible(
                            child: commonTitle(
                              title: "(${petBread.trim()})",
                              maxLines: 1,
                              overFlow: TextOverflow.ellipsis,
                              color: AppColors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          commonTitle(title: gender, fontSize: 12),
                          CircleAvatar(
                            radius: 3,
                            backgroundColor: AppColors.grey,
                          ),
                        ],
                      ),
                      commonTitle(title: age, fontSize: 12),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    commonTitle(
                      title: CommonMethods().formatPrice(price),
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
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
            const SizedBox(height: 10),
            commonDottedLine(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                commonTitle(
                  title: "Show in Adoption",
                  color: AppColors.grey,
                  fontWeight: FontWeight.w600,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable:
                      cubit.adoptionStatus[petId] ?? ValueNotifier(false),
                  builder: (context, value, _) {
                    return Transform.scale(
                      scale: 0.85,
                      child: Switch(
                        value: value,
                        onChanged: (v) {
                          if (v == true && isAdopted == true) {
                            currentPetId = petId;
                            openRazorpay();
                            return;
                          }
                          cubit.toggleAdoptionStatus(petId, v);
                        },
                        activeTrackColor: AppColors.greenColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget loadMyPets() {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [shimmerListSliver(height: 150)],
    );
  }

  Widget addMorePet() {
    return GestureDetector(
      onTap: () {
        context.read<ProfileCubit>().resetPetData();
        context.read<ProfileCubit>().addMorePet = true;
        context.pushNamed(Routes.petProfileScreen);
      },
      child: SvgPicture.asset(AppImages.icAddNewPet),
    );
  }

  Future<void> loadUserData() async {
    final user = CommonMethods.getCurrentUser();

    if (user != null) {
      phone = CommonMethods().formatPhone(user.phoneNumber);

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      if (doc.exists) {
        email = doc.data()?['email'] ?? "";
      }
    }

    debugPrint("User Data :- Phone: $phone, Email: $email");
  }

  void openRazorpay() {
    var options = {
      'key': Constant.razorPayKey,
      'amount': 250 * 100,
      'currency': 'INR',
      'name': 'Paw Pal',
      'description': 'Pet Creation Fee',
      'prefill': {'contact': phone, 'email': email},
      'theme': {'color': '#FD6C02'},
    };
    try {
      options.forEach((key, value) {
        debugPrint("Option Data: $key => $value");
      });
      razorpay.open(options);
    } catch (e) {
      debugPrint("Razorpay Error: $e");
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (response.paymentId == null || response.paymentId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment not completed. Please try again."),
        ),
      );
      return;
    }

    if (currentPetId != null) {
      cubit.adoptionStatus[currentPetId!]?.value = true;

      await FirebaseFirestore.instance
          .collection("pets")
          .doc(currentPetId!)
          .update({"isAvailable": true, "isAdopted": false});

      await cubit.createPetCreateFess(
        "Success",
        response.paymentId!,
        currentPetId!,
      );
      await cubit.loadMyPets();
      CommonMethods().showSuccessToast("🎉 Payment successful!");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CommonMethods().showErrorToast("Payment failed!");
    debugPrint("Payment Failed: ${response.code} | ${response.message}");
  }
}
