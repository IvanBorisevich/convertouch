import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/conversion_param_sets_page/conversion_param_sets_bloc.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/menu_items_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversionParamSetsPage extends StatelessWidget {
  const ConversionParamSetsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final paramSetsBloc = BlocProvider.of<ConversionParamSetsBloc>(context);
    final paramSetsSelectionBloc = BlocProvider.of<ItemsSelectionBloc>(context);
    final conversionBloc = BlocProvider.of<ConversionBloc>(context);
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return itemsSelectionBlocBuilder(
      bloc: paramSetsSelectionBloc,
      builderFunc: (itemsSelectionState) {
        return singleGroupBlocBuilder(
          builderFunc: (singleGroupState) {
            return ConvertouchPage(
              title: 'Add Parameters',
              body: ConvertouchMenuItemsView(
                itemsListBloc: paramSetsBloc,
                pageName: PageName.paramSetsPage,
                viewModeSettingKey: SettingKey.paramSetsViewMode,
                searchBarPlaceholder: "Search parameters...",
                onItemTap: (paramSet) {
                  paramSetsSelectionBloc.add(
                    SelectSingleItem(
                      id: paramSet.id,
                    ),
                  );
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
              ),
              floatingActionButton: appBlocBuilder(
                builderFunc: (appState) {
                  ConvertouchColorScheme floatingButtonColor =
                      paramSetsPageFloatingButtonColors[appState.theme]!;

                  return ConvertouchFloatingActionButton(
                    icon: Icons.check_outlined,
                    visible: itemsSelectionState.canMarkedItemsBeSelected,
                    onClick: () {
                      conversionBloc.add(
                        AddParamSetsToConversion(
                          paramSetIds: itemsSelectionState.markedIds,
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
      },
    );
  }
}
