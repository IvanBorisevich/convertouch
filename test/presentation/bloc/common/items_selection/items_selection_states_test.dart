import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_states.dart';
import 'package:test/test.dart';

void main() {
  ItemsSelectionDone state1 = const ItemsSelectionDone(
    markedIds: [210, 213],
    markedItemsMinNumForSelection: 2,
    canMarkedItemsBeSelected: true,
    selectedId: null,
    singleItemSelectionMode: false,
    excludedIds: [],
    showCancelIcon: false,
  );

  ItemsSelectionDone state2 = const ItemsSelectionDone(
    markedIds: [210, 213, 215],
    markedItemsMinNumForSelection: 2,
    canMarkedItemsBeSelected: true,
    selectedId: null,
    singleItemSelectionMode: false,
    excludedIds: [],
    showCancelIcon: false,
  );

  test('Selection states are different when marked ids are different', () {
    expect(state1 == state2, false);
  });
}
