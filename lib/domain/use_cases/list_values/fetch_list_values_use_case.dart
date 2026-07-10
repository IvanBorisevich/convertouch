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
    InputItemsFetchModel<ListValuesFetchParams> input,
  ) async {
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
        conversionGroupName: input.fetchParams!.conversionGroupName,
        params: input.fetchParams!.conversionParams,
      ),
    );
  }

  @override
  Future<ValueModel?> alignSelectedValue(
    List<ValueModel> listValues,
    InputItemsFetchModel<ListValuesFetchParams> input,
  ) async {
    if (input.fetchParams == null) {
      return null;
    }

    bool leaveUnknownSelectedValue =
        input.fetchParams!.leaveUnknownSelectedValue;
    bool leaveEmptySelectedValue = input.fetchParams!.leaveEmptySelectedValue;

    ValueModel? selectedValue = input.fetchParams!.selectedValue;
    ValueModel? preselectedValue =
        input.fetchParams!.listType.preselected ? listValues.firstOrNull : null;

    ValueModel? validatedSelectedValue = ObjectUtils.tryGet(
      await listValueRepository.validateValue(
        value: selectedValue,
        listType: input.fetchParams!.listType,
        unit: input.fetchParams!.unit,
        params: input.fetchParams!.conversionParams,
      ),
    );

    ValueModel? result =
        leaveUnknownSelectedValue ? selectedValue : validatedSelectedValue;
    result ??= (leaveEmptySelectedValue ? null : preselectedValue);

    if (result?.iconUri == null) {
      String? resultIconUri = input.fetchParams!.listType.defaultIconUri != null
          ? (result?.iconUri ?? input.fetchParams!.listType.defaultIconUri)
          : null;

      result = result?.copyWith(
        iconUri: resultIconUri,
      );
    }

    return result;
  }

  @override
  ValueModel addSearchMatch(ValueModel item, String searchString) {
    return item;
  }
}
