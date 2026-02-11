import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/pet_with_owner.dart';
import 'package:paw_pal_mobile/services/firestore_service.dart';

import '../../model/pet_model.dart';

part 'pet_state.dart';

class PetCubit extends Cubit<PetState> {
  PetCubit() : super(PetInitial());
  final fireStore = FireStoreService().fireStore;

  List<PetWithOwner> petList = [];

  Future<void> loadPets() async {
    petList.isEmpty ? emit(PetLoadingState()) : emit(PetRefreshState());
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) return;
      final petData = await fireStore
          .collection('pets')
          .where('isAvailable', isEqualTo: true)
          .where('ownerId', isNotEqualTo: user.uid)
          .orderBy('ownerId')
          .get();

      final pets = petData.docs.map((e) => PetModel.fromDoc(e)).toList();

      petList = await Future.wait(
        pets.map((pet) async {
          final ownerDoc = await fireStore
              .collection('users')
              .doc(pet.ownerId)
              .get();

          final ownerData = ownerDoc.data() ?? {};

          return PetWithOwner(
            pet: pet,
            ownerName: ownerData['name'] ?? '',
            ownerPhone: ownerData['phone'] ?? '',
            ownerAddress: ownerData['address'] ?? '',
            ownerCity: ownerData['city'] ?? '',
            ownerState: ownerData['state'] ?? '',
          );
        }),
      );
      emit(PetSuccessState());
    } catch (e) {
      emit(PetErrorState(e.toString()));
    }
  }
}
