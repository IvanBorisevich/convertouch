import 'dart:convert';

import 'package:convertouch/domain/utils/response_transformers/response_transformer.dart';

class DefaultRatesResponseTransformer extends UnitCoefficientsResponseTransformer {
  const DefaultRatesResponseTransformer();

  @override
  Map<String, double?> transform(String jsonResponse) {
    Map<String, dynamic> raw = json.decode(jsonResponse);
    Map<String, double?> result = {};

    for (MapEntry<String, dynamic> entry in raw.entries) {
      if (entry.value != null) {
        result.putIfAbsent(entry.key, () => entry.value);
      }
    }

    return result;
  }

}