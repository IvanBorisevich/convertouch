import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class ItemsListState extends ConvertouchState {
  const ItemsListState();
}

class ItemsFetched<T extends IdNameSearchableItemModel> extends ItemsListState {
  final List<T> pageItems;
  final T? selectedItem;
  final List<int> oobIds;
  final int parentItemId;
  final UnitModel? listItemUnit;
  final ItemType? parentItemType;
  final String? searchString;
  final FetchingStatus status;
  final bool hasReachedMax;
  final int pageNum;

  const ItemsFetched({
    required this.pageItems,
    this.selectedItem,
    this.oobIds = const [],
    this.parentItemId = -1,
    this.listItemUnit,
    this.parentItemType,
    this.searchString,
    this.status = FetchingStatus.success,
    this.hasReachedMax = false,
    this.pageNum = 0,
  });

  ItemsFetched<T> copyWith({
    T? selectedItem,
  }) {
    return ItemsFetched(
      pageItems: pageItems,
      selectedItem: selectedItem ?? this.selectedItem,
      oobIds: oobIds,
      parentItemId: parentItemId,
      listItemUnit: listItemUnit,
      parentItemType: parentItemType,
      searchString: searchString,
      status: status,
      hasReachedMax: hasReachedMax,
      pageNum: pageNum,
    );
  }

  @override
  List<Object?> get props => [
        pageItems,
        selectedItem,
        oobIds,
        parentItemId,
        parentItemType,
        listItemUnit,
        searchString,
        status,
        hasReachedMax,
        pageNum,
      ];

  @override
  String toString() {
    return 'ItemsFetched{'
        'itemsCount: ${pageItems.length}, '
        'selectedItem: $selectedItem, '
        'parentItemId: $parentItemId, '
        'listItemUnit: ${listItemUnit?.code}, '
        'parentItemType: $parentItemType, '
        'searchString: $searchString, '
        'status: $status, '
        'hasReachedMax: $hasReachedMax, '
        'pageNum: $pageNum}';
  }
}
