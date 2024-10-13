class InputItemsMarkingModel {
  final int newMarkedId;
  final List<int> alreadyMarkedIds;
  final List<int> excludedIds;

  const InputItemsMarkingModel({
    required this.newMarkedId,
    required this.alreadyMarkedIds,
    this.excludedIds = const [],
  });
}
