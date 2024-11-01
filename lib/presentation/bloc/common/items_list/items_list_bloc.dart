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

abstract class ItemsListBloc<T extends IdNameItemModel,
        S extends ItemsFetched<T>>
    extends ConvertouchBloc<ItemsListEvent, ItemsFetched<T>> {
  ItemsListBloc() : super(ItemsFetched<T>(items: const [])) {
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
    if (state.hasReachedMax && !event.firstFetch) {
      return;
    }

    int pageNum;
    int parentItemId;
    String? searchString;

    if (event.firstFetch) {
      pageNum = 0;
      parentItemId = event.parentItemId;
      searchString = event.searchString;
    } else {
      pageNum = state.pageNum;
      parentItemId = state.parentItemId;
      searchString = state.searchString;
    }

    try {
      final newItems = ObjectUtils.tryGet(
        await fetchItems(
          InputItemsFetchModel(
            searchString: searchString,
            parentItemId: parentItemId,
            pageSize: event.pageSize,
            pageNum: pageNum,
          ),
        ),
      );

      if (newItems.isNotEmpty) {
        pageNum++;
      }

      final hasReachedMax = newItems.length < event.pageSize;
      final allItems = event.firstFetch
          ? newItems
          : [
              ...state.items,
              ...newItems,
            ];

      emit(
        state.copyWith(
          hasReachedMax: hasReachedMax,
          parentItemId: parentItemId,
          items: allItems,
          searchString: searchString,
          status: FetchingStatus.success,
          pageNum: pageNum,
        ),
      );
    } catch (e, stacktrace) {
      log("Error when fetching items: $e\n$stacktrace");
      emit(
        state.copyWith(
          status: FetchingStatus.failure,
          searchString: searchString,
          parentItemId: parentItemId,
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
      const FetchItems(),
    );

    event.onItemSave?.call(result);
  }

  _onRemoveItems(
    RemoveItems event,
    Emitter<ItemsFetched<T>> emit,
  ) async {
    ObjectUtils.tryGet(await removeItems(event.ids));

    add(
      FetchItems(searchString: state.searchString),
    );

    event.onComplete?.call();
  }

  Future<Either<ConvertouchException, List<T>>> fetchItems(
    InputItemsFetchModel input,
  );

  Future<Either<ConvertouchException, T>> saveItem(T item);

  Future<Either<ConvertouchException, void>> removeItems(List<int> ids);
}
