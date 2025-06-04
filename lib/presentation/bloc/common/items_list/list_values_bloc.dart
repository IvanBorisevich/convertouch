import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/common/select_list_value_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:either_dart/either.dart';

class ListValuesBloc
    extends ItemsListBloc<ListValueModel, ListValuesFetchParams> {
  final FetchListValuesUseCase fetchListValuesUseCase;
  final SelectListValueUseCase selectListValueUseCase;

  ListValuesBloc({
    required this.fetchListValuesUseCase,
    required this.selectListValueUseCase,
  });

  @override
  Future<Either<ConvertouchException, OutputListValuesBatch>> fetchBatch(
    InputItemsFetchModel<ListValuesFetchParams> input,
  ) async {
    return await fetchListValuesUseCase.execute(input);
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
