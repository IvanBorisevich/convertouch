class ValueModel {
  final String strValue;
  final String? scientificValue;

  const ValueModel({
    this.strValue = "",
    this.scientificValue,
  });

  @override
  String toString() {
    return strValue;
  }
}