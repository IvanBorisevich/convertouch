import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

class ShowGroup extends ConvertouchEvent {
  final UnitGroupModel unitGroup;

  const ShowGroup({
    required this.unitGroup,
  });

  @override
  List<Object?> get props => [
        unitGroup,
      ];

  @override
  String toString() {
    return 'ShowSingleGroup{unitGroup: $unitGroup}';
  }
}

class SingleGroupState extends ConvertouchState {
  final UnitGroupModel unitGroup;

  const SingleGroupState({
    this.unitGroup = UnitGroupModel.none,
  });

  @override
  List<Object?> get props => [
        unitGroup,
      ];

  @override
  String toString() {
    return 'SingleGroupState{unitGroup: $unitGroup}';
  }
}

class SingleGroupBloc
    extends ConvertouchBloc<ConvertouchEvent, SingleGroupState> {
  SingleGroupBloc() : super(const SingleGroupState()) {
    on<ShowGroup>((event, emit) {
      emit(
        SingleGroupState(unitGroup: event.unitGroup),
      );
    });
  }
}
