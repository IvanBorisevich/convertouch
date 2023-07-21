import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/states/base_state.dart';

class ItemsViewModeState extends ConvertouchBlocState {
  const ItemsViewModeState({
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
    return 'ItemsViewState{'
        'pageViewMode: $pageViewMode, '
        'iconViewMode: $iconViewMode}';
  }
}