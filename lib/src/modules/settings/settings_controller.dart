import 'dart:math';

import 'package:controller/src/data/services/shared_preferences_service.dart';
import 'package:fluent_ui/fluent_ui.dart';


class SettingsController extends ChangeNotifier {
  SettingsController() {
    init();
  }

  final sharedPreferencesService = SharedPreferencesService();

  ThemeMode themeMode = ThemeMode.system;
  AccentColor accentColor =
      Colors.accentColors[Random().nextInt(Colors.accentColors.length)];

  Future<void> changeThemeMode(ThemeMode themeMode) async {
    this.themeMode = themeMode;
    await sharedPreferencesService.saveThemeMode(themeMode);
    notifyListeners();
  }

  Future<void> changeAccentColor(AccentColor accentColor) async {
    this.accentColor = accentColor;
    await sharedPreferencesService.saveAccentColor(accentColor);
    notifyListeners();
  }

  Future<void> init() async {
    // themeMode = await sharedPreferencesService.readThemeMode();
    // accentColor = await sharedPreferencesService.readAccentColor();
    // notifyListeners();
  }
}
