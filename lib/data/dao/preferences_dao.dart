abstract class PreferencesDao {
  const PreferencesDao();

  Future<int?> getInt(String key);
  Future<bool> saveInt(String key, int value);

  Future<String?> getString(String key);
  Future<bool> saveString(String key, String value);

  Future<List<String>?> getStringList(String key);
  Future<bool> saveStringList(String key, List<String> value);
}