import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
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
    final unitDetailsBloc = BlocProvider.of<UnitDetailsBloc>(context);
    final conversionBloc = BlocProvider.of<ConversionBloc>(context);

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
                  customLeadingIcon: itemsSelectionState.showCancelIcon
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
                      unitDetailsBloc.add(
                        GetExistingUnitDetails(
                          unit: unit,
                          unitGroup: unitGroup,
                        ),
                      );
                    },
                    onItemTapForRemoval: (unit) {
                      unitsSelectionBloc.add(
                        SelectSingleItem(
                          id: unit.id,
                        ),
                      );
                    },
                    onItemLongPress: (unit) {
                      if (!itemsSelectionState.showCancelIcon) {
                        unitsSelectionBloc.add(
                          StartItemsMarking(
                            showCancelIcon: true,
                            previouslyMarkedIds: [unit.id],
                            excludedIds: unitsBloc.state.oobIds,
                          ),
                        );
                      }
                    },
                  ),
                  floatingActionButton: itemsSelectionState.showCancelIcon
                      ? ConvertouchFloatingActionButton.removal(
                          visible: itemsSelectionState.markedIds.isNotEmpty,
                          extraLabelText:
                              itemsSelectionState.markedIds.length.toString(),
                          colorScheme: removalButtonColor,
                          onClick: () {
                            unitsBloc.add(
                              RemoveItems(
                                ids: itemsSelectionState.markedIds,
                              ),
                            );
                            conversionBloc.add(
                              RemoveConversionItems(
                                unitIds: itemsSelectionState.markedIds,
                              ),
                            );
                            unitsSelectionBloc.add(
                              const CancelItemsMarking(),
                            );
                          },
                        )
                      : ConvertouchFloatingActionButton.adding(
                          visible: !unitGroup.refreshable &&
                              unitGroup.conversionType !=
                                  ConversionType.formula,
                          onClick: () {
                            unitDetailsBloc.add(
                              GetNewUnitDetails(
                                unitGroup: unitGroup,
                              ),
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
