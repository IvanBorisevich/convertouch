import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_set_repository.dart';
import 'package:convertouch/domain/use_cases/common/fetch_items_batch_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class FetchParamSetsUseCase extends FetchItemsBatchUseCase<
    ConversionParamSetModel, ParamSetsFetchParams> {
  final ConversionParamSetRepository conversionParamSetRepository;

  const FetchParamSetsUseCase({
    required this.conversionParamSetRepository,
  });

  @override
  Future<List<ConversionParamSetModel>> fetchItemsPage(
    InputItemsFetchModel<ParamSetsFetchParams> input,
  ) async {
    ParamSetsFetchParams? params = input.params;

    if (params == null) {
      return [];
    }

    return ObjectUtils.tryGet(
      await conversionParamSetRepository.search(
        groupId: params.parentItemId,
        searchString: input.searchString,
        pageNum: input.pageNum,
        pageSize: input.pageSize,
      ),
    );
  }

  @override
  ConversionParamSetModel addSearchMatch(
      ConversionParamSetModel item, String searchString) {
    return item.copyWith(
      nameMatch: ObjectUtils.toSearchMatch(item.name, searchString),
    );
  }
}
