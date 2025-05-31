import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class GetListValuesUseCase extends UseCase<
    InputItemsFetchModel<DropdownItemsFetchParams>, List<ListValueModel>> {
  final ListValueRepository listValueRepository;

  const GetListValuesUseCase({
    required this.listValueRepository,
  });

  @override
  Future<Either<ConvertouchException, List<ListValueModel>>> execute(
    InputItemsFetchModel<DropdownItemsFetchParams> input,
  ) async {
    if (input.listType == null) {
      return const Right([]);
    }

    return await listValueRepository.search(
      listType: input.listType!,
      searchString: input.searchString,
      pageNum: input.pageNum,
      pageSize: input.pageSize,
      unit: input.params?.unit,
    );
  }
}
