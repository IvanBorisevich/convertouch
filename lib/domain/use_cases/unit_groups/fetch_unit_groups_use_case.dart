import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/use_cases/common/fetch_items_batch_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class FetchUnitGroupsUseCase
    extends FetchItemsBatchUseCase<UnitGroupModel, UnitGroupsFetchParams> {
  final UnitGroupRepository unitGroupRepository;

  const FetchUnitGroupsUseCase(this.unitGroupRepository);

  @override
  Future<List<UnitGroupModel>> fetchItemsPage(
    InputItemsFetchModel<UnitGroupsFetchParams> input,
  ) async {
    return ObjectUtils.tryGet(
      await unitGroupRepository.search(
        searchString: input.searchString,
        pageNum: input.pageNum,
        pageSize: input.pageSize,
      ),
    );
  }

  @override
  UnitGroupModel addSearchMatch(UnitGroupModel item, String searchString) {
    return item.copyWith(
      nameMatch: ObjectUtils.toSearchMatch(item.name, searchString),
    );
  }
}
