import 'package:convertouch/domain/constants/constants.dart';
import 'package:equatable/equatable.dart';

class ConvertouchAppEvent extends Equatable {
  final BottomNavbarItem activeNavbarItem;
  final List<int> selectedItemIdsForRemoval;
  final ConvertouchUITheme theme;

  const ConvertouchAppEvent({
    required this.activeNavbarItem,
    this.selectedItemIdsForRemoval = const [],
    this.theme = ConvertouchUITheme.light,
  });

  @override
  List<Object?> get props => [
    activeNavbarItem,
        selectedItemIdsForRemoval,
        theme,
      ];

  @override
  String toString() {
    return 'ConvertouchAppEvent{'
        'activeNavbarItem: $activeNavbarItem, '
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
