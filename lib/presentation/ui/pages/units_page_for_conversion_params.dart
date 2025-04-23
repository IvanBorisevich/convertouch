import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageForConversionParams extends StatelessWidget {
  const ConvertouchUnitsPageForConversionParams({super.key});

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
          title: 'Change Unit Of Parameter',
          body: singleParamBlocBuilder(
            builderFunc: (singleParamState) {
              return ConvertouchMenuItemsView(
                itemsListBloc: unitsBloc,
                pageName: PageName.unitsPageForConversionParams,
                viewModeSettingKey: SettingKey.unitsViewMode,
                searchBarPlaceholder: "Search units...",
                onItemTap: (unit) {
                  if (singleParamState.param != null) {
                    conversionBloc.add(
                      ReplaceConversionParamUnit(
                        newUnit: unit,
                        paramId: singleParamState.param!.id,
                        paramSetId: singleParamState.param!.paramSetId,
                      ),
                    );
                  }
                  navigationBloc.add(const NavigateBack());
                },
                onItemTapForRemoval: null,
                onItemLongPress: null,
                checkedItemIds: itemsSelectionState.markedIds,
                disabledItemIds: itemsSelectionState.excludedIds,
                selectedItemId: itemsSelectionState.selectedId,
                editableItemsVisible: false,
                checkableItemsVisible: true,
                checkIconVisibleIfUnchecked: true,
                removalModeEnabled: false,
              );
            },
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
