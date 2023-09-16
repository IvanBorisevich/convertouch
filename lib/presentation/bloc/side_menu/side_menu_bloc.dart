import 'package:convertouch/presentation/bloc/side_menu/side_menu_events.dart';
import 'package:convertouch/presentation/bloc/side_menu/side_menu_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideMenuBloc extends Bloc<SideMenuEvent, SideMenuState> {
  SideMenuBloc() : super(const SideMenuClosed());

  @override
  Stream<SideMenuState> mapEventToState(SideMenuEvent event) async* {
    if (event is OpenSideMenu) {
      yield const SideMenuOpened();
    } else if (event is CloseSideMenu) {
      yield const SideMenuClosed();
    }
  }
}
