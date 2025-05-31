import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/unit_groups/fetch_unit_groups_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/remove_unit_groups_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_groups/save_unit_group_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_states.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:either_dart/either.dart';

class UnitGroupsBloc extends ItemsListBloc<UnitGroupModel,
    ItemsFetched<UnitGroupModel>, UnitGroupsFetchParams> {
  final FetchUnitGroupsUseCase fetchUnitGroupsUseCase;
  final SaveUnitGroupUseCase saveUnitGroupUseCase;
  final RemoveUnitGroupsUseCase removeUnitGroupsUseCase;
  final NavigationBloc navigationBloc;

  UnitGroupsBloc({
    required this.fetchUnitGroupsUseCase,
    required this.saveUnitGroupUseCase,
    required this.removeUnitGroupsUseCase,
    required this.navigationBloc,
  });

  @override
  Future<Either<ConvertouchException, List<UnitGroupModel>>> fetchItems(
    InputItemsFetchModel<UnitGroupsFetchParams> input,
  ) async {
    return await fetchUnitGroupsUseCase.execute(input);
  }

  @override
  Future<Either<ConvertouchException, UnitGroupModel>> saveItem(
    UnitGroupModel item,
  ) async {
    return await saveUnitGroupUseCase.execute(item);
  }

  @override
  Future<Either<ConvertouchException, void>> removeItems(
    List<int> ids,
  ) async {
    return await removeUnitGroupsUseCase.execute(ids);
  }

  @override
  UnitGroupModel addSearchMatch(UnitGroupModel item, String searchString) {
    return item.copyWith(
      nameMatch: ObjectUtils.toSearchMatch(item.name, searchString),
    );
  }

  @override
  UnitGroupsFetchParams? getFetchParams(FetchItems event) {
    return null;
  }
}

class UnitGroupsBlocForUnitDetails extends UnitGroupsBloc {
  UnitGroupsBlocForUnitDetails({
    required super.fetchUnitGroupsUseCase,
    required super.saveUnitGroupUseCase,
    required super.removeUnitGroupsUseCase,
    required super.navigationBloc,
  });
}
