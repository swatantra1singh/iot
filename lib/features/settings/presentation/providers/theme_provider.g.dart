// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsPreferencesHash() => r'settings_preferences_hash';

/// Provider for SharedPreferences instance.
///
/// Copied from [settingsPreferences].
@ProviderFor(settingsPreferences)
final settingsPreferencesProvider = FutureProvider<SharedPreferences>.internal(
  settingsPreferences,
  name: r'settingsPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SettingsPreferencesRef = FutureProviderRef<SharedPreferences>;

String _$themeModeNotifierHash() => r'theme_mode_notifier_hash';

/// Notifier for theme mode state management.
///
/// Copied from [ThemeModeNotifier].
@ProviderFor(ThemeModeNotifier)
final themeModeNotifierProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>.internal(
  ThemeModeNotifier.new,
  name: r'themeModeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeModeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeModeNotifier = Notifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
