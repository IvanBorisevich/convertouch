import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_marking_model.dart';
import 'package:convertouch/domain/use_cases/common/mark_items_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsSelectionBloc
    extends ConvertouchBloc<ConvertouchEvent, ItemsSelectionDone> {
  final MarkItemsUseCase markItemsUseCase;

  ItemsSelectionBloc({
    required this.markItemsUseCase,
  }) : super(const ItemsSelectionDone()) {
    on<StartItemsMarking>(_onStartItemsMarking);
    on<CancelItemsMarking>(_onCancelItemsMarking);
    on<StartItemSelection>(_onStartItemSelection);
    on<SelectItem>(_onSelectItem);
  }

  _onStartItemsMarking(
    StartItemsMarking event,
    Emitter<ItemsSelectionDone> emit,
  ) async {
    var markedIds = (event.previouslyMarkedIds ?? [])
        .whereNot((id) => event.excludedIds.contains(id))
        .toList();
    var canMarkedItemsBeSelected =
        markedIds.length >= event.markedItemsMinNumForSelection;

    emit(
      ItemsSelectionDone(
        markedIds: markedIds,
        markedItemsMinNumForSelection: event.markedItemsMinNumForSelection,
        canMarkedItemsBeSelected: canMarkedItemsBeSelected,
        singleItemSelectionMode: false,
        excludedIds: event.excludedIds,
        showCancelIcon: event.showCancelIcon,
      ),
    );
  }

  _onCancelItemsMarking(
    CancelItemsMarking event,
    Emitter<ItemsSelectionDone> emit,
  ) async {
    emit(
      ItemsSelectionDone(
        markedItemsMinNumForSelection: state.markedItemsMinNumForSelection,
        singleItemSelectionMode: false,
        excludedIds: state.excludedIds,
        showCancelIcon: false,
      ),
    );
  }

  _onStartItemSelection(
    StartItemSelection event,
    Emitter<ItemsSelectionDone> emit,
  ) async {
    emit(
      ItemsSelectionDone(
        selectedId: event.previouslySelectedId,
        singleItemSelectionMode: true,
        excludedIds: event.excludedIds,
      ),
    );
  }

  _onSelectItem(
    SelectItem event,
    Emitter<ItemsSelectionDone> emit,
  ) async {
    if (state.excludedIds.contains(event.id) || event.id == state.selectedId) {
      return;
    }

    if (state.singleItemSelectionMode) {
      emit(
        ItemsSelectionDone(
          selectedId: event.id,
          singleItemSelectionMode: true,
          excludedIds: state.excludedIds,
        ),
      );
    } else {
      final markedIdsResult = await markItemsUseCase.execute(
        InputItemsMarkingModel(
          newMarkedId: event.id,
          alreadyMarkedIds: state.markedIds,
          excludedIds: state.excludedIds,
        ),
      );

      var markedIds = ObjectUtils.tryGet(markedIdsResult).markedIds;

      var canMarkedItemsBeSelected =
          markedIds.length >= state.markedItemsMinNumForSelection;

      emit(
        ItemsSelectionDone(
          markedIds: markedIds,
          markedItemsMinNumForSelection: state.markedItemsMinNumForSelection,
          canMarkedItemsBeSelected: canMarkedItemsBeSelected,
          singleItemSelectionMode: false,
          excludedIds: state.excludedIds,
          showCancelIcon: state.showCancelIcon,
        ),
      );
    }
  }
}

class ItemsSelectionBlocForConversion extends ItemsSelectionBloc {
  ItemsSelectionBlocForConversion({
    required super.markItemsUseCase,
  });
}

class ItemsSelectionBlocForUnitDetails extends ItemsSelectionBloc {
  ItemsSelectionBlocForUnitDetails({
    required super.markItemsUseCase,
  });
}
