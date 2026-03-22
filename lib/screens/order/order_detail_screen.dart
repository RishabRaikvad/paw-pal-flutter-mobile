import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/bloc/orderDetailBloc/order_detail_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/BillDetailModel.dart';
import 'package:paw_pal_mobile/model/cart_model.dart';
import 'package:paw_pal_mobile/model/order_model.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/dialog_utils.dart';
import 'package:paw_pal_mobile/utils/ui_helper.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late OrderDetailCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<OrderDetailCubit>();
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
              title: "Order Details",
              isShowTitle: true,
            ),
            const SizedBox(height: 30),
            Flexible(
              child: BlocBuilder<OrderDetailCubit, OrderDetailState>(
                builder: (context, state) {
                  final orderModel = cubit.model;
                  if (orderModel == null) return SizedBox.shrink();
                  return CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: orderStatusView(
                          orderModel.orderStatus,
                          orderModel,
                        ),
                      ),
                      SliverToBoxAdapter(child: const SizedBox(height: 12)),
                      SliverToBoxAdapter(
                        child: commonTitle(
                          title:
                              "${orderModel.items.length.toString()} items in this order",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      orderItemsListView(orderModel.items),
                      SliverToBoxAdapter(child: const SizedBox(height: 3)),
                      SliverToBoxAdapter(
                        child: orderAddressView(orderModel.shippingAddress),
                      ),
                      SliverToBoxAdapter(child: const SizedBox(height: 12)),

                      SliverToBoxAdapter(
                        child: billingDetail(orderModel.billing),
                      ),
                      SliverToBoxAdapter(child: const SizedBox(height: 12)),
                      SliverToBoxAdapter(child: needHelpView()),
                      SliverToBoxAdapter(child: const SizedBox(height: 20)),
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

  Widget orderStatusView(OrderStatus status, OrderModel model) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: cubit.getOrderStatusColor(status),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Row(
          spacing: 10,
          children: [
            SvgPicture.asset(cubit.getOrderStatusWiseIcon(status)),
            Expanded(
              child: commonTitle(
                title: CommonMethods().getOrderStatusWiseTitle(status),
                fontWeight: FontWeight.w600,
                fontSize: 14,
                textAlign: TextAlign.start,
              ),
            ),
            commonTitle(
              title: CommonMethods().formatDate(model.createdAt),
              color: cubit.getOrderDateColor(status),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget orderAddressView(ShippingAddress address) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBgColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonTitle(
              title: "Order Address Details",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 8),
            commonDottedLine(),
            const SizedBox(height: 10),

            commonTitle(title: "Deliver to", fontSize: 14),
            const SizedBox(height: 2),
            commonTitle(
              title: cubit.getOrderUserDetail(address),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
            ),
            const SizedBox(height: 10),

            commonTitle(title: "Address", fontSize: 14),
            const SizedBox(height: 2),
            commonTitle(
              title: cubit.getOrderAddressDetail(address),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),

            commonTitle(title: "Payment Method", fontSize: 14),
            const SizedBox(height: 2),
            commonTitle(
              title: "Payment via Razorpay",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }

  SliverList orderItemsListView(List<CartModel> items) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final itm = items[index];
        return orderItemCardView(
          imgUrl: itm.productMainImage,
          productName: itm.productName,
          quantity: itm.productQuantity,
          price: itm.productPrice,
          variantTitle: itm.variantTitle?.isNotEmpty == true
              ? itm.variantTitle
              : "",
        );
      }, childCount: items.length),
    );
  }

  Widget orderItemCardView({
    required String imgUrl,
    required productName,
    String? variantTitle,
    required int quantity,
    required double price,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.inputBgColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
        child: Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Expanded(
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonTitle(
                    title: productName,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overFlow: TextOverflow.ellipsis,
                  ),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: commonTitle(
                          title: variantTitle != null && variantTitle.isNotEmpty
                              ? "Quantity: $quantity x $variantTitle"
                              : "Quantity: $quantity",
                          fontSize: 12,
                          color: AppColors.grey,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      commonTitle(
                        title: CommonMethods().formatPrice(price),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
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

  Widget billingDetail(BillDetails billDetail) {
    return GestureDetector(
      onTap: ()=>billingBottomSheet(billDetail),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.inputBgColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonTitle(
                title: "Billing Details",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              commonDottedLine(),
              Row(
                spacing: 10,
                children: [
                  SvgPicture.asset(AppImages.icOrderDetailPayment),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonTitle(
                          title: "Total Amount Payed",
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
                    title: CommonMethods().formatPrice(billDetail.total),
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget needHelpView() {
    return GestureDetector(
      onTap: (){
        CommonMethods.call("9712459082");
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.inputBgColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonTitle(
                title: "Need help with your orders ?",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              commonDottedLine(),
              Row(
                spacing: 10,
                children: [
                  SvgPicture.asset(AppImages.icNeedHelp),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonTitle(
                        title: "Connect with us via Call",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      commonTitle(
                        title: "About any issues related to your order",
                        color: AppColors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void billingBottomSheet(BillDetails billDetail) {
    DialogUtils.openBottomSheetDialog(
      context: context,
      isScrollControlled: true,
      contentWidget: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = UIHelper.screenHeight(context) * 0.42;
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
                buildBillingRow(title: "Item Total", amount: billDetail.itemTotal),
                const SizedBox(height: 10),
                buildBillingRow(
                  title: "Delivery Charges",
                  amount: billDetail.deliveryCharge,
                ),
                const SizedBox(height: 10),
                commonDottedLine(),
                const SizedBox(height: 10),
                buildBillingRow(
                  title: "Sub Total",
                  amount: billDetail.subTotal,
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
                  amount: billDetail.platformFee,
                ),
                const SizedBox(height: 10),

                buildBillingRow(title: "GST (5 %)", amount: billDetail.gst),
                const SizedBox(height: 10),
                commonDottedLine(),
                const SizedBox(height: 10),
                buildBillingRow(
                  title: "Total Amount Payed",
                  amount: billDetail.total,
                  amountColor: AppColors.black,
                  titleColor: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),

              ],
            ),
          );
        },
      ),
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
}
