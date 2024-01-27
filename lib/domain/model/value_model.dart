class ValueModel {
  final String strValue;
  final String? scientificValue;

  const ValueModel({
    required this.strValue,
    this.scientificValue,
  });

  bool hasValue() {
    return strValue.isNotEmpty;
  }

  @override
  String toString() {
    return strValue;
  }
}

const ValueModel defaultValueModel = ValueModel(
  strValue: "1",
  scientificValue: "1",
);

const ValueModel emptyValueModel = ValueModel(
  strValue: "",
  scientificValue: "",
);