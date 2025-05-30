import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_list_value_selection_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class SelectListValueUseCase
    extends UseCase<InputListValueSelectionModel, ListValueModel?> {
  final ListValueRepository listValueRepository;

  const SelectListValueUseCase({
    required this.listValueRepository,
  });

  @override
  Future<Either<ConvertouchException, ListValueModel?>> execute(
    InputListValueSelectionModel input,
  ) async {
    return await listValueRepository.getByStrValue(
      listType: input.listType,
      value: input.value,
    );
  }
}
