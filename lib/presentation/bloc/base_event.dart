import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:equatable/equatable.dart';

class ConvertouchCommonEvent extends Equatable {
  final String currentPageId;
  final int startPageIndex;
  final Type? currentState;
  final List<int> selectedItemIdsForRemoval;
  final ConvertouchUITheme theme;

  const ConvertouchCommonEvent({
    required this.currentPageId,
    this.currentState,
    required this.startPageIndex,
    this.selectedItemIdsForRemoval = const [],
    this.theme = ConvertouchUITheme.light,
  });

  @override
  List<Object?> get props => [
        currentPageId,
        currentState,
        startPageIndex,
        selectedItemIdsForRemoval,
        theme,
      ];

  @override
  String toString() {
    return 'ConvertouchCommonEvent{'
        'currentPageId: $currentPageId, '
        'currentState: $currentState, '
        'startPageIndex: $startPageIndex, '
        'selectedItemIdsForRemoval: $selectedItemIdsForRemoval, '
        'theme: $theme'
        '}';
  }
}

// class ChangeMenuItemsViewMode extends ConvertouchCommonEvent {
//   const ChangeMenuItemsViewMode({
//     required super.currentPageId,
//     required super.startPageIndex,
//     required super.targetViewMode,
//   });
//
//   @override
//   String toString() {
//     return 'ChangeMenuItemsViewMode{${super.toString()}}';
//   }
// }
//
// class SelectMenuItemForRemoval extends ConvertouchCommonEvent {
//   final IdNameItemModel item;
//
//   const SelectMenuItemForRemoval({
//     required this.item,
//     required super.currentPageId,
//     required super.startPageIndex,
//     super.selectedItemIdsForRemoval,
//   });
//
//   @override
//   List<Object?> get props => [
//         item,
//         super.props,
//       ];
//
//   @override
//   String toString() {
//     return 'SelectMenuItemForRemoval{'
//         'item: $item, '
//         '${super.toString()}}';
//   }
// }
//
// class DisableRemovalMode extends ConvertouchCommonEvent {
//   const DisableRemovalMode({
//     required super.currentPageId,
//     required super.startPageIndex,
//   });
//
//   @override
//   String toString() {
//     return 'DisableRemovalMode{}';
//   }
// }
