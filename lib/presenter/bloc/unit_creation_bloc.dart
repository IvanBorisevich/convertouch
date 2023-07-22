import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/bloc/units_bloc.dart';
import 'package:convertouch/presenter/events/unit_creation_events.dart';
import 'package:convertouch/presenter/states/unit_creation_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitCreationBloc extends Bloc<UnitCreationEvent, UnitCreationState> {
  UnitCreationBloc() : super(const UnitCreationInitState());

  @override
  Stream<UnitCreationState> mapEventToState(UnitCreationEvent event) async* {
    if (event is PrepareUnitCreation) {
      yield const UnitCreationPreparing();
      UnitModel? unitEquivalent = event.unitForEquivalent ?? allUnits[0];
      yield UnitCreationPrepared(
        unitGroup: event.unitGroup,
        equivalentUnit: unitEquivalent,
        initial: event.initial,
      );
    }
  }
}