import 'package:convertouch/domain/utils/response_transformers/float_rates_response_transformer.dart';

const floatRatesResponseTransformer = "FloatRatesResponseTransformer";

abstract class ResponseTransformer<V> {
  static T getInstance<T extends ResponseTransformer>(String name) {
    switch (name) {
      case floatRatesResponseTransformer:
        return FloatRatesCurrencyRatesResponseTransformer() as T;
      default:
        throw Exception("No transformer found by the name '$name'");
    }
  }

  Map<String, V?> transform(String jsonResponse);
}

abstract class UnitCoefficientsResponseTransformer
    extends ResponseTransformer<double> {}

abstract class UnitValuesResponseTransformer
    extends ResponseTransformer<String> {}
