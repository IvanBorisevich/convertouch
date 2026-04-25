import 'package:convertouch/data/entities/response_entity.dart';

abstract class ResponseParser {
  const ResponseParser();

  ResponseEntity parse(String rawJson);
}
