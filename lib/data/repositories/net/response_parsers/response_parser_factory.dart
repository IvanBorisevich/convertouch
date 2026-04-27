import 'package:convertouch/data/entities/data_source_entity.dart';
import 'package:convertouch/data/repositories/net/response_parsers/exchange_rate_response_parser.dart';
import 'package:convertouch/data/repositories/net/response_parsers/list_values_response_parser.dart';
import 'package:convertouch/data/repositories/net/response_parsers/response_parser.dart';
import 'package:convertouch/domain/constants/constants.dart';

class ResponseParserFactory {
  static ResponseParser getInstance(DataSourceEntity dataSource) {
    if (dataSource is MainDataSourceEntity) {
      return _getForDynamicDataType(dataSource.dynamicDataType);
    }

    if (dataSource is ListValuesDataSourceEntity) {
      return _getForListType(dataSource.listType);
    }

    throw Exception("No response parser found for data source: $dataSource");
  }

  static ResponseParser _getForDynamicDataType(
    DynamicDataType dynamicDataType,
  ) {
    switch (dynamicDataType) {
      case DynamicDataType.exchangeRate:
        return const ExchangeRateResponseParser();
    }
  }

  static ResponseParser _getForListType(ConvertouchListType listType) {
    return const ListValuesResponseParser();
  }
}
