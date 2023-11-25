import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:equatable/equatable.dart';

abstract class ConvertouchPageEvent extends Equatable {
  final String currentPageId;
  final Type? currentState;
  final int startPageIndex;
  final UnitGroupModel? unitGroupInConversion;
  final List<int> selectedItemIdsForRemoval;
  final ItemsViewMode? targetViewMode;
  final ConvertouchUITheme theme;

  const ConvertouchPageEvent({
    required this.currentPageId,
    this.currentState,
    required this.startPageIndex,
    this.unitGroupInConversion,
    this.selectedItemIdsForRemoval = const [],
    this.targetViewMode,
    this.theme = ConvertouchUITheme.light,
  });

  @override
  List<Object?> get props => [
        currentPageId,
        currentState,
        startPageIndex,
        unitGroupInConversion,
        selectedItemIdsForRemoval,
        targetViewMode,
        theme,
      ];

  @override
  String toString() {
    return 'ConvertouchPageEvent{'
        'currentPageId: $currentPageId, '
        'currentState: $currentState, '
        'startPageIndex: $startPageIndex, '
        'unitGroupInConversion: $unitGroupInConversion, '
        'selectedItemIdsForRemoval: $selectedItemIdsForRemoval, '
        'targetViewMode: $targetViewMode, '
        'theme: $theme'
        '}';
  }
}

class ChangeMenuItemsViewMode extends ConvertouchPageEvent {
  const ChangeMenuItemsViewMode({
    required super.currentPageId,
    required super.startPageIndex,
    required super.targetViewMode,
  });

  @override
  String toString() {
    return 'ChangeMenuItemsViewMode{${super.toString()}}';
  }
}

class SelectMenuItemForRemoval extends ConvertouchPageEvent {
  final IdNameItemModel item;

  const SelectMenuItemForRemoval({
    required this.item,
    required super.currentPageId,
    required super.startPageIndex,
  });

  @override
  List<Object?> get props => [
        item,
        super.props,
      ];

  @override
  String toString() {
    return 'SelectMenuItemForRemoval{'
        'item: $item, '
        '${super.toString()}}';
  }
}

class DisableRemovalMode extends ConvertouchPageEvent {
  const DisableRemovalMode({
    required super.currentPageId,
    required super.startPageIndex,
  });

  @override
  String toString() {
    return 'DisableRemovalMode{}';
  }
}
