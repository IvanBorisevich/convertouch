import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/menu_items_view.dart';
import 'package:convertouch/presentation/ui/widgets/search_bar.dart';
import 'package:convertouch/presentation/ui/widgets/secondary_app_bar.dart';
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

    return itemsSelectionBlocBuilder(
      bloc: unitsSelectionBloc,
      builderFunc: (itemsSelectionState) {
        return ConvertouchPage(
          title: itemsSelectionState.singleItemSelectionMode
              ? 'Change Unit'
              : 'Add Units To Conversion',
          secondaryAppBar: SecondaryAppBar(
            child: unitsBlocBuilder(
              bloc: unitsBloc,
              builderFunc: (pageState) {
                return ConvertouchSearchBar(
                  placeholder: "Search units...",
                  pageName: PageName.unitsPageForConversion,
                  viewModeSettingKey: SettingKey.unitsViewMode,
                  onSearchStringChanged: (text) {
                    unitsBloc.add(
                      FetchItems(
                        parentItemId: pageState.parentItemId,
                        searchString: text,
                      ),
                    );
                  },
                  onSearchReset: () {
                    unitsBloc.add(
                      FetchItems(
                        parentItemId: pageState.parentItemId,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          body: ConvertouchMenuItemsView(
            itemsListBloc: unitsBloc,
            pageName: PageName.unitsPageForConversion,
            onItemTap: (unit) {
              if (itemsSelectionState.singleItemSelectionMode) {
                conversionBloc.add(
                  ReplaceConversionItemUnit(
                    newUnit: unit,
                    oldUnitId: itemsSelectionState.selectedId!,
                  ),
                );
                navigationBloc.add(const NavigateBack());
              } else {
                unitsSelectionBloc.add(
                  SelectItem(
                    id: unit.id,
                  ),
                );
              }
            },
            onItemTapForRemoval: null,
            onItemLongPress: null,
            checkedItemIds: itemsSelectionState.markedIds,
            disabledItemIds: itemsSelectionState.excludedIds,
            selectedItemId: itemsSelectionState.selectedId,
            editableItemsVisible: false,
            checkableItemsVisible: true,
            removalModeEnabled: false,
          ),
          floatingActionButton: appBlocBuilder(
            builderFunc: (appState) {
              ConvertouchColorScheme floatingButtonColor =
                  unitsPageFloatingButtonColors[appState.theme]!;

              return ConvertouchFloatingActionButton(
                icon: Icons.check_outlined,
                visible: itemsSelectionState.canMarkedItemsBeSelected,
                onClick: () {
                  conversionBloc.add(
                    AddUnitsToConversion(
                      unitIds: itemsSelectionState.markedIds,
                    ),
                  );
                  navigationBloc.add(const NavigateBack());
                },
                colorScheme: floatingButtonColor,
              );
            },
          ),
        );
      },
    );
  }
}
