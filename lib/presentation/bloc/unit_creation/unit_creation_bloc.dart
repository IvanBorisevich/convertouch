import 'package:convertouch/domain/usecases/units/get_base_unit_use_case.dart';
import 'package:convertouch/presentation/bloc/unit_creation/unit_creation_events.dart';
import 'package:convertouch/presentation/bloc/unit_creation/unit_creation_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitCreationBloc extends Bloc<UnitCreationEvent, UnitCreationState> {
  final GetBaseUnitUseCase getBaseUnitUseCase;

  UnitCreationBloc({
    required this.getBaseUnitUseCase,
  }) : super(const UnitCreationInitState());

  @override
  Stream<UnitCreationState> mapEventToState(UnitCreationEvent event) async* {
    if (event is PrepareUnitCreation) {
      yield const UnitCreationPreparing();

      final getBaseUnitResult =
          await getBaseUnitUseCase.execute(event.unitGroup.id!);

      yield getBaseUnitResult.fold(
        (error) => UnitCreationErrorState(
          message: error.message,
        ),
        (baseUnit) => UnitCreationPrepared(
          unitGroup: event.unitGroup,
          equivalentUnit: event.equivalentUnit ?? baseUnit,
          markedUnits: event.markedUnits,
          action: event.action,
        ),
      );
    }
  }
}
