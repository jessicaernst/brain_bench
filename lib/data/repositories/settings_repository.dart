abstract class SettingsRepository {
  Future<void> saveLastSelectedCategoryId(String categoryId);
  Future<String?> loadLastSelectedCategoryId();
  Future<void> clearLastSelectedCategoryId();
}
