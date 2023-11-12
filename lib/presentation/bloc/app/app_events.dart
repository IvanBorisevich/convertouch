import 'package:convertouch/presentation/bloc/base_event.dart';

abstract class AppEvent extends ConvertouchEvent {
  const AppEvent();
}

class SelectItemForRemoval extends AppEvent {
  final int itemId;
  final List<int>? currentSelectedItemIdsForRemoval;

  const SelectItemForRemoval({
    required this.itemId,
    this.currentSelectedItemIdsForRemoval,
  });

  @override
  List<Object?> get props => [
    itemId,
    currentSelectedItemIdsForRemoval,
  ];

  @override
  String toString() {
    return 'SelectItemForRemoval{'
        'itemId: $itemId, '
        'currentSelectedItemIdsForRemoval: $currentSelectedItemIdsForRemoval'
        '}';
  }
}

class DisableRemovalMode extends AppEvent {
  const DisableRemovalMode();

  @override
  String toString() {
    return 'DisableRemovalMode{}';
  }
}
