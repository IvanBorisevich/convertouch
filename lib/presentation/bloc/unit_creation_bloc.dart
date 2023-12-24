import 'package:convertouch/domain/model/input/unit_creation_events.dart';
import 'package:convertouch/domain/model/output/unit_creation_states.dart';
import 'package:convertouch/domain/usecases/units/add_unit_use_case.dart';
import 'package:convertouch/domain/usecases/units/prepare_unit_creation_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';

class UnitCreationBloc
    extends ConvertouchBloc<UnitCreationEvent, UnitCreationState> {
  final PrepareUnitCreationUseCase prepareUnitCreationUseCase;
  final AddUnitUseCase addUnitUseCase;

  UnitCreationBloc({
    required this.prepareUnitCreationUseCase,
    required this.addUnitUseCase,
  }) : super(const UnitCreationPrepared(
          unitGroup: null,
          baseUnit: null,
        ));

  @override
  Stream<UnitCreationState> mapEventToState(UnitCreationEvent event) async* {
    if (event is PrepareUnitCreation) {
      yield const UnitCreationPreparing();

      final result = await prepareUnitCreationUseCase.execute(event);

      yield result.fold(
        (error) => UnitCreationErrorState(
          message: error.message,
        ),
        (unitCreationPrepared) => unitCreationPrepared,
      );
    }
  }
}
