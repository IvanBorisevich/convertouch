import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class ItemsListEvent extends ConvertouchEvent {
  const ItemsListEvent({
    super.onComplete,
  });
}

class FetchItems extends ItemsListEvent {
  final String? searchString;
  final int pageSize;
  final bool firstFetch;
  final int parentItemId;
  final void Function()? onFirstFetch;

  const FetchItems({
    this.searchString,
    this.pageSize = 200,
    this.firstFetch = true,
    this.parentItemId = -1,
    this.onFirstFetch,
  });

  @override
  List<Object?> get props => [
        searchString,
        pageSize,
        firstFetch,
        parentItemId,
      ];

  @override
  String toString() {
    return 'FetchItems{'
        'searchString: $searchString, '
        'parentItemId: $parentItemId, '
        'pageSize: $pageSize, '
        'firstFetch: $firstFetch}';
  }
}

class SaveItem<T extends IdNameItemModel> extends ItemsListEvent {
  final T item;
  final void Function(T)? onItemSave;

  const SaveItem({
    required this.item,
    this.onItemSave,
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
    super.onComplete,
  });

  @override
  List<Object?> get props => [
        ids,
        super.props,
      ];

  @override
  String toString() {
    return 'RemoveItems{'
        'ids: $ids}';
  }
}
