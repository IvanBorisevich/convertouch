import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class MenuItemsViewEvent extends ConvertouchEvent {
  const MenuItemsViewEvent();
}

class RestoreViewModeSettings extends MenuItemsViewEvent {
  const RestoreViewModeSettings();

  @override
  String toString() {
    return 'RestoreViewModeSettings{}';
  }
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