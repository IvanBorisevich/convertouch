import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/menu_items_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageForConversion extends StatelessWidget {
  const ConvertouchUnitsPageForConversion({super.key});

  @override
  Widget build(BuildContext context) {
    final unitsBloc = BlocProvider.of<UnitsBloc>(context);
    final unitsSelectionBloc = BlocProvider.of<ItemsSelectionBloc>(context);
    final conversionBloc = BlocProvider.of<ConversionBloc>(context);
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);
    final appBloc = BlocProvider.of<AppBloc>(context);

    return itemsSelectionBlocBuilder(
      bloc: unitsSelectionBloc,
      builderFunc: (itemsSelectionState) {
        return appBlocBuilder(
          builderFunc: (appState) {
            WidgetColorScheme floatingButtonColor =
                appColors[appState.theme].unitsPageFloatingButton;

            return ConvertouchPage(
              title: itemsSelectionState.singleItemSelectionMode
                  ? 'Change Unit'
                  : 'Add To Conversion',
              colors: appColors[appState.theme].page,
              body: ConvertouchMenuItemsView(
                itemsListBloc: unitsBloc,
                pageName: PageName.unitsPageForConversion,
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
                  if (itemsSelectionState.singleItemSelectionMode) {
                    conversionBloc.add(
                      ReplaceConversionItemUnit(
                        newUnit: unit,
                        oldUnitId: itemsSelectionState.selectedId!,
                        recalculationMode:
                            appBloc.state.recalculationOnUnitChange,
                      ),
                    );
                    navigationBloc.add(const NavigateBack());
                  } else {
                    unitsSelectionBloc.add(
                      SelectSingleItem(
                        id: unit.id,
                      ),
                    );
                  }
                },
              ),
              floatingActionButton: ConvertouchFloatingActionButton(
                icon: Icons.check_outlined,
                visible: itemsSelectionState.canMarkedItemsBeSelected,
                onClick: () {
                  conversionBloc.add(
                    AddUnitsToConversion(
                      unitIds: itemsSelectionState.markedIds,
                    ),
                  );
                  if (conversionBloc.state.conversion.hasItems) {
                    navigationBloc.add(const NavigateBack());
                  } else {
                    navigationBloc.add(
                      const NavigateToPage(
                        pageName: PageName.conversionPage,
                        replace: true,
                      ),
                    );
                  }
                },
                colorScheme: floatingButtonColor,
              ),
            );
          },
        );
      },
    );
  }
}
