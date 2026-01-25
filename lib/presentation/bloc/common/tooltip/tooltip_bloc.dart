import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/common/tooltip/tooltip_events.dart';
import 'package:convertouch/presentation/bloc/common/tooltip/tooltip_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchTooltipBloc
    extends ConvertouchBloc<ConvertouchTooltipEvent, ConvertouchTooltipState> {
  ConvertouchTooltipBloc() : super(const TooltipHidden()) {
    on<ShowTooltip>(_onShowTooltip);
    on<HideTooltip>(_onHideTooltip);
  }

  _onShowTooltip(
    ShowTooltip event,
    Emitter<ConvertouchTooltipState> emit,
  ) async {
    emit(const TooltipVisible());
  }

  _onHideTooltip(
    HideTooltip event,
    Emitter<ConvertouchTooltipState> emit,
  ) async {
    emit(const TooltipHidden());
  }
}
