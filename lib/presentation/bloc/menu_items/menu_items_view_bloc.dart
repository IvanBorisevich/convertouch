import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/use_cases/item_view_mode/get_next_item_view_mode_use_case.dart';
import 'package:convertouch/domain/use_cases/settings/get_settings_use_case.dart';
import 'package:convertouch/domain/use_cases/settings/save_settings_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/menu_items/menu_items_view_event.dart';
import 'package:convertouch/presentation/bloc/menu_items/menu_items_view_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MenuViewModeBloc
    extends ConvertouchBloc<MenuItemsViewEvent, MenuItemsViewState> {
  final GetNextItemViewModeUseCase getNextItemViewModeUseCase;
  final GetSettingsUseCase getSettingsUseCase;
  final SaveSettingsUseCase saveSettingsUseCase;

  MenuViewModeBloc({
    required this.getNextItemViewModeUseCase,
    required this.getSettingsUseCase,
    required this.saveSettingsUseCase,
  }) : super(const MenuItemsViewInitialState()) {
    on<ChangeMenuItemsView>(_onMenuItemViewChange);
    on<RestoreViewModeSettings>(_onViewModeSettingRestore);
  }

  _onMenuItemViewChange(
    ChangeMenuItemsView event,
    Emitter<MenuItemsViewState> emit,
  ) async {
    emit(const MenuItemsViewStateSetting());

    final result =
        await getNextItemViewModeUseCase.execute(event.targetViewMode);

    if (result.isLeft) {
      emit(
        MenuItemsViewErrorState(
          exception: result.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      ItemsViewMode pageViewMode = result.right.currentMode;
      ItemsViewMode iconViewMode = result.right.nextMode;

      await saveSettingsUseCase.execute({
        getPageViewModeKey(): pageViewMode.value,
        getIconViewModeKey(): iconViewMode.value,
      });

      emit(
        MenuItemsViewStateSet(
          pageViewMode: pageViewMode,
          iconViewMode: iconViewMode,
        ),
      );
    }
  }

  _onViewModeSettingRestore(
    RestoreViewModeSettings event,
    Emitter<MenuItemsViewState> emit,
  ) async {
    final result = await getSettingsUseCase.execute([
      getPageViewModeKey(),
      getIconViewModeKey(),
    ]);

    emit(
      result.fold(
        (error) => MenuItemsViewErrorState(
          exception: result.left,
          lastSuccessfulState: state,
        ),
        (viewModesMap) => MenuItemsViewStateSet(
          pageViewMode: ItemsViewMode.valueOf(
                viewModesMap[getPageViewModeKey()],
              ) ??
              ItemsViewMode.grid,
          iconViewMode: ItemsViewMode.valueOf(
                viewModesMap[getIconViewModeKey()],
              ) ??
              ItemsViewMode.list,
        ),
      ),
    );
  }

  String getPageViewModeKey();

  String getIconViewModeKey();
}

class UnitGroupsViewModeBloc extends MenuViewModeBloc {
  UnitGroupsViewModeBloc({
    required super.getNextItemViewModeUseCase,
    required super.getSettingsUseCase,
    required super.saveSettingsUseCase,
  });

  @override
  String getIconViewModeKey() => SettingKeys.unitGroupsIconViewMode;

  @override
  String getPageViewModeKey() => SettingKeys.unitGroupsPageViewMode;
}

class UnitsViewModeBloc extends MenuViewModeBloc {
  UnitsViewModeBloc({
    required super.getNextItemViewModeUseCase,
    required super.getSettingsUseCase,
    required super.saveSettingsUseCase,
  });

  @override
  String getIconViewModeKey() => SettingKeys.unitsIconViewMode;

  @override
  String getPageViewModeKey() => SettingKeys.unitsPageViewMode;
}
