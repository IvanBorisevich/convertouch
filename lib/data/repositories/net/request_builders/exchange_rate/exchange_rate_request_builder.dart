import 'package:convertouch/data/const/constants.dart';
import 'package:convertouch/data/repositories/net/request_builders/request_builder.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';

class ExchangeRateRequestBuilder extends RequestBuilder {
  const ExchangeRateRequestBuilder();

  @override
  Map<String, String>? buildHeaders({
    required ConversionParamSetValueModel params,
    int? pageSize,
    int? pageNum,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? buildQueryParams({
    required ConversionParamSetValueModel params,
    int? pageSize,
    int? pageNum,
  }) {
    return {
      'source': params.getParamValue(ParamNames.source)!.raw,
      'bank': params.getParamValue(ParamNames.bank)!.raw,
    };
  }

  @override
  HttpMethod get method => HttpMethod.get;

  @override
  String get path => exchangeRatePath;

  @override
  bool readyForFetch(ConversionParamSetValueModel params) {
    return params.hasParamValue(ParamNames.source);
  }
}

/*

GET /currency-rate/sources

[
  {
    "value": "",
    "alt": "",
    "icon": ""
  },
  ...
]


GET /currency-rate/banks?source=...

[
  {
    "value": "",
    "alt": "",
    "icon": ""
  },
  ...
]


GET /currency-rate?source=...&bank=...

{
  "USD": 1,
  "EUR": 1.123,
  ...
}

*/