import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  String? getString(String key) => _prefs.getString(key);

  bool? getBool(String key) => _prefs.getBool(key);

  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  Future<bool> remove(String key) => _prefs.remove(key);

  bool containsKey(String key) => _prefs.containsKey(key);
}
