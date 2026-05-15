import 'package:convertouch/data/repositories/net/response_parsers/exchange_rate_response_parser.dart';
import 'package:convertouch/data/repositories/net/response_parsers/list_values_response_parser.dart';
import 'package:convertouch/data/repositories/net/response_parsers/response_parser.dart';
import 'package:convertouch/domain/constants/constants.dart';

class _ResponseParserFactory {
  static const instance = _ResponseParserFactory._();

  const _ResponseParserFactory._();

  ResponseParser getByGroupAndParamSet(
    String groupName,
    String paramSetName,
  ) {
    final parser = _commonParsers[groupName]?[paramSetName];

    if (parser == null) {
      throw Exception("No response parser found for group: $groupName, "
          "param set: $paramSetName");
    }

    return parser;
  }

  ResponseParser getByListType(ConvertouchListType listType) {
    return _listValuesParser;
  }
}

const Map<String, Map<String, ResponseParser>> _commonParsers = {
  GroupNames.currency: {
    ParamSetNames.exchangeRate: ExchangeRateResponseParser(),
  },
};

const _listValuesParser = ListValuesResponseParser();

const responseParsers = _ResponseParserFactory.instance;
