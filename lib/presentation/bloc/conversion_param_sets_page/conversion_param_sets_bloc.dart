import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/param_set/fetch_param_sets_use_case.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:either_dart/either.dart';

typedef OutputParamSetsFetch
    = OutputItemsFetchModel<ConversionParamSetModel, ParamSetsFetchParams>;

class ConversionParamSetsBloc
    extends ItemsListBloc<ConversionParamSetModel, ParamSetsFetchParams> {
  final FetchParamSetsUseCase fetchParamSetsUseCase;

  ConversionParamSetsBloc({
    required this.fetchParamSetsUseCase,
  });

  @override
  Future<Either<ConvertouchException, OutputParamSetsFetch>> fetchBatch(
    InputItemsFetchModel<ParamSetsFetchParams> input,
  ) async {
    return await fetchParamSetsUseCase.execute(input);
  }

  @override
  Future<Either<ConvertouchException, void>> removeItems(
    List<int> ids,
  ) async {
    return const Right(null);
  }

  @override
  Future<Either<ConvertouchException, ConversionParamSetModel>> saveItem(
    ConversionParamSetModel item,
  ) async {
    return Right(item);
  }
}
