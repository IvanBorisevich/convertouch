import 'package:convertouch/model/util/menu_util.dart';
import 'package:convertouch/presenter/events/base_event.dart';

abstract class ItemsMenuViewEvent extends ConvertouchEvent {
  const ItemsMenuViewEvent();
}

class ChangeViewMode extends ItemsMenuViewEvent {
  const ChangeViewMode({
    required this.viewMode
  });

  final ItemsMenuViewMode viewMode;

  @override
  List<Object> get props => [
    viewMode
  ];

  @override
  String toString() {
    return 'ChangeViewMode{viewMode: $viewMode}';
  }
}