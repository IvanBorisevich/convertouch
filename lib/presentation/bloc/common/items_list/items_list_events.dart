import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class ItemsListEvent extends ConvertouchEvent {
  const ItemsListEvent({
    super.onSuccess,
    super.onError,
  });
}

class FetchItems<T extends IdNameItemModel, P extends ItemsFetchParams>
    extends ItemsListEvent {
  final String? searchString;
  final int pageNum;
  final int pageSize;
  final bool firstFetch;
  final T? selectedItem;
  final void Function()? onFirstFetch;
  final P? fetchParams;
  final bool emitLoadingState;

  const FetchItems({
    this.searchString,
    this.pageNum = 0,
    this.pageSize = 100,
    this.firstFetch = true,
    this.selectedItem,
    this.fetchParams,
    this.onFirstFetch,
    this.emitLoadingState = false,
    super.onSuccess,
  });

  @override
  List<Object?> get props => [
        searchString,
        selectedItem,
        pageNum,
        pageSize,
        firstFetch,
        fetchParams,
        emitLoadingState,
      ];

  @override
  String toString() {
    return 'FetchItems{'
        'searchString: $searchString, '
        'fetchParams: $fetchParams, '
        'selectedItem: $selectedItem, '
        'pageNum: $pageNum, '
        'pageSize: $pageSize, '
        'firstFetch: $firstFetch, '
        'onFirstFetch: $onFirstFetch}';
  }
}

class SaveItem<T extends IdNameItemModel> extends ItemsListEvent {
  final T item;
  final void Function(T)? onItemSave;

  const SaveItem({
    required this.item,
    this.onItemSave,
    super.onError,
  });

  @override
  List<Object?> get props => [
        item,
      ];

  @override
  String toString() {
    return 'SaveItem{item: $item}';
  }
}

class RemoveItems extends ItemsListEvent {
  final List<int> ids;

  const RemoveItems({
    required this.ids,
    super.onSuccess,
  });

  @override
  List<Object?> get props => [
        ids,
        super.props,
      ];

  @override
  String toString() {
    return 'RemoveItems{ids: $ids}';
  }
}

class CancelFetch extends ItemsListEvent {
  const CancelFetch();

  @override
  String toString() {
    return 'CancelFetch{}';
  }
}
