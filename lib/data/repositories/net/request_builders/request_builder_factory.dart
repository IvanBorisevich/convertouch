import 'package:convertouch/data/entities/data_source_entity.dart';
import 'package:convertouch/data/repositories/net/request_builders/exchange_rate_request_builder.dart';
import 'package:convertouch/data/repositories/net/request_builders/request_builder.dart';

class RequestBuilderFactory {
  static RequestBuilder getInstance(DynamicDataType dynamicDataType) {
    switch (dynamicDataType) {
      case DynamicDataType.exchangeRate:
        return const ExchangeRateRequestBuilder();
    }
  }
}