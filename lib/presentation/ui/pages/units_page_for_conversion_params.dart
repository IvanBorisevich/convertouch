import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/menu_items_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageForConversionParams extends StatelessWidget {
  const ConvertouchUnitsPageForConversionParams({super.key});

  @override
  Widget build(BuildContext context) {
    final unitsBloc = BlocProvider.of<UnitsBloc>(context);
    final unitsSelectionBloc = BlocProvider.of<ItemsSelectionBloc>(context);

    return itemsSelectionBlocBuilder(
      bloc: unitsSelectionBloc,
      builderFunc: (itemsSelectionState) {
        return appBlocBuilder(
          builderFunc: (appState) {
            return ConvertouchPage(
              title: 'Change Unit Of Parameter',
              colors: appColors[appState.theme].page,
              body: singleParamBlocBuilder(
                builderFunc: (singleParamState) {
                  return ConvertouchMenuItemsView(
                    itemsListBloc: unitsBloc,
                    pageName: PageName.unitsPageForConversionParams,
                    viewModeSettingKey: SettingKey.unitsViewMode,
                    searchBarPlaceholder: "Search units...",
                    noItemsLabel: 'No units',
                    colors: appColors[appState.theme].unitsMenu,
                    itemsViewMode: appState.unitsViewMode,
                    onItemTapForRemoval: null,
                    onItemLongPress: null,
                    checkedItemIds: itemsSelectionState.markedIds,
                    disabledItemIds: itemsSelectionState.excludedIds,
                    selectedItemId: itemsSelectionState.selectedId,
                    editableItemsVisible: false,
                    checkableItemsVisible: true,
                    checkIconVisibleIfUnchecked: true,
                    removalModeEnabled: false,
                    onItemTap: (unit) {
                      conversionController.changeParamUnit(
                        context,
                        param: singleParamState.param,
                        newUnit: unit,
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
