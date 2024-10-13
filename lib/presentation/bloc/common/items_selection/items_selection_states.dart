import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class ItemsSelectionState extends ConvertouchState {
  const ItemsSelectionState();
}

class ItemsSelectionDone extends ItemsSelectionState {
  final List<int> markedIds;
  final bool canMarkedItemsBeSelected;
  final int markedItemsMinNumForSelection;
  final int? selectedId;
  final bool singleItemSelectionMode;
  final List<int> excludedIds;
  final bool showCancelIcon;

  const ItemsSelectionDone({
    this.markedIds = const [],
    this.canMarkedItemsBeSelected = false,
    this.markedItemsMinNumForSelection = 1,
    this.selectedId,
    this.singleItemSelectionMode = true,
    this.excludedIds = const [],
    this.showCancelIcon = false,
  });

  @override
  List<Object?> get props => [
        markedIds,
        canMarkedItemsBeSelected,
        markedItemsMinNumForSelection,
        selectedId,
        singleItemSelectionMode,
        excludedIds,
        showCancelIcon,
      ];

  @override
  String toString() {
    return 'ItemSelectionDone{'
        'markedIds: $markedIds, '
        'markedItemsMinNumForSelection: $markedItemsMinNumForSelection, '
        'canMarkedItemsBeSelected: $canMarkedItemsBeSelected, '
        'selectedId: $selectedId, '
        'singleItemSelectionMode: $singleItemSelectionMode, '
        'excludedIds: $excludedIds, '
        'showCancelIcon: $showCancelIcon}';
  }
}
