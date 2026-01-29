class CityModel {
  final String name;

  CityModel({required this.name});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(name: json['name']);
  }
}
