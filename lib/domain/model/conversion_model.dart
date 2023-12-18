class ConversionModel {
  final int? sourceUnitId;
  final String? sourceValue;
  final List<int>? targetUnitIds;
  final int? conversionUnitGroupId;

  ConversionModel({
    required this.sourceUnitId,
    required this.sourceValue,
    required this.targetUnitIds,
    required this.conversionUnitGroupId,
  });
}
