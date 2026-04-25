import 'package:convertouch/data/entities/data_source_entity.dart';
import 'package:convertouch/data/repositories/net/response_parsers/exchange_rate_response_parser.dart';
import 'package:convertouch/data/repositories/net/response_parsers/response_parser.dart';

class ResponseParserFactory {
  static ResponseParser getInstance(DynamicDataType dynamicDataType) {
    switch (dynamicDataType) {
      case DynamicDataType.exchangeRate:
        return const ExchangeRateResponseParser();
    }
  }
}
