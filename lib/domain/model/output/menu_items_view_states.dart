import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/output/abstract_state.dart';

abstract class MenuItemsViewState extends ConvertouchState {
  const MenuItemsViewState();
}

class MenuItemsViewStateSetting extends MenuItemsViewState {
  const MenuItemsViewStateSetting();

  @override
  String toString() {
    return 'MenuItemsViewStateSetting{}';
  }
}

class MenuItemsViewStateSet extends MenuItemsViewState {
  final ItemsViewMode pageViewMode;
  final ItemsViewMode iconViewMode;

  const MenuItemsViewStateSet({
    required this.pageViewMode,
    required this.iconViewMode,
  });

  @override
  List<Object?> get props => [
    pageViewMode,
    iconViewMode,
  ];

  @override
  String toString() {
    return 'MenuItemsViewStateSet{'
        'pageViewMode: $pageViewMode, '
        'iconViewMode: $iconViewMode}';
  }
}

class MenuItemsViewErrorState extends MenuItemsViewState {
  final String message;

  const MenuItemsViewErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'MenuItemsViewErrorState{message: $message}';
  }
}



