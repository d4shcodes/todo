import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  /// Returns cached if present, otherwise null
  static Future getCache(String key) async {
    final preferences = await SharedPreferences.getInstance();
    final jsonStr = preferences.getString(key);
    if (jsonStr == null) return null;
    return jsonDecode(jsonStr);
  }

  /// Writes a JSON-able into SharedPreferences
  static Future setCache(String key, dynamic data) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, jsonEncode(data));
  }

  /// • If we have cache → return it immediately, then refresh in the background
  /// • If no cache → await the API, cache it, then return it
  static Future fetchWithCache({required key, required apiCall}) async {
    // 1️⃣ Try to load from disk

    final cached = await getCache(key);

    if (cached != null) {
      apiCall()
          .then((freshData) {
            setCache(key, freshData);
          })
          .catchError((error) {});
      return cached;
    }

    // 2️⃣ No cache → do the call, cache the result, return it
    final fresh = await apiCall();
    await setCache(key, fresh);
    return fresh;
  }
}
