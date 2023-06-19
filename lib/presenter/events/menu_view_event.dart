import 'package:convertouch/model/menu_view.dart';
import 'package:convertouch/presenter/events/base_event.dart';

class MenuViewEvent extends BlocEvent {
  const MenuViewEvent({
    required this.menuViewMode
  });

  final MenuView menuViewMode;

  @override
  List<Object> get props => [
    menuViewMode
  ];

  @override
  String toString() {
    return 'MenuViewEvent {'
        'menuViewMode: $menuViewMode}';
  }
}