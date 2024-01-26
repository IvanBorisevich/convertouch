import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

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

class MenuItemsViewErrorState extends ConvertouchErrorState
    implements MenuItemsViewState {
  const MenuItemsViewErrorState({
    required super.exception,
    required super.lastSuccessfulState,
  });

  @override
  String toString() {
    return 'MenuItemsViewErrorState{'
        'exception: $exception}';
  }
}



