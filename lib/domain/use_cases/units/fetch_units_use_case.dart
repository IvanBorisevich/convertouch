import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/common/fetch_items_batch_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class FetchUnitsUseCase
    extends FetchItemsBatchUseCase<UnitModel, UnitsFetchParams> {
  final UnitRepository unitRepository;

  const FetchUnitsUseCase(this.unitRepository);

  @override
  Future<List<UnitModel>> fetchItemsPage(
    InputItemsFetchModel<UnitsFetchParams> input,
  ) async {
    UnitsFetchParams? params = input.params;

    if (params == null) {
      return [];
    }

    if (params.parentItemType == ItemType.unitGroup) {
      return ObjectUtils.tryGet(
        await unitRepository.searchWithGroupId(
          unitGroupId: params.parentItemId,
          searchString: input.searchString,
          pageNum: input.pageNum,
          pageSize: input.pageSize,
        ),
      );
    } else if (params.parentItemType == ItemType.conversionParam) {
      return ObjectUtils.tryGet(
        await unitRepository.searchWithParamId(
          paramId: params.parentItemId,
          searchString: input.searchString,
          pageNum: input.pageNum,
          pageSize: input.pageSize,
        ),
      );
    }

    return [];
  }

  @override
  UnitModel addSearchMatch(UnitModel item, String searchString) {
    return item.copyWith(
      nameMatch: ObjectUtils.toSearchMatch(item.itemName, searchString),
      codeMatch: ObjectUtils.toSearchMatch(item.code, searchString),
    );
  }
}
