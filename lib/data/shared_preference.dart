import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  late final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> saveTheme({required ThemeMode themeMode}) async {
    SharedPreferences _preferences = await _prefs;
    if (themeMode == ThemeMode.system) {
      _preferences.setString('ThemeMode', 'system');
    } else if (themeMode == ThemeMode.light) {
      _preferences.setString('ThemeMode', 'light');
    } else if (themeMode == ThemeMode.dark) {
      _preferences.setString('ThemeMode', 'dark');
    }
  }

  Future<ThemeMode> getTheme() async {
    SharedPreferences _preferences = await _prefs;
    String? themeName = _preferences.getString('ThemeMode');
    if (themeName != null) {
      if (themeName == 'system') {
        return ThemeMode.system;
      } else if (themeName == 'light') {
        return ThemeMode.light;
      } else if (themeName == 'dark') {
        return ThemeMode.dark;
      } else {
        throw ('Theme Not Found');
      }
    } else {
      return ThemeMode.system;
    }
  }

  //Future<void> saveOrder({required String order}) async {}
  //Future<String> getOrder() async {}
}
