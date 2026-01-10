import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static String baseUrlFlavor = "baseUrlFlavor";






  Future<void> save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  Future<void> getString(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getString(key);
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  /// saving data

  // Saving String to Shared Preferences
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<void> saveStringWait(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<void> saveBoolWait(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  // Saving Bool to Shared Preferences
  static Future<void> saveBoolData(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  // Saving String to Shared Preferences
  static void saveStringData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(key, value);
  }

  // Saving Int to Shared Preferences
  static Future<void> saveIntData(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  // Saving Double to Shared Preferences
  static Future<void> saveDoubleData(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  /// reading data

  // Reading String to Shared Preferences
  static Future<String> getStringData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  // Reading Int to Shared Preferences
  static Future<int> getIntData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }


  // Reading Double to Shared Preferences
  static Future<double> getDoubleData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? 0.0;
  }

  // Reading Bool to Shared Preferences
  static Future<bool> getBoolData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  // removing data from Shared Preferences
  static Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> removeAllData() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove(userLocation);
    // prefs.remove(userData);
    await prefs.clear();
  }

  // removing data from Shared Preferences
  static Future<bool> checkValueExistence(
    SharedPreferences prefs,
    String key,
  ) async {
    return prefs.containsKey(key);
  }
}
