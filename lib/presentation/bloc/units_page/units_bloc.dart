import 'package:convertouch/domain/usecases/unit_groups/get_unit_group_use_case.dart';
import 'package:convertouch/domain/usecases/units/add_unit_use_case.dart';
import 'package:convertouch/domain/usecases/units/fetch_units_of_group_use_case.dart';
import 'package:convertouch/domain/usecases/units/model/unit_adding_input.dart';
import 'package:convertouch/domain/usecases/units/remove_units_use_case.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsBloc extends Bloc<UnitsEvent, UnitsState> {
  final GetUnitGroupUseCase getUnitGroupUseCase;
  final AddUnitUseCase addUnitUseCase;
  final FetchUnitsOfGroupUseCase fetchUnitsOfGroupUseCase;
  final RemoveUnitsUseCase removeUnitsUseCase;

  UnitsBloc({
    required this.getUnitGroupUseCase,
    required this.addUnitUseCase,
    required this.fetchUnitsOfGroupUseCase,
    required this.removeUnitsUseCase,
  }) : super(const UnitsFetched(unitGroup: null));

  @override
  Stream<UnitsState> mapEventToState(UnitsEvent event) async* {
    yield const UnitsFetching();

    if (event is FetchUnits) {
      var unitGroup = event.unitGroup;

      final result = await fetchUnitsOfGroupUseCase.execute(unitGroup.id!);

      if (result.isLeft) {
        yield UnitsErrorState(
          message: result.left.message,
        );
      } else {
        yield UnitsFetched(
          units: result.right,
          unitGroup: unitGroup,
        );
      }
    } else if (event is AddUnit) {
      yield const UnitsFetching();

      UnitAddingInput input = UnitAddingInput(
        newUnit: event.newUnit,
        newUnitValue: double.tryParse(event.newUnitValue ?? ""),
        baseUnit: event.baseUnit,
        baseUnitValue: double.tryParse(event.baseUnitValue ?? ""),
      );

      final addUnitResult = await addUnitUseCase.execute(input);

      if (addUnitResult.isLeft) {
        yield UnitsErrorState(
          message: addUnitResult.left.message,
        );
      } else {
        int addedUnitId = addUnitResult.right;
        if (addedUnitId == -1) {
          yield UnitExists(
            unitName: event.newUnit.name,
          );
        } else {
          yield const UnitsFetching();

          final fetchUnitsOfGroupResult =
              await fetchUnitsOfGroupUseCase.execute(event.unitGroup.id!);
          yield fetchUnitsOfGroupResult.fold(
            (error) => UnitsErrorState(
              message: error.message,
            ),
            (unitsOfGroup) => UnitsFetched(
              units: unitsOfGroup,
              unitGroup: event.unitGroup,
            ),
          );
        }
      }
    } else if (event is RemoveUnits) {
      final result = await removeUnitsUseCase.execute(event.ids);
      if (result.isLeft) {
        yield UnitsErrorState(
          message: result.left.message,
        );
      } else {
        add(FetchUnits(unitGroup: event.unitGroup));
      }
    }
  }
}
