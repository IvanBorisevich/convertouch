import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';

abstract class ItemsViewModeState extends ConvertouchBlocState {
  const ItemsViewModeState();
}

class ItemsViewModeChanged extends ItemsViewModeState {
  const ItemsViewModeChanged({
    required this.pageViewMode,
    required this.iconViewMode,
  });

  final ItemsViewMode pageViewMode;
  final ItemsViewMode iconViewMode;

  @override
  List<Object> get props => [
    pageViewMode, iconViewMode
  ];

  @override
  String toString() {
    return 'ItemsViewModeChanged{'
        'pageViewMode: $pageViewMode, '
        'iconViewMode: $iconViewMode}';
  }
}

class ItemsViewModeInitState extends ItemsViewModeChanged {
  const ItemsViewModeInitState() : super(
    pageViewMode: ItemsViewMode.grid,
    iconViewMode: ItemsViewMode.list,
  );
}

class ItemsViewModeErrorState extends ItemsViewModeState {
  final String message;

  const ItemsViewModeErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'ItemsViewModeErrorState{message: $message}';
  }
}