import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/use_cases/common/fetch_items_batch_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class FetchListValuesUseCase
    extends FetchItemsBatchUseCase<ListValueModel, ListValuesFetchParams> {
  final ListValueRepository listValueRepository;

  const FetchListValuesUseCase({
    required this.listValueRepository,
  });

  @override
  Future<List<ListValueModel>> fetchItemsPage(
    InputItemsFetchModel<ListValuesFetchParams> input,
  ) async {
    ListValuesFetchParams? params = input.params;

    if (params == null) {
      return [];
    }

    return ObjectUtils.tryGet(
      await listValueRepository.search(
        listType: params.listType,
        searchString: input.searchString,
        pageNum: input.pageNum,
        pageSize: input.pageSize,
        unit: params.unit,
      ),
    );
  }

  @override
  ListValueModel addSearchMatch(ListValueModel item, String searchString) {
    return item;
  }
}
