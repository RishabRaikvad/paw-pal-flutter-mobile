import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paw_pal_mobile/bloc/cartBloc/cart_cubit.dart';
import 'package:paw_pal_mobile/bloc/myAccountBloc/my_account_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/cart_model.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/dialog_utils.dart';
import 'package:paw_pal_mobile/utils/ui_helper.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../core/constant.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  late CartCubit cubit;
  late MyAccountCubit myAccountCubit;
  late Stream<List<CartModel>> cartStream;
  late Razorpay razorpay;
  String phone = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    cubit = context.read<CartCubit>();
    myAccountCubit = context.read<MyAccountCubit>();
    cartStream = cubit.getCartItems();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    loadUserData();
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build");
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
              title: "Checkout Now",
              isShowTitle: true,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: StreamBuilder(
                stream: cartStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CustomScrollView(
                      slivers: [shimmerListSliver(height: 200)],
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: commonTitle(title: "${snapshot.error}"),
                    );
                  }

                  final cartList = snapshot.data ?? [];
                  cubit.currentCartItems = cartList;
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: commonTitle(
                          title: "Your Order List",
                          textAlign: TextAlign.start,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SliverToBoxAdapter(child: const SizedBox(height: 10)),
                      if (cartList.isNotEmpty)
                        cartListView(cartList)
                      else
                        SliverToBoxAdapter(
                          child: commonTitle(title: "Cart is Empty"),
                        ),
                      if (cartList.isNotEmpty) ...[
                        SliverToBoxAdapter(child: const SizedBox(height: 20)),
                        SliverToBoxAdapter(child: shippingAddressView()),
                        SliverToBoxAdapter(child: const SizedBox(height: 20)),
                        SliverToBoxAdapter(child: billingDetail(cartList)),
                        SliverToBoxAdapter(child: const SizedBox(height: 30)),
                        SliverToBoxAdapter(child: buildPayBtn(cartList)),
                        SliverToBoxAdapter(child: const SizedBox(height: 50)),
                      ],
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

  SliverList cartListView(List<CartModel> cartList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final cart = cartList[index];
        return cartView(
          imgUrl: cart.productMainImage,
          productName: cart.productName,
          quantity: cart.productQuantity,
          price: cart.productPrice,
          increaseQuantity: () {
            cubit.increaseQuantity(cart);
          },
          decreaseQuantity: () {
            cubit.decreaseQuantity(cart);
          },
          removeProduct: () => cubit.removeItm(cart),
          variantTitle: cart.variantTitle,
        );
      }, childCount: cartList.length),
    );
  }

  Widget cartView({
    required String imgUrl,
    required productName,
    String? variantTitle,
    required int quantity,
    required double price,
    required VoidCallback increaseQuantity,
    required VoidCallback decreaseQuantity,
    required VoidCallback removeProduct,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.inputBgColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
        child: Row(
          spacing: 12,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 70,
                minHeight: 70,
                maxWidth: 85,
                maxHeight: 85,
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: commonNetworkImage(imageUrl: imgUrl, borderRadius: 12),
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 15,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: commonTitle(
                          title: productName,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                          overFlow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: removeProduct,
                        child: SvgPicture.asset(AppImages.icDelete),
                      ),
                    ],
                  ),
                  commonTitle(
                    title: CommonMethods().formatPrice(price),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: commonTitle(
                          title: variantTitle ?? " ",
                          color: AppColors.grey,
                          fontSize: 13,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          overFlow: TextOverflow.visible,
                        ),
                      ),
                      productQuantityView(
                        decreaseQuantity: decreaseQuantity,
                        increaseQuantity: increaseQuantity,
                        productQuantity: quantity,
                        fontSize: 14,
                        size: 25,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget shippingAddressView() {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        commonTitle(
          title: "Shipping Address",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.inputBgColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonTitle(
                  title: myAccountCubit.getFullName(),
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 10),
                commonTitle(
                  title:
                      "+91  ${CommonMethods().formatPhone(myAccountCubit.getPhoneNumber)}",
                  fontSize: 14,
                  color: AppColors.grey,
                  textAlign: TextAlign.start,
                ),
                Row(
                  spacing: 12,
                  children: [
                    Flexible(
                      child: commonTitle(
                        title:
                            "${myAccountCubit.getAddress} ${myAccountCubit.getCity()} ${myAccountCubit.getState()} : ${myAccountCubit.userModel?.pinCode}",
                        textAlign: TextAlign.start,
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                    Image.asset(
                      AppImages.imgShippingAddress,
                      width: 65,
                      height: 65,
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

  Widget billingDetail(List<CartModel> cart) {
    final amount = cubit.calculateBil(cart);
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Billing Details",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        GestureDetector(
          onTap: () {
            billingBottomSheet(cart);
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                spacing: 10,
                children: [
                  SvgPicture.asset(AppImages.icTotalPayment),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonTitle(
                          title: "Total Amount Payable",
                          fontWeight: FontWeight.w600,
                        ),
                        commonTitle(
                          title: "View Details",
                          fontSize: 14,
                          color: AppColors.grey,
                          isUnderLine: true,
                        ),
                      ],
                    ),
                  ),
                  commonTitle(
                    title: CommonMethods().formatPrice(amount.total),
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void billingBottomSheet(List<CartModel> cart) {
    DialogUtils.openBottomSheetDialog(
      context: context,
      isScrollControlled: true,
      contentWidget: LayoutBuilder(
        builder: (context, constraints) {
          final amount = cubit.calculateBil(cart);
          final maxHeight = UIHelper.screenHeight(context) * 0.5;
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonTitle(
                  title: "Billing Details",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 20),
                buildBillingRow(title: "Item Total", amount: amount.itemTotal),
                const SizedBox(height: 10),
                buildBillingRow(
                  title: "Delivery Charges",
                  amount: amount.deliveryCharge,
                ),
                const SizedBox(height: 10),
                commonDottedLine(),
                const SizedBox(height: 10),
                buildBillingRow(
                  title: "Sub Total",
                  amount: amount.subTotal,
                  amountColor: AppColors.black,
                  titleColor: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 10),
                commonDottedLine(),
                const SizedBox(height: 10),

                buildBillingRow(
                  title: "Platform Fee",
                  amount: amount.platformFee,
                ),
                const SizedBox(height: 10),

                buildBillingRow(title: "GST (5 %)", amount: amount.gst),
                const SizedBox(height: 10),
                commonDottedLine(),
                const SizedBox(height: 10),
                buildBillingRow(
                  title: "Total Payable Amount",
                  amount: amount.total,
                  amountColor: AppColors.black,
                  titleColor: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 25),
                buildPayBtn(cart),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildPayBtn(List<CartModel> cart) {
    final amount = cubit.calculateBil(cart);
    return commonButtonView(
      context: context,
      buttonText: "Pay ${CommonMethods().formatPrice(amount.total)}",
      onClicked: () {
        openRazorpay(amount.total);
      },
    );
  }

  Widget buildBillingRow({
    required String title,
    required double amount,
    double fontSize = 15,
    Color amountColor = AppColors.primaryColor,
    Color titleColor = AppColors.grey,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        commonTitle(
          title: title,
          fontSize: fontSize,
          color: titleColor,
          fontWeight: fontWeight,
        ),
        commonTitle(
          title: CommonMethods().formatPrice(amount),
          fontSize: fontSize,
          color: amountColor,
          fontWeight: fontWeight,
        ),
      ],
    );
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
    await cubit.createOrder(
      context: context,
      status: "Success",
      cartItems: cubit.currentCartItems,
      razorpayPaymentId: response.paymentId ?? "",
    );
    await cubit.clearCart();
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Payment failed. Try again")));
  }

  void openRazorpay(double amount) {
    var options = {
      'key': Constant.razorPayKey,
      'amount': amount * 100,
      'currency': 'INR',
      'name': 'Paw Pal',
      'description': 'Payment for Order',
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

      if (email.isEmpty) {
        email = myAccountCubit.emailController.text.trim();
      }

    }
  }
}
