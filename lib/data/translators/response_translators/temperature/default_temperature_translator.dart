import 'package:convertouch/data/translators/response_translators/response_translator.dart';

class DefaultTemperatureTranslator extends DynamicValuesResponseTranslator {
  static const DefaultTemperatureTranslator _singleton =
      DefaultTemperatureTranslator._internal();

  factory DefaultTemperatureTranslator() => _singleton;

  const DefaultTemperatureTranslator._internal();

  @override
  Map<String, String?>? toEntity(String rawJson) {
    return null;
  }
}
