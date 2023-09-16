import 'package:convertouch/presentation/bloc/base_state.dart';

abstract class SideMenuState extends ConvertouchBlocState {
  const SideMenuState();
}

class SideMenuToggling extends SideMenuState {
  const SideMenuToggling();

  @override
  String toString() {
    return 'SideMenuToggling{}';
  }
}

class SideMenuOpened extends SideMenuState {
  const SideMenuOpened();

  @override
  String toString() {
    return 'SideMenuOpened{}';
  }
}

class SideMenuClosed extends SideMenuState {
  const SideMenuClosed();

  @override
  String toString() {
    return 'SideMenuClosed{}';
  }
}
