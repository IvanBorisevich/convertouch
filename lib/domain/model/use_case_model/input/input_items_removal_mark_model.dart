class InputItemsRemovalMarkModel {
  final int newMarkedId;
  final List<int> alreadyMarkedIds;
  final List<int> oobIds;

  const InputItemsRemovalMarkModel({
    required this.newMarkedId,
    required this.alreadyMarkedIds,
    required this.oobIds,
  });
}
