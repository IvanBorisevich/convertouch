import 'dart:convert';

import 'package:convertouch/data/translators/response_translators/response_translator.dart';

class DefaultCurrencyRateTranslator
    extends DynamicCoefficientsResponseTranslator {
  static const DefaultCurrencyRateTranslator _singleton =
      DefaultCurrencyRateTranslator._internal();

  factory DefaultCurrencyRateTranslator() => _singleton;

  const DefaultCurrencyRateTranslator._internal();

  @override
  Map<String, double?> toEntity(String rawJson) {
    Map<String, dynamic> raw = json.decode(rawJson);
    Map<String, double?> result = {};

    for (MapEntry<String, dynamic> entry in raw.entries) {
      if (entry.value != null) {
        result.putIfAbsent(entry.key, () => entry.value);
      }
    }

    return result;
  }
}
