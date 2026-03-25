class HospitalModel {
  final String id;
  final String hospitalName;
  final String aboutHospital;
  final String imageUrl;
  final String contactNumber;
  final String address;
  final List<String> specializations;
  final List<AvailabilityModel> availability;
  bool isAvailable;

  HospitalModel({
    required this.id,
    required this.hospitalName,
    required this.aboutHospital,
    required this.imageUrl,
    required this.contactNumber,
    required this.address,
    required this.specializations,
    required this.availability,
    this.isAvailable = false
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'] ?? "",
      hospitalName: json['hospitalName'] ?? "",
      aboutHospital: json['aboutHospital'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
      contactNumber: json['contactNumber'] ?? "",
      address: json['address'] ?? "",
      specializations: json['specializations'] != null
          ? List<String>.from(json['specializations'])
          : [],
      availability: json['availability'] != null
          ? (json['availability'] as List)
          .map((e) => AvailabilityModel.fromJson(e))
          .toList()
          : [],
      isAvailable: json['isAvailable'] ?? false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "hospitalName": hospitalName,
      "aboutHospital": aboutHospital,
      "imageUrl": imageUrl,
      "contactNumber": contactNumber,
      "address": address,
      "specializations": specializations,
      "availability": availability.map((e) => e.toJson()).toList(),
      "isAvailable" : isAvailable
    };
  }
}
class AvailabilityModel {
  final String day;
   bool? isOpen;
   String? startTime;
   String?  endTime;

  AvailabilityModel({
    required this.day,
     this.isOpen = false,
     this.startTime,
     this.endTime,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      day: json['day'] ?? "",
      isOpen: json['isOpen'] ?? false,
      startTime: json['startTime'] ?? "",
      endTime: json['endTime'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "isOpen": isOpen,
      "startTime": startTime,
      "endTime": endTime,
    };
  }
}