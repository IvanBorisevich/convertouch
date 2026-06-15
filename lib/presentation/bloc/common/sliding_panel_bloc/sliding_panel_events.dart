import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class SlidingPanelEvent extends ConvertouchEvent {
  const SlidingPanelEvent();
}

class SwitchSlidingPanel extends SlidingPanelEvent {
  const SwitchSlidingPanel();

  @override
  String toString() {
    return 'SwitchSlidingPanel{}';
  }
}
