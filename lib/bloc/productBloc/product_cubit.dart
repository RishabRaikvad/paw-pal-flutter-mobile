import 'package:bloc/bloc.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';

import '../../model/product_category_model.dart';
import '../../model/product_model.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final FirebaseService services;

  ProductCubit(this.services) : super(ProductInitial());

  List<ProductCategoryModel> lstCategory = [];
  List<ProductModel> lstProduct = [];

  ProductCategoryModel? filterCategory;
  int? filterCategoryIndex;
  bool isAllFilterSelected = true;
  String searchQuery = "";

  Future<void> getProductsWithCategory() async {
    emit(
      lstProduct.isEmpty && lstCategory.isEmpty
          ? ProductLoadState()
          : ProductRefreshState(),
    );
    try {
      lstCategory = await services.getProductCategory();
      lstProduct = await services.getProducts();
      emit(ProductSuccessState());
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }

  double getProductPrice(ProductModel model) {
    if (model.variants.isNotEmpty) {
      return model.variants.first.price;
    }
    return model.basePrice;
  }

  String? getProductSize(ProductModel model) {
    if (model.variants.isNotEmpty) {
      return model.variants.first.title;
    }
    return null;
  }

  void selectAllFilter() {
    filterCategory = null;
    filterCategoryIndex = 0;
    isAllFilterSelected = true;
    emit(ProductUpdateState());
  }

  void selectFilterCategory(ProductCategoryModel category, int index) {
    filterCategory = category;
    filterCategoryIndex = index;
    isAllFilterSelected = false;
    emit(ProductUpdateState());
  }

  List<ProductModel> get filteredProducts {
    /// ✅ STEP 1: KEEP YOUR ORIGINAL LOGIC
    List<ProductModel> temp;

    if (isAllFilterSelected || filterCategory == null) {
      temp = lstProduct;
    } else {
      temp = lstProduct
          .where(
            (product) =>
        product.categoryName == filterCategory?.categoryName,
      )
          .toList();
    }

    /// ✅ STEP 2: APPLY SEARCH ON TOP (NO CHANGE TO YOUR LOGIC)
    if (searchQuery.isNotEmpty) {
      temp = temp.where((product) {
        final name = product.name.toLowerCase();
        final category = product.categoryName.toLowerCase();

        return name.contains(searchQuery) ||
            category.contains(searchQuery);
      }).toList();
    }

    return temp;
  }

  // List<ProductModel> get filteredProducts {
  //   if (isAllFilterSelected || filterCategory == null) {
  //     return lstProduct;
  //   }
  //
  //   return lstProduct
  //       .where(
  //         (product) => product.categoryName == filterCategory?.categoryName,
  //       )
  //       .toList();
  // }

  void searchProducts(String query) {
    searchQuery = query.toLowerCase();
    emit(ProductUpdateState());
  }

  void resetFilterData() {
    filterCategory = null;
    filterCategoryIndex = null;
    isAllFilterSelected = true;
    emit(ProductInitial());
  }
}
