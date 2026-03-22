import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_mobile/bloc/orderBloc/order_cubit.dart';
import 'package:paw_pal_mobile/bloc/orderDetailBloc/order_detail_cubit.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/AppImages.dart';
import 'package:paw_pal_mobile/core/AppStrings.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/cart_model.dart';
import 'package:paw_pal_mobile/model/order_model.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late OrderCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<OrderCubit>();
    cubit.getOrders();
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
              title: "Order History",
              isShowTitle: true,
            ),
            const SizedBox(height: 30),
            commonTitle(
              title: "My Purchases",
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            commonTitle(
              title:
                  "Manage your purchases and track delivery updates in one place.",
              color: AppColors.grey,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 25),
            Flexible(
              child: BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoadingState) {
                    return orderShimmerView();
                  } else if (state is OrderErrorState) {
                    return commonTitle(title: state.error);
                  }
                  return commonRefreshIndicator(
                    onRefresh: cubit.getOrders,
                    child: CustomScrollView(
                      physics: BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(child: filterView()),
                        SliverToBoxAdapter(child: const SizedBox(height: 10)),
                        cubit.filterOrder.isNotEmpty
                            ? orderList()
                            : SliverToBoxAdapter(
                                child: commonTitle(
                                  title: "Order is Not Available",
                                ),
                              ),
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

  SliverList orderList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final order = cubit.filterOrder[index];
        return RepaintBoundary(
          child: orderCard(
            icon: cubit.getOrderStatusWiseIcon(order.orderStatus),
            totalAmount: order.billing.total,
            orderDate: CommonMethods().formatDate(order.createdAt),
            lstCartItems: order.items,
            orderStatus: order.orderStatus,
            onViewDetails: () {
              context.read<OrderDetailCubit>().navigateToOrderDetailScreen(
                context,
                order,
              );
            },
            onReorder: () {},
            onCancel: () {},
          ),
        );
      }, childCount: cubit.filterOrder.length),
    );
  }

  Widget orderCard({
    required String icon,
    required double totalAmount,
    required String orderDate,
    required List<CartModel> lstCartItems,
    required OrderStatus orderStatus,
    required VoidCallback onViewDetails,
    VoidCallback? onReorder,
    VoidCallback? onCancel,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.inputBgColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 15,
              children: [
                SvgPicture.asset(icon),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonTitle(
                        title: CommonMethods().getOrderStatusWiseTitle(
                          orderStatus,
                        ),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        textAlign: TextAlign.start,
                      ),
                      commonTitle(
                        title: orderDate,
                        color: AppColors.grey,
                        fontSize: 12,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                commonTitle(
                  title: CommonMethods().formatPrice(totalAmount),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 3),
            commonDottedLine(),
            buildProductImage(lstCartItems),
            commonDottedLine(),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: buildBottomAction(
                onViewDetails: onViewDetails,
                status: orderStatus,
                onCancel: onCancel,
                onReorder: onReorder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductImage(List<CartModel> items) {
    int displayCount = items.length > 3 ? 3 : items.length;
    int remaining = items.length - displayCount;
    return Row(
      children: [
        ...List.generate(displayCount, (index) {
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: commonNetworkImage(
              imageUrl: items[index].productMainImage,
              width: 50,
              height: 50,
              borderRadius: 8,
            ),
          );
        }),
        if (remaining > 0)
          Container(
            margin: EdgeInsets.only(left: 6),
            height: 50,
            width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: commonTitle(
              title: "+$remaining\nMore",
              fontSize: 12,
              color: AppColors.primaryColor,
            ),
          ),
      ],
    );
  }

  Widget buildBottomAction({
    required OrderStatus status,
    required VoidCallback onViewDetails,
    VoidCallback? onReorder,
    VoidCallback? onCancel,
  }) {
    return Row(
      mainAxisAlignment: status == OrderStatus.cancel
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onViewDetails,
          child: commonTitle(title: "View Order Details", fontSize: 14),
        ),

        if (status == OrderStatus.delivered)
          GestureDetector(
            onTap: onReorder,
            child: commonTitle(
              title: "Reorder",
              fontSize: 14,
              color: AppColors.greenColor,
            ),
          ),

        if (status == OrderStatus.pending)
          GestureDetector(
            onTap: onCancel,
            child: commonTitle(
              title: "Cancel Order",
              fontSize: 14,
              color: AppColors.redColor,
            ),
          ),
      ],
    );
  }

  Widget orderShimmerView() {
    return CustomScrollView(slivers: [shimmerListSliver(height: 200)]);
  }

  Widget filterView() {
    final selected = cubit.selectedFilter;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),

      child: Row(
        children: [
          buildFilterButton(context, "All", null, selected == null),
          buildFilterButton(
            context,
            "Pending",
            OrderStatus.pending,
            selected == OrderStatus.pending,
          ),
          buildFilterButton(
            context,
            "Delivered",
            OrderStatus.delivered,
            selected == OrderStatus.delivered,
          ),
          buildFilterButton(
            context,
            "Cancelled",
            OrderStatus.cancel,
            selected == OrderStatus.cancel,
          ),
        ],
      ),
    );
  }

  Widget buildFilterButton(
    BuildContext context,
    String title,
    OrderStatus? status,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        cubit.onFilterChange(status);
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.dividerColor,
            width: 1.2,
          ),
        ),
        child: commonTitle(
          title: title,
          color: isSelected ? AppColors.white : AppColors.grey,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
