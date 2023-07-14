import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/states/base_state.dart';

class ItemsMenuViewState extends ConvertouchBlocState {
  const ItemsMenuViewState({
    required this.pageViewMode,
    required this.iconViewMode,
  });

  final ItemsMenuViewMode pageViewMode;
  final ItemsMenuViewMode iconViewMode;

  @override
  List<Object> get props => [
    pageViewMode, iconViewMode
  ];

  @override
  String toString() {
    return 'ItemsMenuViewState{'
        'pageViewMode: $pageViewMode, '
        'iconViewMode: $iconViewMode}';
  }
}