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
    return model.variants.first.title;
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
    if (isAllFilterSelected || filterCategory == null) {
      return lstProduct;
    }

    return lstProduct
        .where(
          (product) => product.categoryName == filterCategory?.categoryName,
        )
        .toList();
  }

  void resetFilterData() {
    filterCategory = null;
    filterCategoryIndex = null;
    isAllFilterSelected = true;
    emit(ProductInitial());
  }
}
