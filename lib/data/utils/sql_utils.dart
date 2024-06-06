class SqlUtils {
  const SqlUtils._();

  static String? getUpdateQuery({
    required String tableName,
    required int id,
    required Map<String, Object?> row,
    List<String> excludedColumns = const [],
  }) {
    mappingFunc(MapEntry<String, Object?> e) {
      String name = e.key;
      Object? value;
      if (!excludedColumns.contains(e.key) && e.value != null) {
        value = e.value.runtimeType == String ? "'${e.value}'" : e.value;
        return '$name = $value';
      }
      return null;
    }

    List<String> setClauses = row.entries.map(mappingFunc).nonNulls.toList();
    return setClauses.isNotEmpty
        ? 'UPDATE $tableName SET '
            '${setClauses.join(', ')}'
            ' WHERE id = $id'
        : null;
  }
}
