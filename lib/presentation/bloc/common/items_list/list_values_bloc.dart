import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:either_dart/either.dart';

class ListValuesBloc extends ItemsListBloc<ValueModel, ListValuesFetchParams> {
  final FetchListValuesUseCase fetchListValuesUseCase;

  ListValuesBloc({
    required this.fetchListValuesUseCase,
  });

  @override
  Future<Either<ConvertouchException, ListValuesFetchResult>> fetchBatch(
    InputItemsFetchModel<ListValuesFetchParams> input,
  ) async {
    return await fetchListValuesUseCase.execute(input);
  }

  @override
  Future<Either<ConvertouchException, void>> removeItems(List<int> ids) async {
    return const Right(null);
  }

  @override
  Future<Either<ConvertouchException, ValueModel>> saveItem(
    ValueModel item,
  ) async {
    return Right(item);
  }
}
