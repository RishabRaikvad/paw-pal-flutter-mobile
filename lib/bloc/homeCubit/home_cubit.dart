import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paw_pal_mobile/bloc/petCubit/pet_cubit.dart';
import 'package:paw_pal_mobile/bloc/productBloc/product_cubit.dart';
import 'package:paw_pal_mobile/bloc/videoBloc/video_cubit.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.petCubit,
    required this.productCubit,
    required this.videoCubit,
  }) : super(HomeInitial());
  final PetCubit petCubit;
  final VideoCubit videoCubit;
  final ProductCubit productCubit;

  Future<void> loadHomeData() async {
    final isRefresh =
        petCubit.petList.isNotEmpty ||
        videoCubit.lstPetCareVideo.isNotEmpty ||
        productCubit.lstCategory.isNotEmpty ||
        productCubit.lstProduct.isNotEmpty;

    emit(!isRefresh ? HomeLoadState() : HomeRefreshState());
    try {
      await Future.wait([
        petCubit.loadPets(),
        productCubit.getProductsWithCategory(),
        videoCubit.getPetCareVideos(),
      ]);
      emit(HomeSuccessState());
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }
}
