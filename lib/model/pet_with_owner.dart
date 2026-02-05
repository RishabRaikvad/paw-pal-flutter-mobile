import 'package:paw_pal_mobile/model/pet_model.dart';

class PetWithOwner {
  final PetModel pet;
  final String ownerName;
  final String ownerPhone;
  final String ownerAddress;
  final String ownerCity;
  final String ownerState;

  PetWithOwner({
    required this.pet,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerAddress,
    required this.ownerCity,
    required this.ownerState,
  });
}