import 'dart:convert';

import 'package:convertouch/domain/utils/response_transformers/response_transformer.dart';

class FloatRatesCurrencyRatesResponseTransformer
    extends UnitCoefficientsResponseTransformer {
  @override
  Map<String, double> transform(String jsonResponse) {
    Map<String, dynamic> responseMap = json.decode(jsonResponse);
    return {
      for (MapEntry<String, dynamic> entry in responseMap.entries)
        entry.value["code"]: entry.value["rate"] as double
    };
  }
}
