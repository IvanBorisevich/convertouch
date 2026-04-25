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
  const RequestBuilder();

  Map<String, dynamic>? buildQueryParams(ConversionParamSetValueModel params);

  Map<String, String>? buildHeaders(ConversionParamSetValueModel params);

  HttpMethod get method;
}
