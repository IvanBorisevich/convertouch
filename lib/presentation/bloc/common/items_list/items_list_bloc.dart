import 'dart:developer';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
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
        S extends ItemsFetched<T>>
    extends ConvertouchBloc<ItemsListEvent, ItemsFetched<T>> {
  ItemsListBloc() : super(ItemsFetched<T>(pageItems: const [])) {
    on<FetchItems>(
      _onFetchItems,
      transformer: throttleDroppable(throttleDuration),
    );
    on<SaveItem<T>>(_onSaveItem);
    on<RemoveItems>(_onRemoveItems);
  }

  _onFetchItems<E extends FetchItems>(
    FetchItems event,
    Emitter<ItemsFetched<T>> emit,
  ) async {
    int pageNum;
    int parentItemId;
    String? searchString;
    bool hasReachedMax;
    List<int> oobIds;

    if (event.firstFetch) {
      pageNum = 0;
      parentItemId = event.parentItemId;
      searchString = event.searchString;
      hasReachedMax = false;
      oobIds = [];
    } else {
      pageNum = state.pageNum;
      parentItemId = state.parentItemId;
      searchString = state.searchString;
      hasReachedMax = state.hasReachedMax;
      oobIds = state.oobIds;
    }

    if (hasReachedMax) {
      return;
    }

    try {
      final newItems = ObjectUtils.tryGet(
        await fetchItems(
          InputItemsFetchModel(
            searchString: searchString,
            parentItemId: parentItemId,
            pageSize: event.pageSize,
            pageNum: pageNum,
            coefficient: event.coefficient,
            parentItemType: event.parentItemType,
            listType: event.listType,
          ),
        ),
      );

      final itemsWithMatch = newItems
          .map((item) =>
              searchString != null && searchString.isNotEmpty
                  ? addSearchMatch(item, searchString)
                  : item)
          .toList();

      oobIds.addAll(
        newItems.where((item) => item.oob).map((item) => item.id).toList(),
      );

      if (newItems.isNotEmpty) {
        pageNum++;
      }

      hasReachedMax = newItems.length < event.pageSize;

      emit(
        ItemsFetched<T>(
          status: FetchingStatus.success,
          hasReachedMax: hasReachedMax,
          parentItemId: parentItemId,
          parentItemType: event.parentItemType,
          pageItems: itemsWithMatch,
          oobIds: oobIds,
          searchString: searchString,
          pageNum: pageNum,
        ),
      );

      if (event.firstFetch) {
        event.onFirstFetch?.call();
      }
    } catch (e, stacktrace) {
      log("Error when fetching items: $e\n$stacktrace");
      emit(
        ItemsFetched<T>(
          status: FetchingStatus.failure,
          hasReachedMax: hasReachedMax,
          parentItemId: parentItemId,
          parentItemType: event.parentItemType,
          pageItems: const [],
          searchString: searchString,
          pageNum: pageNum,
        ),
      );
    }
  }

  _onSaveItem(
    SaveItem<T> event,
    Emitter<ItemsFetched> emit,
  ) async {
    final result = ObjectUtils.tryGet(await saveItem(event.item));

    add(
      FetchItems(
        parentItemId: state.parentItemId,
        parentItemType: state.parentItemType,
      ),
    );

    event.onItemSave?.call(result);
  }

  _onRemoveItems(
    RemoveItems event,
    Emitter<ItemsFetched<T>> emit,
  ) async {
    ObjectUtils.tryGet(await removeItems(event.ids));

    add(
      FetchItems(
        searchString: state.searchString,
        parentItemId: state.parentItemId,
      ),
    );

    event.onComplete?.call();
  }

  Future<Either<ConvertouchException, List<T>>> fetchItems(
    InputItemsFetchModel input,
  );

  Future<Either<ConvertouchException, T>> saveItem(T item);

  Future<Either<ConvertouchException, void>> removeItems(List<int> ids);

  T addSearchMatch(T item, String searchString);
}
