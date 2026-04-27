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
  bool readyForFetch(ConversionParamSetValueModel params) {
    return params.hasParamValue(ParamNames.source);
  }
}