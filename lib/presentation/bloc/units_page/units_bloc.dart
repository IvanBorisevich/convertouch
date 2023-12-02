import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/usecases/unit_groups/get_unit_group_use_case.dart';
import 'package:convertouch/domain/usecases/units/fetch_units_of_group_use_case.dart';
import 'package:convertouch/domain/usecases/units/remove_units_use_case.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsBloc extends Bloc<UnitsEvent, UnitsState> {
  static const int _minUnitsNumForConversion = 2;

  final GetUnitGroupUseCase getUnitGroupUseCase;
  final FetchUnitsOfGroupUseCase fetchUnitsOfGroupUseCase;
  final RemoveUnitsUseCase removeUnitsUseCase;

  UnitsBloc({
    required this.getUnitGroupUseCase,
    required this.fetchUnitsOfGroupUseCase,
    required this.removeUnitsUseCase,
  }) : super(const UnitsFetched());

  @override
  Stream<UnitsState> mapEventToState(UnitsEvent event) async* {
    yield const UnitsFetching();

    if (event is FetchUnits) {
      final fetchUnitsOfGroupResult = await fetchUnitsOfGroupUseCase.execute(
        event.unitGroup.id!,
      );

      if (fetchUnitsOfGroupResult.isLeft) {
        yield UnitsErrorState(message: fetchUnitsOfGroupResult.left.message);
      } else {
        switch (event.runtimeType) {
          case FetchUnitsForConversion:
            var e = event as FetchUnitsForConversion;

            List<int> allMarkedUnitIds = _updateMarkedUnitIds(
              e.unitIdsAlreadyMarkedForConversion,
              e.unitIdNewlyMarkedForConversion,
            );

            List<UnitModel> allMarkedUnits = fetchUnitsOfGroupResult.right
                .where((unit) => allMarkedUnitIds.contains(unit.id))
                .toList();

            yield UnitsFetchedForConversion(
              units: fetchUnitsOfGroupResult.right,
              unitGroup: event.unitGroup,
              unitIdsMarkedForConversion: allMarkedUnitIds,
              unitsMarkedForConversion: allMarkedUnits,
              allowUnitsToBeAddedToConversion:
                  allMarkedUnitIds.length >= _minUnitsNumForConversion,
            );
            break;
          case FetchUnitsForEquivalentUnitSelection:
            yield UnitsFetchedForEquivalentUnitSelection(
              units: fetchUnitsOfGroupResult.right,
              unitGroup: event.unitGroup,
            );
            break;
          default:
            yield UnitsFetched(
              units: fetchUnitsOfGroupResult.right,
              unitGroup: event.unitGroup,
            );
            break;
        }
      }
    } else if (event is RemoveUnits) {
      // final result = await removeUnitsUseCase.execute(event.ids);
      // if (result.isLeft) {
      //   yield UnitsErrorState(
      //     message: result.left.message,
      //   );
      // } else {
      //   final fetchUnitGroupsResult = await fetchUnitsOfGroupUseCase.execute(
      //     event.unitGroup.id!,
      //   );
      //
      //   List<UnitModel>? markedUnits = event.markedUnits;
      //   if (markedUnits != null) {
      //     markedUnits.removeWhere((element) => event.ids.contains(element.id));
      //   }
      //
      //   yield fetchUnitGroupsResult.fold(
      //     (error) => UnitsErrorState(
      //       message: error.message,
      //     ),
      //     (units) => UnitsFetched(
      //       units: units,
      //       unitGroup: event.unitGroup,
      //       needToNavigate: false,
      //       markedUnits: markedUnits ?? [],
      //     ),
      //   );
      // }
    }
  }

  List<int> _updateMarkedUnitIds(
    List<int>? unitIdsAlreadyMarkedForConversion,
    int? unitIdNewlyMarkedForConversion,
  ) {
    List<int> result = unitIdsAlreadyMarkedForConversion ?? [];

    if (unitIdNewlyMarkedForConversion == null) {
      return result;
    }

    if (!result.contains(unitIdNewlyMarkedForConversion)) {
      result.add(unitIdNewlyMarkedForConversion);
    } else {
      result.removeWhere(
        (unit) => unit == unitIdNewlyMarkedForConversion,
      );
    }

    return result;
  }
}
