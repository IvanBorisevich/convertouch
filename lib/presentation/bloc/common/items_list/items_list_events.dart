import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class ItemsListEvent extends ConvertouchEvent {
  const ItemsListEvent({
    super.onComplete,
  });
}

class FetchItems<P extends ItemsFetchParams> extends ItemsListEvent {
  final String? searchString;
  final int pageSize;
  final bool firstFetch;
  final void Function()? onFirstFetch;
  final P? params;

  const FetchItems({
    this.searchString,
    this.pageSize = 100,
    this.firstFetch = true,
    this.params,
    this.onFirstFetch,
  });

  @override
  List<Object?> get props => [
        searchString,
        pageSize,
        firstFetch,
        params,
      ];

  @override
  String toString() {
    return 'FetchItems{'
        'searchString: $searchString, '
        'pageSize: $pageSize, '
        'firstFetch: $firstFetch, '
        'onFirstFetch: $onFirstFetch, '
        'params: $params}';
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
