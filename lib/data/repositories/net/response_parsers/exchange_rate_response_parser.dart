import 'dart:convert';

import 'package:convertouch/data/entities/response_entity.dart';
import 'package:convertouch/data/repositories/net/response_parsers/response_parser.dart';

class ExchangeRateResponseParser extends ResponseParser {
  const ExchangeRateResponseParser();

  @override
  DynamicCoefficientsResponseEntity parse(String rawJson) {
    Map<String, dynamic> raw = json.decode(rawJson);
    Map<String, double?> unitCodeToCoefficient = {};

    for (MapEntry<String, dynamic> entry in raw.entries) {
      if (entry.value != null) {
        unitCodeToCoefficient.putIfAbsent(
          entry.key,
          () => entry.value * 1.0,
        );
      }
    }

    return DynamicCoefficientsResponseEntity(unitCodeToCoefficient);
  }
}
