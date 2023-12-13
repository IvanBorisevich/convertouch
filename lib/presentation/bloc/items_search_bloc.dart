import 'package:convertouch/domain/model/input/items_search_events.dart';
import 'package:convertouch/domain/model/output/items_search_states.dart';
import 'package:convertouch/domain/usecases/unit_groups/search_unit_groups_use_case.dart';
import 'package:convertouch/domain/usecases/units/search_units_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsSearchBloc extends Bloc<ItemsSearchEvent, ItemsSearchState> {
  ItemsSearchBloc() : super(const ItemsSearchInitState()) {
    on<ResetSearch>((event, emit) => emit(const ItemsSearchInitState()));
  }
}

class UnitGroupsSearchBloc extends ItemsSearchBloc {
  final SearchUnitGroupsUseCase searchUnitGroupsUseCase;

  UnitGroupsSearchBloc({
    required this.searchUnitGroupsUseCase,
  }) : super() {
    on<SearchUnitGroups>(_onSearchUnitGroups);
  }

  _onSearchUnitGroups(
    SearchUnitGroups event,
    Emitter<ItemsSearchState> emit,
  ) async {
    final result = await searchUnitGroupsUseCase.execute(event);

    emit(result.fold(
      (error) => ItemsSearchErrorState(message: error.message),
      (foundUnitGroups) => UnitGroupsFound(foundItems: foundUnitGroups),
    ));
  }
}

class UnitGroupsSearchBlocForConversion extends UnitGroupsSearchBloc {
  UnitGroupsSearchBlocForConversion({
    required super.searchUnitGroupsUseCase,
  }) : super();
}

class UnitGroupsSearchBlocForUnitCreation extends UnitGroupsSearchBloc {
  UnitGroupsSearchBlocForUnitCreation({
    required super.searchUnitGroupsUseCase,
  }) : super();
}

class UnitsSearchBloc extends ItemsSearchBloc {
  final SearchUnitsUseCase searchUnitsUseCase;

  UnitsSearchBloc({
    required this.searchUnitsUseCase,
  }) : super() {
    on<SearchUnits>(_onSearchUnits);
  }

  _onSearchUnits(
      SearchUnits event,
      Emitter<ItemsSearchState> emit,
      ) async {
    final result = await searchUnitsUseCase.execute(event);

    emit(result.fold(
          (error) => ItemsSearchErrorState(message: error.message),
          (foundUnits) => UnitsFound(foundItems: foundUnits),
    ));
  }
}

class UnitsSearchBlocForConversion extends UnitsSearchBloc {
  UnitsSearchBlocForConversion({
    required super.searchUnitsUseCase,
  }) : super();
}

class UnitsSearchBlocForUnitCreation extends UnitsSearchBloc {
  UnitsSearchBlocForUnitCreation({
    required super.searchUnitsUseCase,
  }) : super();
}
