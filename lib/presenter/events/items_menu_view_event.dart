import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/events/base_event.dart';

abstract class ItemsMenuViewEvent extends ConvertouchEvent {
  const ItemsMenuViewEvent();
}

class ChangeViewMode extends ItemsMenuViewEvent {
  const ChangeViewMode({
    required this.currentViewMode
  });

  final ItemsViewMode currentViewMode;

  @override
  List<Object> get props => [
    currentViewMode
  ];

  @override
  String toString() {
    return 'ChangeViewMode{currentViewMode: $currentViewMode}';
  }
}