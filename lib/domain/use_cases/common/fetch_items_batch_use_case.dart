import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

abstract class FetchItemsBatchUseCase<T extends IdNameSearchableItemModel,
        P extends ItemsFetchParams>
    extends UseCase<InputItemsFetchModel<P>, OutputItemsFetchModel<T, P>> {
  const FetchItemsBatchUseCase();

  @override
  Future<Either<ConvertouchException, OutputItemsFetchModel<T, P>>> execute(
    InputItemsFetchModel<P> input,
  ) async {
    String? searchString = input.searchString;
    int pageSize = input.pageSize;
    int pageNum = input.pageNum;
    P? params = input.fetchParams;
    bool hasSelectedValue =
        pageNum == 0 && await containsSelectedValue(input);

    final newPageItems = await fetchItemsPage(input);

    final itemsWithMatch = newPageItems
        .map((item) =>
            input.searchString != null && input.searchString!.isNotEmpty
                ? addSearchMatch(item, input.searchString!)
                : item)
        .toList();

    if (newPageItems.isNotEmpty) {
      pageNum++;
    }

    bool hasReachedMax = newPageItems.length < pageSize;

    return Right(
      OutputItemsFetchModel(
        items: itemsWithMatch,
        searchString: searchString,
        pageNum: pageNum,
        hasReachedMax: hasReachedMax,
        fetchParams: params,
        containsSelectedValue: hasSelectedValue,
      ),
    );
  }

  Future<List<T>> fetchItemsPage(InputItemsFetchModel<P> input);

  Future<bool> containsSelectedValue(InputItemsFetchModel<P> input) async =>
      false;

  T addSearchMatch(T item, String searchString);
}
