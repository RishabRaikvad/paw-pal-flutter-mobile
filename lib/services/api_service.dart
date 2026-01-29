import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:paw_pal_mobile/core/constant.dart';

import '../model/city_model.dart';
import '../model/state_model.dart';

class ApiService {
  static final String apiKey = Constant.stateWiseCityApiKey;

  static Map<String, String> get headers => {
    "X-CSCAPI-KEY": apiKey,
    // "Content-Type": "application/json",
  };

  static Future<http.Response> get(String url) {
    return http.get(Uri.parse(url), headers: headers);
  }

  Future<List<StateModel>> fetchStates() async {
    final res = await get(
      Constant.stateWiseCityApi,
    );

    final List data = json.decode(res.body);
    return data.map((e) => StateModel.fromJson(e)).toList();
  }

  Future<List<CityModel>> fetchCities(String stateCode) async {
    final res = await get(
      "${Constant.stateWiseCityApi}/$stateCode/cities",
    );

    final List data = json.decode(res.body);
    return data.map((e) => CityModel.fromJson(e)).toList();
  }


}