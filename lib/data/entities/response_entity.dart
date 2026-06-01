import 'package:convertouch/domain/model/value_model.dart';

abstract class ResponseEntity {
  const ResponseEntity();
}

class DynamicValueResponseEntity extends ResponseEntity {
  final Map<String, String?> unitCodeToValue;

  const DynamicValueResponseEntity(this.unitCodeToValue);
}

class DynamicCoefficientsResponseEntity extends ResponseEntity {
  final Map<String, double?> unitCodeToCoefficient;

  const DynamicCoefficientsResponseEntity(this.unitCodeToCoefficient);
}

class DynamicListValuesResponseEntity extends ResponseEntity {
  final List<ValueModel> listValues;

  const DynamicListValuesResponseEntity(this.listValues);
}
