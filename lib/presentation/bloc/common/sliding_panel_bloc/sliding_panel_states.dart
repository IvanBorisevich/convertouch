import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class SlidingPanelState extends ConvertouchState {
  const SlidingPanelState();
}

class SlidingPanelSwitchInProgress extends SlidingPanelState {
  const SlidingPanelSwitchInProgress();

  @override
  String toString() {
    return 'SlidingPanelSwitchInProgress{}';
  }
}

class SlidingPanelSwitched extends SlidingPanelState {
  const SlidingPanelSwitched();

  @override
  String toString() {
    return 'SlidingPanelSwitched{}';
  }
}
