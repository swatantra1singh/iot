import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

/// Key for storing theme mode in SharedPreferences.
const String _themeModeKey = 'theme_mode';

/// Provider for SharedPreferences instance.
@Riverpod(keepAlive: true)
Future<SharedPreferences> settingsPreferences(SettingsPreferencesRef ref) async {
  return SharedPreferences.getInstance();
}

/// Notifier for theme mode state management.
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    _loadThemeMode();
    return ThemeMode.system;
  }

  Future<void> _loadThemeMode() async {
    final prefs = await ref.read(settingsPreferencesProvider.future);
    final themeModeIndex = prefs.getInt(_themeModeKey);
    if (themeModeIndex != null) {
      state = ThemeMode.values[themeModeIndex];
    }
  }

  /// Sets the theme mode and persists it.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await ref.read(settingsPreferencesProvider.future);
    await prefs.setInt(_themeModeKey, mode.index);
  }

  /// Toggles between light and dark theme.
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }
}
