import 'dart:convert';

import 'package:convertouch/data/entities/response_entity.dart';
import 'package:convertouch/data/repositories/net/response_parsers/response_parser.dart';
import 'package:convertouch/domain/model/list_value_model.dart';

class ListValuesResponseParser extends ResponseParser {
  const ListValuesResponseParser();

  @override
  ResponseEntity parse(String rawJson) {
    List<Map<String, dynamic>> jsonListValues = json.decode(rawJson);

    List<ListValueModel> listValues =
        jsonListValues.map((item) => ListValueModel.fromJson(item)!).toList();

    return DynamicListValuesResponseEntity(listValues);
  }
}
