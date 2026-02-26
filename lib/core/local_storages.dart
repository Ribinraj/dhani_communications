import 'package:dhani_communications/core/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  /// ---------- SAVE BASIC AUTH DATA ----------
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.userToken, token);
  }

  ///------------GET DATA------------------////
  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.userToken) ?? '';
  }

  /// ---------- CLEAR ----------
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// ---------- SAVE USER NAME ----------
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.userName, name);
  }

  /// ---------- GET USER NAME ----------
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.userName) ?? '';
  }
}
