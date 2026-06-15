import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class RootScreenEvent extends ConvertouchEvent {
  const RootScreenEvent();
}

class SelectBottomNavbarItem extends RootScreenEvent {
  final BottomNavbarItem targetItem;
  final BottomNavbarItem selectedItem;

  const SelectBottomNavbarItem({
    required this.targetItem,
    required this.selectedItem,
  });

  @override
  List<Object?> get props => [
    targetItem,
    selectedItem,
  ];

  @override
  String toString() {
    return 'SelectBottomNavbarItem{'
        'targetItem: $targetItem, '
        'selectedItem: $selectedItem}';
  }
}