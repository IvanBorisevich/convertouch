import 'dart:convert';

import 'package:convertouch/data/entities/response_entity.dart';
import 'package:convertouch/data/repositories/net/response_parsers/response_parser.dart';
import 'package:convertouch/domain/model/value_model.dart';

class ListValuesResponseParser extends ResponseParser {
  const ListValuesResponseParser();

  @override
  ResponseEntity parse(String rawJson) {
    List<dynamic> jsonListValues = json.decode(rawJson);

    List<ValueModel> listValues = jsonListValues
        .whereType<Map<String, dynamic>>()
        .map((item) => ValueModel.fromJson(item)!)
        .toList();

    return DynamicListValuesResponseEntity(listValues);
  }
}
