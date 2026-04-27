import 'package:convertouch/data/repositories/net/request_builders/request_builder.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';

class ExchangeRateBankRequestBuilder extends RequestBuilder {
  const ExchangeRateBankRequestBuilder();

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
    };
  }

  @override
  HttpMethod get method => HttpMethod.get;

}