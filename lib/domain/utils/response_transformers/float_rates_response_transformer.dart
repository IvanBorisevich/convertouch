import 'dart:convert';

import 'package:convertouch/domain/utils/response_transformers/response_transformer.dart';

class FloatRatesCurrencyRatesResponseTransformer
    extends UnitCoefficientsResponseTransformer {
  @override
  Map<String, double?> transform(String jsonResponse) {
    Map<String, dynamic> responseMap = json.decode(jsonResponse);
    Map<String, double?> result = {};

    for (MapEntry<String, dynamic> entry in responseMap.entries) {
      String key = entry.value["code"];
      dynamic rawValue = entry.value["inverseRate"];
      double? value = double.tryParse(
        rawValue != null ? rawValue.toString() : "",
      );
      result.putIfAbsent(key, () => value);
    }

    return result;
  }
}
