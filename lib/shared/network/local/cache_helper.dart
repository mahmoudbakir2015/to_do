import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future putData({
    required bool value,
    required String key,
  }) async {
    return sharedPreferences?.setBool(
      key,
      value,
    );
  }

  static Future<bool?> getData({
    required String key,
  }) async {
    return sharedPreferences?.getBool(
      key,
    );
  }
}
