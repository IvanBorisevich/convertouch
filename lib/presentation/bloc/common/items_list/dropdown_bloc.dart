import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/common/get_list_values_use_case.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_states.dart';
import 'package:either_dart/either.dart';

class DropdownBloc
    extends ItemsListBloc<ListValueModel, ItemsFetched<ListValueModel>> {
  final GetListValuesUseCase getListValuesUseCase;

  DropdownBloc({
    required this.getListValuesUseCase,
  });

  @override
  ListValueModel addSearchMatch(ListValueModel item, String searchString) {
    return item;
  }

  @override
  Future<Either<ConvertouchException, List<ListValueModel>>> fetchItems(
    InputItemsFetchModel input,
  ) async {
    return await getListValuesUseCase.execute(input);
  }

  @override
  Future<Either<ConvertouchException, void>> removeItems(List<int> ids) async {
    return const Right(null);
  }

  @override
  Future<Either<ConvertouchException, ListValueModel>> saveItem(
    ListValueModel item,
  ) async {
    return Right(item);
  }
}
