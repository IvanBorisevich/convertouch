import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_dynamic_data_fetch_model.dart';
import 'package:convertouch/domain/repositories/dynamic_value_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class FetchDynamicValueUseCase
    extends UseCase<InputDynamicValueFetchModel, DynamicValueModel?> {
  final DynamicValueRepository dynamicValueRepository;

  const FetchDynamicValueUseCase({
    required this.dynamicValueRepository,
  });

  @override
  Future<Either<ConvertouchException, DynamicValueModel?>> execute(
    InputDynamicValueFetchModel input,
  ) async {
    return await dynamicValueRepository.get(
      unit: input.srcUnit,
      conversionGroupName: input.groupName,
      params: input.params,
    );
  }
}
