

import 'package:convertouch/domain/constants/constants.dart';

enum DynamicDataType {
  exchangeRate,
}

abstract class DataSourceEntity {
  final String path;

  const DataSourceEntity({
    required this.path,
  });
}

class ListValuesDataSourceEntity extends DataSourceEntity {
  final ConvertouchListType listType;

  const ListValuesDataSourceEntity({
    required super.path,
    required this.listType,
  });
}

class MainDataSourceEntity extends DataSourceEntity {
  final DynamicDataType dynamicDataType;

  const MainDataSourceEntity({
    required super.path,
    required this.dynamicDataType,
  });
}
