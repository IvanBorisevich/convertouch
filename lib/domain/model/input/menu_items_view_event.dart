import 'package:convertouch/domain/constants/constants.dart';
import 'package:equatable/equatable.dart';

abstract class MenuItemsViewEvent extends Equatable {
  const MenuItemsViewEvent();

  @override
  List<Object?> get props => [];
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