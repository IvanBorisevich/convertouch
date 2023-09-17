class UnitEntity {
  final int id;
  final String name;
  final String abbreviation;
  final double coefficient;
  final int unitGroupId;

  const UnitEntity({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.coefficient,
    required this.unitGroupId,
  });
}