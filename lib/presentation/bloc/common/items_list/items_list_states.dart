import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class ItemsListState extends ConvertouchState {
  const ItemsListState();
}

class ItemsFetched<T extends IdNameItemModel> extends ItemsListState {
  final List<T> items;
  final int parentItemId;
  final String? searchString;
  final FetchingStatus status;
  final bool hasReachedMax;
  final int pageNum;

  const ItemsFetched({
    required this.items,
    this.parentItemId = -1,
    this.searchString,
    this.status = FetchingStatus.success,
    this.hasReachedMax = false,
    this.pageNum = 0,
  });

  @override
  List<Object?> get props => [
        items,
    parentItemId,
        searchString,
        status,
        hasReachedMax,
        pageNum,
      ];

  ItemsFetched<T> copyWith({
    FetchingStatus? status,
    List<T>? items,
    int? parentItemId,
    bool? hasReachedMax,
    String? searchString,
    int? pageNum,
  }) {
    return ItemsFetched<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      parentItemId: parentItemId ?? this.parentItemId,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchString: searchString ?? this.searchString,
      pageNum: pageNum ?? this.pageNum,
    );
  }

  @override
  String toString() {
    return 'ItemsFetched{'
        'itemsSize: ${items.length}, '
        'parentItemId: $parentItemId, '
        'searchString: $searchString, '
        'status: $status, '
        'hasReachedMax: $hasReachedMax, '
        'pageNum: $pageNum}';
  }
}
