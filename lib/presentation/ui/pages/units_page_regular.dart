import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/unit_details_controller.dart';
import 'package:convertouch/presentation/controller/units_controller.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/cancel_items_selection_icon.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/menu_items_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageRegular extends StatelessWidget {
  const ConvertouchUnitsPageRegular({super.key});

  @override
  Widget build(BuildContext context) {
    final unitsBloc = BlocProvider.of<UnitsBloc>(context);
    final unitsSelectionBloc = BlocProvider.of<ItemsSelectionBloc>(context);

    return itemsSelectionBlocBuilder(
      bloc: unitsSelectionBloc,
      builderFunc: (itemsSelectionState) {
        return singleGroupBlocBuilder(
          builderFunc: (singleGroupState) {
            UnitGroupModel unitGroup = singleGroupState.unitGroup;

            return appBlocBuilder(
              builderFunc: (appState) {
                WidgetColorScheme floatingButtonColor =
                    appColors[appState.theme].unitsPageFloatingButton;
                WidgetColorScheme removalButtonColor =
                    appColors[appState.theme].removalFloatingButton;

                return ConvertouchPage(
                  title: "${unitGroup.name} units",
                  colors: appColors[appState.theme].page,
                  appBarLeadingWidget: itemsSelectionState.showCancelIcon
                      ? CancelItemsSelectionIcon(
                          bloc: unitsSelectionBloc,
                        )
                      : null,
                  body: ConvertouchMenuItemsView(
                    itemsListBloc: unitsBloc,
                    pageName: PageName.unitsPageRegular,
                    viewModeSettingKey: SettingKey.unitsViewMode,
                    checkedItemIds: itemsSelectionState.markedIds,
                    searchBarPlaceholder: "Search units...",
                    noItemsLabel: 'No units',
                    colors: appColors[appState.theme].unitsMenu,
                    itemsViewMode: appState.unitsViewMode,
                    selectedItemId: null,
                    disabledItemIds: const [],
                    removalModeEnabled: itemsSelectionState.showCancelIcon,
                    checkableItemsVisible: itemsSelectionState.showCancelIcon,
                    editableItemsVisible: true,
                    onItemTap: (unit) {
                      unitDetailsController.showUnitDetails(
                        context,
                        unit: unit,
                        unitGroup: unitGroup,
                      );
                    },
                    onItemTapForRemoval: (unit) {
                      unitsController.markUnit(context, unitId: unit.id);
                    },
                    onItemLongPress: (unit) {
                      unitsController.startRemoval(
                        context,
                        showCancelIcon: true,
                        unitId: unit.id,
                        oobIds: unitsBloc.state.oobIds,
                      );
                    },
                  ),
                  floatingActionButton: itemsSelectionState.showCancelIcon
                      ? ConvertouchFloatingActionButton.removal(
                          visible: itemsSelectionState.markedIds.isNotEmpty,
                          extraLabelText:
                              itemsSelectionState.markedIds.length.toString(),
                          colorScheme: removalButtonColor,
                          onClick: () {
                            unitsController.remove(
                              context,
                              unitIds: itemsSelectionState.markedIds,
                              onSuccess: () {
                                conversionController.removeConversionItems(
                                  context,
                                  unitIds: itemsSelectionState.markedIds,
                                );
                              },
                            );
                          },
                        )
                      : ConvertouchFloatingActionButton.adding(
                          visible: !unitGroup.refreshable &&
                              unitGroup.conversionType !=
                                  ConversionType.formula,
                          onClick: () {
                            unitDetailsController.startUnitCreation(
                              context,
                              unitGroup: unitGroup,
                            );
                          },
                          colorScheme: floatingButtonColor,
                        ),
                );
              },
            );
          },
        );
      },
    );
  }
}
