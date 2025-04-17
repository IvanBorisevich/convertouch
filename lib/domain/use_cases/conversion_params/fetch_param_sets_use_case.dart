import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_set_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class FetchParamSetsUseCase
    extends UseCase<InputItemsFetchModel, List<ConversionParamSetModel>> {
  final ConversionParamSetRepository conversionParamSetRepository;

  const FetchParamSetsUseCase({
    required this.conversionParamSetRepository,
  });

  @override
  Future<Either<ConvertouchException, List<ConversionParamSetModel>>> execute(
    InputItemsFetchModel input,
  ) async {
    if (input.searchString == null || input.searchString!.isEmpty) {
      return await conversionParamSetRepository.getPage(
        groupId: input.parentItemId,
        pageNum: input.pageNum,
        pageSize: input.pageSize,
      );
    } else {
      return await conversionParamSetRepository.search(
        groupId: input.parentItemId,
        searchString: input.searchString!,
        pageNum: input.pageNum,
        pageSize: input.pageSize,
      );
    }
  }
}
