import 'package:convertouch/data/repositories/net/request_builders/request_builder.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';

class ExchangeRateRequestBuilder extends RequestBuilder {
  const ExchangeRateRequestBuilder();

  @override
  Map<String, dynamic>? buildQueryParams(ConversionParamSetValueModel params) {
    return {
      'source': params.getParamValue(ParamNames.source)!.raw,
      'bank': params.getParamValue(ParamNames.bank)!.raw,
    };
  }

  @override
  Map<String, String>? buildHeaders(ConversionParamSetValueModel params) {
    return null;
  }

  @override
  HttpMethod get method => HttpMethod.get;
}