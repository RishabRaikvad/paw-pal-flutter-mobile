import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paw_pal_mobile/bloc/petCubit/pet_cubit.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.petCubit}) : super(HomeInitial());
  final PetCubit petCubit;

  Future<void> loadHomeData() async {
    emit(HomeLoadState());
    try {
      await Future.wait([petCubit.loadPets()]);
      emit(HomeSuccessState());
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }
}
