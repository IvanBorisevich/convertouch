enum DynamicDataType {
  exchangeRate,
}

class DataSourceEntity {
  final String path;
  final DynamicDataType dynamicDataType;

  const DataSourceEntity({
    required this.path,
    required this.dynamicDataType,
  });
}
