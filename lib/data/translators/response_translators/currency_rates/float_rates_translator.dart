import 'dart:convert';

import 'package:convertouch/data/translators/response_translators/response_translator.dart';

class FloatRatesTranslator extends DynamicCoefficientsResponseTranslator {
  static const FloatRatesTranslator _singleton =
      FloatRatesTranslator._internal();

  factory FloatRatesTranslator() => _singleton;

  const FloatRatesTranslator._internal();

  @override
  Map<String, double?> toEntity(String rawJson) {
    Map<String, dynamic> responseMap = json.decode(rawJson);
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
