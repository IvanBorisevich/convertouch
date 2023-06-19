import 'package:convertouch/model/menu_view.dart';
import 'package:convertouch/presenter/states/base_state.dart';

class MenuViewModeState extends BlocState {
  const MenuViewModeState({
    required this.menuViewMode
  });

  final MenuView menuViewMode;

  @override
  List<Object> get props => [
    menuViewMode
  ];

  @override
  String toString() {
    return 'MenuViewModeState {'
        'menuViewMode: $menuViewMode}';
  }
}