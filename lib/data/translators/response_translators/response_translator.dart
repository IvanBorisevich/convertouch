import 'package:convertouch/data/translators/response_translators/currency_rates/default_currency_rate_translator.dart';
import 'package:convertouch/data/translators/response_translators/currency_rates/float_rates_translator.dart';
import 'package:convertouch/data/translators/response_translators/temperature/default_temperature_translator.dart';

abstract class ResponseTranslator<M> {
  const ResponseTranslator();

  M toEntity(String rawJson);
}

abstract class DynamicCoefficientsResponseTranslator
    extends ResponseTranslator<Map<String, double?>> {
  const DynamicCoefficientsResponseTranslator();

  factory DynamicCoefficientsResponseTranslator.getInstance(String name) {
    switch (name) {
      case "defaultCurrencyRatesTranslator":
        return DefaultCurrencyRateTranslator();
      case "floatRatesTranslator":
        return FloatRatesTranslator();
    }
    throw Exception("No transformer found by name '$name'");
  }
}

abstract class DynamicValuesResponseTranslator
    extends ResponseTranslator<Map<String, String?>?> {
  const DynamicValuesResponseTranslator();

  factory DynamicValuesResponseTranslator.getInstance(String name) {
    return DefaultTemperatureTranslator();
  }
}

const defaultCurrencyRatesTranslator = "defaultCurrencyRatesTranslator";
const floatRatesTranslator = "floatRatesTranslator";
