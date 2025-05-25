import 'package:brain_bench/data/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _lastSelectedCategoryIdKey = 'last_selected_category_id';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  final SharedPreferences _prefs;

  SharedPreferencesSettingsRepository(this._prefs);

  @override
  Future<void> saveLastSelectedCategoryId(String categoryId) async {
    await _prefs.setString(_lastSelectedCategoryIdKey, categoryId);
  }

  @override
  Future<String?> loadLastSelectedCategoryId() async {
    return _prefs.getString(_lastSelectedCategoryIdKey);
  }

  @override
  Future<void> clearLastSelectedCategoryId() async {
    await _prefs.remove(_lastSelectedCategoryIdKey);
  }
}
