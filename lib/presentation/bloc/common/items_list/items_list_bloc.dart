import 'dart:developer';

import 'package:bloc_concurrency/bloc_concurrency.dart';
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
  final EventTransformer<FetchItems<P>>? fetchItemsEventTransformer;

  ItemsListBloc({
    this.fetchItemsEventTransformer,
  }) : super(
          ItemsFetched<T, P>(
            itemsFetch: const OutputItemsFetchModel.successEmpty(),
          ),
        ) {
    on<FetchItems<P>>(
      _onFetchItems,
      transformer: this.fetchItemsEventTransformer ??
          throttleDroppable(throttleDuration),
    );
    on<SaveItem<T>>(_onSaveItem);
    on<RemoveItems>(_onRemoveItems);
    on<CancelFetch>(_onCancelFetch);
  }

  _onFetchItems<E extends FetchItems>(
    FetchItems<P> event,
    Emitter<ItemsFetched<T, P>> emit,
  ) async {
    await cancelFetch();

    int pageNum;
    P? fetchParams;
    String? searchString;
    bool hasReachedMax;
    List<int> oobIds;
    List<T> allItems;

    if (event.firstFetch) {
      allItems = [];
      pageNum = 0;
      fetchParams = event.fetchParams;
      searchString = event.searchString;
      hasReachedMax = false;
      oobIds = [];
    } else {
      allItems = state.itemsFetch.items;
      pageNum = event.pageNum ?? state.itemsFetch.pageNum;
      fetchParams = state.itemsFetch.fetchParams;
      searchString = state.itemsFetch.searchString;
      hasReachedMax = state.itemsFetch.hasReachedMax;
      oobIds = List.of(state.oobIds);
    }

    if (hasReachedMax) {
      return;
    }

    if (event.emitLoadingState) {
      emit(
        ItemsFetched<T, P>(
          itemsFetch: OutputItemsFetchModel.loading(
            items: allItems,
            selectedItem: state.itemsFetch.selectedItem,
            searchString: searchString,
            pageNum: pageNum,
            fetchParams: fetchParams,
          ),
        ),
      );
    }

    try {
      final newBatch = await fetchBatch(
        InputItemsFetchModel(
          searchString: searchString,
          pageSize: event.pageSize,
          pageNum: pageNum,
          fetchParams: fetchParams,
        ),
      );

      if (newBatch.isLeft) {
        throw newBatch.left;
      }

      if (newBatch.right.isFailed) {
        throw newBatch.right.error!;
      }

      oobIds.addAll(
        newBatch.right.items
            .where((item) => item.oob)
            .map((item) => item.id)
            .toList(),
      );

      emit(
        ItemsFetched<T, P>(
          itemsFetch: OutputItemsFetchModel.success(
            items: [
              ...allItems,
              ...newBatch.right.items,
            ],
            selectedItem: newBatch.right.selectedItem,
            hasReachedMax: newBatch.right.hasReachedMax,
            searchString: searchString,
            pageNum: newBatch.right.pageNum,
            fetchParams: fetchParams,
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
          itemsFetch: OutputItemsFetchModel.failure(
            items: state.itemsFetch.items,
            selectedItem: state.itemsFetch.selectedItem,
            error: e is ConvertouchException
                ? e
                : ConvertouchException(message: e.toString()),
            hasReachedMax: hasReachedMax,
            searchString: searchString,
            pageNum: pageNum,
            fetchParams: fetchParams,
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
    final result = await saveItem(event.item);
    if (result.isRight) {
      event.onItemSave?.call(result.right);
    } else {
      event.onError?.call(result.left);
    }
  }

  _onRemoveItems(
    RemoveItems event,
    Emitter<ItemsFetched<T, P>> emit,
  ) async {
    ObjectUtils.tryGet(await removeItems(event.ids));
    event.onSuccess?.call();
  }

  _onCancelFetch(
    CancelFetch event,
    Emitter<ItemsFetched<T, P>> emit,
  ) async {
    await cancelFetch();
  }

  Future<Either<ConvertouchException, OutputItemsFetchModel<T, P>>> fetchBatch(
    InputItemsFetchModel<P> input,
  );

  Future<Either<ConvertouchException, T>> saveItem(T item);

  Future<Either<ConvertouchException, void>> removeItems(List<int> ids);

  Future<Either<ConvertouchException, void>> cancelFetch() async {
    return const Right(null);
  }

  @override
  Future<void> close() async {
    await cancelFetch();

    return super.close();
  }
}
