import 'package:convertouch/model/menu_view.dart';
import 'package:convertouch/presenter/events/menu_view_event.dart';
import 'package:convertouch/presenter/states/menu_view_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuViewBloc extends Bloc<MenuViewEvent, MenuViewModeState> {
  MenuViewBloc()
      : super(const MenuViewModeState(menuViewMode: MenuView.grid));

  @override
  Stream<MenuViewModeState> mapEventToState(
      MenuViewEvent event) async* {
    yield MenuViewModeState(menuViewMode: event.menuViewMode);
  }
}
