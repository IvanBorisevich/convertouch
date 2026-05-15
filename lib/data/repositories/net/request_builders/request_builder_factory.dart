import 'package:convertouch/data/repositories/net/request_builders/exchange_rate/exchange_rate_bank_request_builder.dart';
import 'package:convertouch/data/repositories/net/request_builders/exchange_rate/exchange_rate_request_builder.dart';
import 'package:convertouch/data/repositories/net/request_builders/exchange_rate/exchange_rate_source_request_builder.dart';
import 'package:convertouch/data/repositories/net/request_builders/request_builder.dart';
import 'package:convertouch/domain/constants/constants.dart';

class _RequestBuilderFactory {
  static const instance = _RequestBuilderFactory._();

  const _RequestBuilderFactory._();

  RequestBuilder getByGroupAndParamSet(
    String groupName,
    String paramSetName,
  ) {
    final builder = _commonBuilders[groupName]?[paramSetName];

    if (builder == null) {
      throw Exception("No request builder found for group: $groupName, "
          "param set: $paramSetName");
    }

    return builder;
  }

  RequestBuilder getByListType(ConvertouchListType listType) {
    final builder = _listValuesBuilders[listType];

    if (builder == null) {
      throw Exception("No request builder found for list type: $listType");
    }

    return builder;
  }
}

const Map<String, Map<String, RequestBuilder>> _commonBuilders = {
  GroupNames.currency: {
    ParamSetNames.exchangeRate: ExchangeRateRequestBuilder(),
  },
};

const Map<ConvertouchListType, RequestBuilder> _listValuesBuilders = {
  ConvertouchListType.exchangeRateSource: ExchangeRateSourceRequestBuilder(),
  ConvertouchListType.exchangeRateBank: ExchangeRateBankRequestBuilder(),
};

const requestBuilders = _RequestBuilderFactory.instance;
