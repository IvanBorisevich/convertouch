class InputItemsForRemovalModel {
  final int newMarkedId;
  final List<int> alreadyMarkedIds;
  final List<int> oobIds;

  const InputItemsForRemovalModel({
    required this.newMarkedId,
    required this.alreadyMarkedIds,
    required this.oobIds,
  });
}
