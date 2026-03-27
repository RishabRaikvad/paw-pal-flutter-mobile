import 'package:paw_pal_mobile/model/pet_model.dart';

class PetWithOwner {
  final PetModel pet;
  final String ownerName;
  final String ownerLastName;
  final String ownerImage;
  final String ownerPhone;
  final String ownerEmail;
  final String ownerAddress;
  final String ownerCity;
  final String ownerState;
  final String pinCode;

  PetWithOwner({
    required this.pet,
    required this.ownerName,
    required this.ownerLastName,
    required this.ownerImage,
    required this.ownerPhone,
    required this.ownerEmail,
    required this.ownerAddress,
    required this.ownerCity,
    required this.ownerState,
    required this.pinCode
  });
}