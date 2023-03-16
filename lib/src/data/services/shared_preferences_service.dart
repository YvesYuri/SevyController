import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  
  Future<bool> saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    var result = await prefs.setString('themeMode', themeMode.toString());
    return result;
  }

  Future<ThemeMode> readThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    var themeMode = prefs.getString('themeMode');
    if (themeMode == null) {
      return ThemeMode.system;
    } else {
      return ThemeMode.values.firstWhere((e) => e.toString() == themeMode);
    }
  }

  Future<bool> saveAccentColor(AccentColor accentColor) async {
    final prefs = await SharedPreferences.getInstance();
    var result = await prefs.setString('accentColor', accentColor.toString());
    return result;
  }

  Future<AccentColor> readAccentColor() async {
    final prefs = await SharedPreferences.getInstance();
    var accentColor = prefs.getString('accentColor');
    if (accentColor == null) {
      return Colors.accentColors[Random().nextInt(Colors.accentColors.length)];
    } else {
      return Colors.accentColors.firstWhere((e) => e.toString() == accentColor);
    }
  }

}