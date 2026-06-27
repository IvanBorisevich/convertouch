import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_list_value_validation_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class ValidateListValueUseCase
    extends UseCase<InputListValueValidationModel, ValueModel?> {
  final ListValueRepository listValueRepository;

  const ValidateListValueUseCase({
    required this.listValueRepository,
  });

  @override
  Future<Either<ConvertouchException, ValueModel?>> execute(
    InputListValueValidationModel input,
  ) async {
    if (input.fetchParams == null) {
      return const Right(null);
    }

    return await listValueRepository.validateValue(
      value: input.value,
      listType: input.fetchParams!.listType,
      unit: input.fetchParams!.unit,
      params: input.fetchParams!.params,
    );
  }
}
