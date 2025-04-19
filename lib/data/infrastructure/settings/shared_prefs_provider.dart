import 'package:brain_bench/data/repositories/settings_repository.dart';
import 'package:brain_bench/data/repositories/shared_prefs_settings_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs_provider.g.dart';

// Provider for the SharedPreferences instance (remains manual or could be generated if needed)
// This needs to be overridden in main.dart's ProviderScope
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
      'SharedPreferences must be provided via ProviderScope overrides');
});

// Provider for the SettingsRepository using code generation
@riverpod
SettingsRepository settingsRepository(Ref ref) {
  // Function name becomes provider base name
  // Get the SharedPreferences instance from the other provider
  final prefs = ref.watch(sharedPreferencesProvider);
  // Create and return the repository implementation
  return SharedPreferencesSettingsRepository(prefs);
}
