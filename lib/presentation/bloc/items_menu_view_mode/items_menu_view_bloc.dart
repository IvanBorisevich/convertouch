import 'package:convertouch/domain/usecases/items_menu_view_mode/change_items_menu_view_use_case.dart';
import 'package:convertouch/presentation/bloc/items_menu_view_mode/items_menu_view_event.dart';
import 'package:convertouch/presentation/bloc/items_menu_view_mode/items_view_mode_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsMenuViewBloc extends Bloc<ItemsMenuViewEvent, ItemsViewModeState> {
  final ChangeItemsMenuViewUseCase changeItemsMenuViewUseCase;

  ItemsMenuViewBloc({
    required this.changeItemsMenuViewUseCase,
  }) : super(
    const ItemsViewModeInitState(),
  );

  @override
  Stream<ItemsViewModeState> mapEventToState(ItemsMenuViewEvent event) async* {
    if (event is ChangeViewMode) {
      final changeViewModeResult =
          await changeItemsMenuViewUseCase.execute(event.currentViewMode);

      yield changeViewModeResult.fold(
        (error) => ItemsViewModeErrorState(message: error.message),
        (changedViewMode) => ItemsViewModeChanged(
          pageViewMode: changedViewMode.pageViewMode,
          iconViewMode: changedViewMode.iconViewMode,
        ),
      );
    }
  }
}
