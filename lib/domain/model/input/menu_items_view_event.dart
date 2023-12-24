import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/input/abstract_event.dart';

abstract class MenuItemsViewEvent extends ConvertouchEvent {
  const MenuItemsViewEvent();
}

class ChangeMenuItemsView extends MenuItemsViewEvent {
  final ItemsViewMode targetViewMode;

  const ChangeMenuItemsView({
    required this.targetViewMode,
  });

  @override
  List<Object?> get props => [
    targetViewMode,
  ];

  @override
  String toString() {
    return 'ChangeMenuItemsView{targetViewMode: $targetViewMode}';
  }
}