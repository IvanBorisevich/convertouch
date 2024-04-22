import 'dart:convert';
import 'dart:developer';

import 'package:convertouch/domain/utils/response_transformers/response_transformer.dart';

class ExchangeRateResponseTransformer
    extends UnitCoefficientsResponseTransformer {
  const ExchangeRateResponseTransformer();

  @override
  Map<String, double?> transform(String jsonResponse) {
    try {
      Map<String, dynamic> responseMap = json.decode(jsonResponse);

      if (responseMap["result"] != "success" ||
          !responseMap.containsKey("conversion_rates")) {
        log("ExchangeRate response does not contain conversion_rates param");
        return {};
      }

      Map<String, dynamic> conversionRatesMap = responseMap["conversion_rates"];
      Map<String, double?> result = {};

      for (MapEntry<String, dynamic> entry in conversionRatesMap.entries) {
        if (entry.value != null) {
          result.putIfAbsent(entry.key, () => 1 / entry.value);
        }
      }

      return result;
    } catch (e, stacktrace) {
      log("Error occurred during ExchangeRate response transformation: "
          "$e: $stacktrace");
      return {};
    }
  }
}
