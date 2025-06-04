import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/units/fetch_units_use_case.dart';
import 'package:convertouch/domain/use_cases/units/remove_units_use_case.dart';
import 'package:convertouch/domain/use_cases/units/save_unit_use_case.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:either_dart/either.dart';

typedef OutputUnitsFetch = OutputItemsFetchModel<UnitModel, UnitsFetchParams>;

class UnitsBloc extends ItemsListBloc<UnitModel, UnitsFetchParams> {
  final FetchUnitsUseCase fetchUnitsUseCase;
  final SaveUnitUseCase saveUnitUseCase;
  final RemoveUnitsUseCase removeUnitsUseCase;
  final NavigationBloc navigationBloc;

  UnitsBloc({
    required this.saveUnitUseCase,
    required this.fetchUnitsUseCase,
    required this.removeUnitsUseCase,
    required this.navigationBloc,
  });

  @override
  Future<Either<ConvertouchException, OutputUnitsFetch>> fetchBatch(
    InputItemsFetchModel<UnitsFetchParams> input,
  ) async {
    return await fetchUnitsUseCase.execute(input);
  }

  @override
  Future<Either<ConvertouchException, UnitModel>> saveItem(
    UnitModel item,
  ) async {
    return await saveUnitUseCase.execute(item);
  }

  @override
  Future<Either<ConvertouchException, void>> removeItems(List<int> ids) async {
    return await removeUnitsUseCase.execute(ids);
  }
}

class UnitsBlocForUnitDetails extends UnitsBloc {
  UnitsBlocForUnitDetails({
    required super.fetchUnitsUseCase,
    required super.saveUnitUseCase,
    required super.removeUnitsUseCase,
    required super.navigationBloc,
  });
}
