import 'package:convertouch/data/repositories/net/request_builders/request_builder.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';

class ExchangeRateSourceRequestBuilder extends RequestBuilder {
  const ExchangeRateSourceRequestBuilder({
    required super.httpMethod,
    required super.path,
  });

  @override
  Map<String, String>? buildHeaders({
    ConversionParamSetValueModel? params,
    int? pageSize,
    int? pageNum,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? buildQueryParams({
    ConversionParamSetValueModel? params,
    int? pageSize,
    int? pageNum,
  }) {
    return null;
  }

  @override
  bool readyForFetch(ConversionParamSetValueModel? params) {
    return true;
  }
}
