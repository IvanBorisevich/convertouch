import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/use_cases/common/fetch_items_batch_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

const int listValuesPageSize = 100;

class FetchListValuesUseCase
    extends FetchItemsBatchUseCase<ValueModel, ListValuesFetchParams> {
  final ListValueRepository listValueRepository;

  const FetchListValuesUseCase({
    required this.listValueRepository,
  });

  @override
  Future<List<ValueModel>> fetchItemsPage(
      InputItemsFetchModel<ListValuesFetchParams> input,) async {
    if (input.fetchParams == null) {
      return [];
    }

    return ObjectUtils.tryGet(
      await listValueRepository.fetch(
        listType: input.fetchParams!.listType,
        searchString: input.searchString,
        pageNum: input.pageNum,
        pageSize: input.pageSize,
        unit: input.fetchParams!.unit,
        params: input.fetchParams!.params,
      ),
    );
  }

  @override
  Future<bool> containsSelectedValue(
      InputItemsFetchModel<ListValuesFetchParams> input,) async {
    if (input.fetchParams == null) {
      return false;
    }

    return ObjectUtils.tryGet(
      await listValueRepository.belongsToList(
        value: input.fetchParams!.selectedValue,
        listType: input.fetchParams!.listType,
        unit: input.fetchParams!.unit,
        params: input.fetchParams!.params,
      ),
    );
  }

  @override
  ValueModel addSearchMatch(ValueModel item, String searchString) {
    return item;
  }
}
