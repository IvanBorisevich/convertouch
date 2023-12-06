import 'package:convertouch/domain/usecases/units/add_unit_use_case.dart';
import 'package:convertouch/domain/usecases/units/get_base_unit_use_case.dart';
import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_events.dart';
import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitCreationBloc extends Bloc<UnitCreationEvent, UnitCreationState> {
  static const String _firstUnitNote = "It's a first unit being added. "
      "Its coefficient will be set as 1 by default.";

  final GetDefaultBaseUnitUseCase getDefaultBaseUnitUseCase;
  final AddUnitUseCase addUnitUseCase;

  UnitCreationBloc({
    required this.getDefaultBaseUnitUseCase,
    required this.addUnitUseCase,
  }) : super(const UnitCreationPrepared(
          unitGroup: null,
          baseUnit: null,
        ));

  @override
  Stream<UnitCreationState> mapEventToState(UnitCreationEvent event) async* {
    if (event is PrepareUnitCreation) {
      yield const UnitCreationPreparing();

      if (event.unitGroup != null) {
        final result =
            await getDefaultBaseUnitUseCase.execute(event.unitGroup!.id!);

        yield result.fold(
          (error) => UnitCreationErrorState(
            message: error.message,
          ),
          (defaultBaseUnit) {
            var baseUnit = event.baseUnit ?? defaultBaseUnit;

            return UnitCreationPrepared(
              baseUnit: baseUnit,
              unitGroup: event.unitGroup,
              comment: baseUnit == null ? _firstUnitNote : null,
            );
          },
        );
      } else {
        yield const UnitCreationPrepared(
          unitGroup: null,
          baseUnit: null,
        );
      }
    }
  }
}
