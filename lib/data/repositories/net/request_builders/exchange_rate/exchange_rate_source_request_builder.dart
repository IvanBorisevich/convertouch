import 'package:convertouch/data/repositories/net/request_builders/request_builder.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';

class ExchangeRateSourceRequestBuilder extends RequestBuilder {
  const ExchangeRateSourceRequestBuilder();

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
    return null;
  }

  @override
  HttpMethod get method => HttpMethod.get;

  @override
  bool readyForFetch(ConversionParamSetValueModel params) {
    return true;
  }
}
