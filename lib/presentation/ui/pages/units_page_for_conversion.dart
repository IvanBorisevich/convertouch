import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/unit_details_controller.dart';
import 'package:convertouch/presentation/controller/unit_group_details_controller.dart';
import 'package:convertouch/presentation/controller/units_controller.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/menu_items_view.dart';
import 'package:convertouch/presentation/ui/widgets/popup_menu_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageForConversion extends StatefulWidget {
  const ConvertouchUnitsPageForConversion({super.key});

  @override
  State<StatefulWidget> createState() =>
      _ConvertouchUnitsPageForConversionState();
}

class _ConvertouchUnitsPageForConversionState
    extends State<ConvertouchUnitsPageForConversion> {
  late bool _isPopupMenuOpen;

  @override
  void initState() {
    super.initState();
    _isPopupMenuOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    final unitsBloc = BlocProvider.of<UnitsBloc>(context);
    final unitsSelectionBloc = BlocProvider.of<ItemsSelectionBloc>(context);
    final conversionBloc = BlocProvider.of<ConversionBloc>(context);

    return BlocListener<NavigationBloc, NavigationState>(
      listener: (_, navigationState) {
        if (_isPopupMenuOpen) {
          Navigator.of(context).pop();
        }
      },
      child: itemsSelectionBlocBuilder(
        bloc: unitsSelectionBloc,
        builderFunc: (itemsSelectionState) {
          return appBlocBuilder(
            builderFunc: (appState) {
              WidgetColorScheme floatingButtonColor =
                  appColors[appState.theme].unitsPageFloatingButton;
              PageColorScheme pageColors = appColors[appState.theme].page;
              DropdownColorScheme popupColors =
                  appColors[appState.theme].popupMenu;

              return ConvertouchPage(
                title: itemsSelectionState.singleItemSelectionMode
                    ? 'Change Unit'
                    : 'Add To Conversion',
                colors: appColors[appState.theme].page,
                appBarTrailingWidgets: [
                  singleGroupBlocBuilder(
                    builderFunc: (singleGroupState) {
                      UnitGroupModel unitGroup = singleGroupState.unitGroup;

                      return ConvertouchPopupMenu(
                        width: 180,
                        colors: popupColors,
                        customIcon: Icon(
                          Icons.more_vert_rounded,
                          color: pageColors.appBar.foreground.regular,
                        ),
                        onMenuStateChange: (isOpen) {
                          setState(() {
                            _isPopupMenuOpen = isOpen;
                          });
                        },
                        items: [
                          PopupMenuItemModel(
                            text: unitGroup.oob ? 'Group Info' : 'Edit Group',
                            icon: unitGroup.oob
                                ? Icons.info_outline_rounded
                                : Icons.edit_outlined,
                            onTap: () {
                              unitGroupDetailsController.showGroupDetails(
                                context,
                                unitGroup: unitGroup,
                              );
                            },
                          ),
                          !unitGroup.refreshable &&
                                  unitGroup.conversionType !=
                                      ConversionType.formula
                              ? PopupMenuItemModel(
                                  text: 'Add Unit',
                                  icon: Icons.add,
                                  onTap: () {
                                    unitDetailsController.startUnitCreation(
                                      context,
                                      unitGroup: unitGroup,
                                    );
                                  },
                                )
                              : null,
                        ],
                      );
                    },
                  ),
                ],
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
                      conversionController.changeConversionItemUnit(
                        context,
                        currentUnitId: itemsSelectionState.selectedId!,
                        newUnit: unit,
                        recalculationMode: appState.recalculationOnUnitChange,
                      );
                    } else {
                      unitsController.markUnit(context, unitId: unit.id);
                    }
                  },
                ),
                floatingActionButton: ConvertouchFloatingActionButton(
                  icon: Icons.check_outlined,
                  visible: itemsSelectionState.canMarkedItemsBeSelected,
                  onClick: () {
                    conversionController.addUnitsToConversion(
                      context,
                      unitIds: itemsSelectionState.markedIds,
                      conversionHasItems:
                          conversionBloc.state.conversion.hasItems,
                    );
                  },
                  colorScheme: floatingButtonColor,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
