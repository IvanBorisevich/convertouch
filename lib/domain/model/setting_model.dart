class SettingItemModel<T> {
  final String key;
  final T value;

  const SettingItemModel({
    required this.key,
    required this.value,
  });

  @override
  String toString() {
    return 'SettingItemModel{'
        'key: $key, '
        'value: $value}';
  }
}