import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class ItemsListState extends ConvertouchState {
  const ItemsListState();
}

class ItemsFetched<T extends IdNameSearchableItemModel> extends ItemsListState {
  final List<T> pageItems;
  final List<int> oobIds;
  final int parentItemId;
  final ItemType? parentItemType;
  final String? searchString;
  final FetchingStatus status;
  final bool hasReachedMax;
  final int pageNum;

  const ItemsFetched({
    required this.pageItems,
    this.oobIds = const [],
    this.parentItemId = -1,
    this.parentItemType,
    this.searchString,
    this.status = FetchingStatus.success,
    this.hasReachedMax = false,
    this.pageNum = 0,
  });

  @override
  List<Object?> get props => [
        pageItems,
        oobIds,
        parentItemId,
    parentItemType,
        searchString,
        status,
        hasReachedMax,
        pageNum,
      ];

  @override
  String toString() {
    return 'ItemsFetched{'
        'itemsCount: ${pageItems.length}, '
        'parentItemId: $parentItemId, '
        'parentItemType: $parentItemType, '
        'searchString: $searchString, '
        'status: $status, '
        'hasReachedMax: $hasReachedMax, '
        'pageNum: $pageNum}';
  }
}
