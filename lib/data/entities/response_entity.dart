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
