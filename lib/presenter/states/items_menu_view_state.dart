import 'package:convertouch/model/util/menu_page_util.dart';
import 'package:convertouch/presenter/states/base_state.dart';

class ItemsMenuViewState extends ConvertouchBlocState {
  const ItemsMenuViewState({
    required this.viewMode,
  });

  final ItemsMenuViewMode viewMode;

  @override
  List<Object> get props => [
    viewMode
  ];

  @override
  String toString() {
    return 'ItemsMenuViewState{viewMode: $viewMode}';
  }
}