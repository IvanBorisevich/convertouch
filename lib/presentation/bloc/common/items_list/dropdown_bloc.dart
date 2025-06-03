import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/common/get_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/common/select_list_value_use_case.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:either_dart/either.dart';

class DropdownBloc
    extends ItemsListBloc<ListValueModel, DropdownItemsFetchParams> {
  final GetListValuesUseCase getListValuesUseCase;
  final SelectListValueUseCase selectListValueUseCase;

  DropdownBloc({
    required this.getListValuesUseCase,
    required this.selectListValueUseCase,
  });

  @override
  ListValueModel addSearchMatch(ListValueModel item, String searchString) {
    return item;
  }

  @override
  Future<Either<ConvertouchException, List<ListValueModel>>> fetchItemsPage(
    InputItemsFetchModel<DropdownItemsFetchParams> input,
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
