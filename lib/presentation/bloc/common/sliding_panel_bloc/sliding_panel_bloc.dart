import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/common/sliding_panel_bloc/sliding_panel_events.dart';
import 'package:convertouch/presentation/bloc/common/sliding_panel_bloc/sliding_panel_states.dart';

class SlidingPanelBloc
    extends ConvertouchBloc<SlidingPanelEvent, SlidingPanelState> {
  SlidingPanelBloc() : super(const SlidingPanelSwitched()) {
    on<SwitchSlidingPanel>((event, emit) {
      emit(const SlidingPanelSwitchInProgress());
      emit(const SlidingPanelSwitched());
    });
  }
}
