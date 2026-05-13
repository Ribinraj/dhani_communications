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

  /// ---------- CLEAR (preserves FCM token) ----------
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    // Preserve the FCM token across logouts — it's device-level, not session-level
    final fcmToken = prefs.getString(StorageKeys.fcmToken);
    final languageCode = prefs.getString(StorageKeys.languageCode);
    await prefs.clear();
    if (fcmToken != null) {
      await prefs.setString(StorageKeys.fcmToken, fcmToken);
    }
    if (languageCode != null) {
      await prefs.setString(StorageKeys.languageCode, languageCode);
    }
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

  /// ---------- FCM TOKEN HELPERS ----------
  static Future<void> saveFcmToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.fcmToken, token);
  }

  static Future<String?> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.fcmToken);
  }

  static Future<void> removeFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.fcmToken);
  }

  static Future<void> saveLanguageCode(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.languageCode, languageCode);
  }

  static Future<String> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.languageCode) ?? '';
  }
}

