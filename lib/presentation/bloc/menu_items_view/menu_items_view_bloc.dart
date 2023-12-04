import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/usecases/items_menu_view_mode/change_items_menu_view_use_case.dart';
import 'package:convertouch/presentation/bloc/menu_items_view/menu_items_view_event.dart';
import 'package:convertouch/presentation/bloc/menu_items_view/menu_items_view_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupsViewModeBloc extends Bloc<MenuItemsViewEvent, MenuItemsViewState> {
  final ChangeItemsMenuViewUseCase changeItemsMenuViewUseCase;

  UnitGroupsViewModeBloc({
    required this.changeItemsMenuViewUseCase,
  }) : super(const MenuItemsViewStateSet(
          pageViewMode: ItemsViewMode.grid,
          iconViewMode: ItemsViewMode.list,
        ));

  @override
  Stream<MenuItemsViewState> mapEventToState(MenuItemsViewEvent event) async* {
    if (event is ChangeMenuItemsView) {
      yield const MenuItemsViewStateSetting();

      final result =
      await changeItemsMenuViewUseCase.execute(event.targetViewMode);

      yield result.fold(
            (error) => MenuItemsViewErrorState(message: error.message),
            (changedViewMode) => MenuItemsViewStateSet(
          pageViewMode: changedViewMode.pageViewMode,
          iconViewMode: changedViewMode.iconViewMode,
        ),
      );
    }
  }
}

class UnitsViewModeBloc extends Bloc<MenuItemsViewEvent, MenuItemsViewState> {
  final ChangeItemsMenuViewUseCase changeItemsMenuViewUseCase;

  UnitsViewModeBloc({
    required this.changeItemsMenuViewUseCase,
  }) : super(const MenuItemsViewStateSet(
    pageViewMode: ItemsViewMode.grid,
    iconViewMode: ItemsViewMode.list,
  ));

  @override
  Stream<MenuItemsViewState> mapEventToState(MenuItemsViewEvent event) async* {
    if (event is ChangeMenuItemsView) {
      yield const MenuItemsViewStateSetting();

      final result =
      await changeItemsMenuViewUseCase.execute(event.targetViewMode);

      yield result.fold(
            (error) => MenuItemsViewErrorState(message: error.message),
            (changedViewMode) => MenuItemsViewStateSet(
          pageViewMode: changedViewMode.pageViewMode,
          iconViewMode: changedViewMode.iconViewMode,
        ),
      );
    }
  }
}


// Stream<MenuItemsViewState> _mapEventToState(
//   MenuItemsViewEvent event,
//   final ChangeItemsMenuViewUseCase changeItemsMenuViewUseCase,
// ) async* {
//
// }
