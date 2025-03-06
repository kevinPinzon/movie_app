import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorageService {
  static const String _themeKey = 'is_dark_mode';
  static const String _isFirstTimeKey = 'is_first_time';
  final SharedPreferences _prefs;

  ThemeStorageService(this._prefs);

  static Future<ThemeStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemeStorageService(prefs);
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    await _prefs.setBool(_themeKey, isDarkMode);
    await _prefs.setBool(_isFirstTimeKey, false);
  }

  bool getDarkMode() {
    return _prefs.getBool(_themeKey) ?? false;
  }

  bool isFirstTime() {
    return _prefs.getBool(_isFirstTimeKey) ?? true;
  }
}
