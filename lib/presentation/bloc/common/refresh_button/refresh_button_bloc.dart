import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/common/refresh_button/refresh_button_events.dart';
import 'package:convertouch/presentation/bloc/common/refresh_button/refresh_button_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshButtonBloc
    extends ConvertouchBloc<RefreshButtonEvent, RefreshButtonState> {
  RefreshButtonBloc() : super(const RefreshButtonState(unitGroupId: -1)) {
    on<ShowRefreshButton>(_onShowRefreshButton);
    on<HideRefreshButton>(_onHideRefreshButton);
  }

  _onShowRefreshButton(
    ShowRefreshButton event,
    Emitter<RefreshButtonState> emit,
  ) async {
    emit(
      RefreshButtonState(
        unitGroupId: event.unitGroupId,
        visible: true,
        disabled: event.disabled,
      ),
    );
  }

  _onHideRefreshButton(
    HideRefreshButton event,
    Emitter<RefreshButtonState> emit,
  ) async {
    emit(
      RefreshButtonState(
        unitGroupId: event.unitGroupId,
        visible: false,
        disabled: false,
      ),
    );
  }
}
