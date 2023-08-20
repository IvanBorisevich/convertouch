import 'package:convertouch/domain/entities/unit_entity.dart';
import 'package:convertouch/presentation/bloc/units/units_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation/unit_creation_events.dart';
import 'package:convertouch/presentation/bloc/unit_creation/unit_creation_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitCreationBloc extends Bloc<UnitCreationEvent, UnitCreationState> {
  UnitCreationBloc() : super(const UnitCreationInitState());

  @override
  Stream<UnitCreationState> mapEventToState(UnitCreationEvent event) async* {
    if (event is PrepareUnitCreation) {
      yield const UnitCreationPreparing();
      UnitEntity? equivalentUnit = event.equivalentUnit ?? allUnits[0];

      yield UnitCreationPrepared(
        unitGroup: event.unitGroup,
        equivalentUnit: equivalentUnit,
        markedUnits: event.markedUnits,
        action: event.action,
      );
    }
  }
}