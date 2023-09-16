import 'package:convertouch/presentation/bloc/base_event.dart';

abstract class SideMenuEvent extends ConvertouchEvent {
  const SideMenuEvent();
}

class OpenSideMenu extends SideMenuEvent {
  const OpenSideMenu();

  @override
  String toString() {
    return 'OpenSideMenu{}';
  }
}

class CloseSideMenu extends SideMenuEvent {
  const CloseSideMenu();

  @override
  String toString() {
    return 'CloseSideMenu{}';
  }
}
