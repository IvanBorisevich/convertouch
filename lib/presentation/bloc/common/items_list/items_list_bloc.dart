import 'dart:developer';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_states.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

abstract class ItemsListBloc<T extends IdNameSearchableItemModel,
        P extends ItemsFetchParams>
    extends ConvertouchBloc<ItemsListEvent, ItemsFetched<T, P>> {
  ItemsListBloc()
      : super(ItemsFetched<T, P>(
          itemsFetch: const OutputItemsFetchModel.empty(),
        )) {
    on<FetchItems<P>>(
      _onFetchItems,
      transformer: throttleDroppable(throttleDuration),
    );
    on<SaveItem<T>>(_onSaveItem);
    on<RemoveItems>(_onRemoveItems);
  }

  _onFetchItems<E extends FetchItems>(
    FetchItems<P> event,
    Emitter<ItemsFetched<T, P>> emit,
  ) async {
    int pageNum;
    P? params;
    String? searchString;
    bool hasReachedMax;
    List<int> oobIds;
    List<T> allItems;

    if (event.firstFetch) {
      allItems = [];
      pageNum = 0;
      params = event.params;
      searchString = event.searchString;
      hasReachedMax = false;
      oobIds = [];
    } else {
      allItems = state.itemsFetch.items;
      pageNum = state.itemsFetch.pageNum;
      params = state.itemsFetch.params;
      searchString = state.itemsFetch.searchString;
      hasReachedMax = state.itemsFetch.hasReachedMax;
      oobIds = state.oobIds;
    }

    if (hasReachedMax) {
      return;
    }

    try {
      final newPageItems = ObjectUtils.tryGet(
        await fetchItemsPage(
          InputItemsFetchModel(
            searchString: searchString,
            pageSize: event.pageSize,
            pageNum: pageNum,
            params: params,
          ),
        ),
      );

      final itemsWithMatch = newPageItems
          .map((item) => searchString != null && searchString.isNotEmpty
              ? addSearchMatch(item, searchString)
              : item)
          .toList();

      oobIds.addAll(
        newPageItems.where((item) => item.oob).map((item) => item.id).toList(),
      );

      if (newPageItems.isNotEmpty) {
        pageNum++;
      }

      hasReachedMax = newPageItems.length < event.pageSize;

      emit(
        ItemsFetched<T, P>(
          itemsFetch: OutputItemsFetchModel(
            items: [
              ...allItems,
              ...itemsWithMatch,
            ],
            status: FetchingStatus.success,
            hasReachedMax: hasReachedMax,
            searchString: searchString,
            pageNum: pageNum,
            params: params,
          ),
          oobIds: oobIds,
        ),
      );

      if (event.firstFetch) {
        event.onFirstFetch?.call();
      }
    } catch (e, stacktrace) {
      log("Error when fetching items: $e\n$stacktrace");
      emit(
        ItemsFetched<T, P>(
          itemsFetch: OutputItemsFetchModel(
            items: state.itemsFetch.items,
            status: FetchingStatus.failure,
            hasReachedMax: hasReachedMax,
            searchString: searchString,
            pageNum: pageNum,
            params: params,
          ),
          oobIds: oobIds,
        ),
      );
    }
  }

  _onSaveItem(
    SaveItem<T> event,
    Emitter<ItemsFetched<T, P>> emit,
  ) async {
    final result = ObjectUtils.tryGet(await saveItem(event.item));

    add(FetchItems<P>());

    event.onItemSave?.call(result);
  }

  _onRemoveItems(
    RemoveItems event,
    Emitter<ItemsFetched<T, P>> emit,
  ) async {
    ObjectUtils.tryGet(await removeItems(event.ids));

    add(FetchItems<P>());

    event.onComplete?.call();
  }

  Future<Either<ConvertouchException, List<T>>> fetchItemsPage(
    InputItemsFetchModel<P> input,
  );

  Future<Either<ConvertouchException, T>> saveItem(T item);

  Future<Either<ConvertouchException, void>> removeItems(List<int> ids);

  T addSearchMatch(T item, String searchString);
}
