import 'package:convertouch/data/entities/data_source_entity.dart';
import 'package:convertouch/data/repositories/net/request_builders/exchange_rate/exchange_rate_bank_request_builder.dart';
import 'package:convertouch/data/repositories/net/request_builders/exchange_rate/exchange_rate_request_builder.dart';
import 'package:convertouch/data/repositories/net/request_builders/exchange_rate/exchange_rate_source_request_builder.dart';
import 'package:convertouch/data/repositories/net/request_builders/request_builder.dart';
import 'package:convertouch/domain/constants/constants.dart';

class RequestBuilderFactory {
  static RequestBuilder getInstance(DataSourceEntity dataSource) {
    if (dataSource is MainDataSourceEntity) {
      return _getForDynamicDataType(dataSource.dynamicDataType);
    }

    if (dataSource is ListValuesDataSourceEntity) {
      return _getForListType(dataSource.listType);
    }

    throw Exception("No request builder found for data source: $dataSource");
  }

  static RequestBuilder _getForDynamicDataType(
      DynamicDataType dynamicDataType) {
    switch (dynamicDataType) {
      case DynamicDataType.exchangeRate:
        return const ExchangeRateRequestBuilder();
    }
  }

  static RequestBuilder _getForListType(ConvertouchListType listType) {
    switch (listType) {
      case ConvertouchListType.exchangeRateSource:
        return const ExchangeRateSourceRequestBuilder();
      case ConvertouchListType.exchangeRateBank:
        return const ExchangeRateBankRequestBuilder();
      default:
        throw Exception("No request builder found for list type: $listType");
    }
  }
}
