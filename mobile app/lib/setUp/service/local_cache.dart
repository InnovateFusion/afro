import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveString(String key, String value) async {
    await _sharedPreferences?.setString(key, value);
  }

  static String? getString(String key) {
    return _sharedPreferences?.getString(key);
  }

  static Future<void> saveBool(String key, bool value) async {
    await _sharedPreferences?.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _sharedPreferences?.getBool(key);
  }

  static Future<void> remove(String key) async {
    await _sharedPreferences?.remove(key);
  }

  static Future<void> clear() async {
    await _sharedPreferences?.clear();
  }
}
