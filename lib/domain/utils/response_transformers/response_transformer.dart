import 'package:convertouch/domain/utils/response_transformers/exchange_rate_response_transformer.dart';
import 'package:convertouch/domain/utils/response_transformers/float_rates_response_transformer.dart';

const floatRatesResponseTransformer = "FloatRatesResponseTransformer";
const exchangeRateResponseTransformer = "ExchangeRateResponseTransformer";

const transformersMap = {
  floatRatesResponseTransformer: FloatRatesResponseTransformer(),
  exchangeRateResponseTransformer: ExchangeRateResponseTransformer(),
};

abstract class ResponseTransformer<V> {
  const ResponseTransformer();

  static T getInstance<T extends ResponseTransformer>(String name) {
    if (transformersMap.containsKey(name)) {
      return transformersMap[name] as T;
    }
    throw Exception("No transformer found by name '$name'");
  }

  Map<String, V?> transform(String jsonResponse);
}

abstract class UnitCoefficientsResponseTransformer
    extends ResponseTransformer<double> {
  const UnitCoefficientsResponseTransformer();
}

abstract class UnitValuesResponseTransformer
    extends ResponseTransformer<String> {
  const UnitValuesResponseTransformer();
}
