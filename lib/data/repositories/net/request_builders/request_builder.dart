import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';

enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE'),
  patch('PATCH');

  final String value;

  const HttpMethod(this.value);
}

abstract class RequestBuilder {
  final HttpMethod httpMethod;
  final String path;

  const RequestBuilder({
    required this.httpMethod,
    required this.path,
  });

  Map<String, dynamic>? buildQueryParams({
    required ConversionParamSetValueModel params,
    int? pageSize,
    int? pageNum,
  });

  Map<String, String>? buildHeaders({
    required ConversionParamSetValueModel params,
    int? pageSize,
    int? pageNum,
  });

  bool readyForFetch(ConversionParamSetValueModel params);
}
