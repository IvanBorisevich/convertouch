import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class ItemsSelectionEvent extends ConvertouchEvent {
  const ItemsSelectionEvent();
}

class StartItemsMarking extends ItemsSelectionEvent {
  final List<int>? previouslyMarkedIds;
  final int markedItemsSelectionMinNum;
  final List<int> excludedIds;
  final bool showCancelIcon;

  const StartItemsMarking({
    this.previouslyMarkedIds,
    this.markedItemsSelectionMinNum = 1,
    this.showCancelIcon = false,
    this.excludedIds = const [],
  });

  @override
  List<Object?> get props => [
        previouslyMarkedIds,
        markedItemsSelectionMinNum,
        showCancelIcon,
        excludedIds,
      ];

  @override
  String toString() {
    return 'StartItemsMarking{'
        'previouslyMarkedIds: $previouslyMarkedIds, '
        'markedItemsSelectionMinNum: $markedItemsSelectionMinNum, '
        'excludedIds: $excludedIds, '
        'showCancelIcon: $showCancelIcon}';
  }
}

class CancelItemsMarking extends ItemsSelectionEvent {
  const CancelItemsMarking();

  @override
  String toString() {
    return 'CancelItemsMarking{}';
  }
}

class StartItemSelection extends ItemsSelectionEvent {
  final int previouslySelectedId;
  final List<int> excludedIds;

  const StartItemSelection({
    required this.previouslySelectedId,
    this.excludedIds = const [],
  });

  @override
  List<Object?> get props => [
        previouslySelectedId,
        excludedIds,
      ];

  @override
  String toString() {
    return 'StartItemSelection{'
        'previouslySelectedId: $previouslySelectedId, '
        'excludedIds: $excludedIds}';
  }
}

class SelectSingleItem extends ItemsSelectionEvent {
  final int id;

  const SelectSingleItem({
    required this.id,
  });

  @override
  List<Object?> get props => [
        id,
      ];

  @override
  String toString() {
    return 'SelectSingleItem{id: $id}';
  }
}
