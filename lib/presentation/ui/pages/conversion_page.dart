import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/param_sets_controller.dart';
import 'package:convertouch/presentation/controller/unit_details_controller.dart';
import 'package:convertouch/presentation/controller/unit_group_details_controller.dart';
import 'package:convertouch/presentation/controller/units_controller.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/conversion_items_view.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/conversion_params_view.dart';
import 'package:convertouch/presentation/ui/widgets/popup_menu_ext.dart';
import 'package:convertouch/presentation/ui/widgets/refresh_button.dart';
import 'package:convertouch/presentation/ui/widgets/scroll/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ConvertouchConversionPage extends StatefulWidget {
  const ConvertouchConversionPage({super.key});

  @override
  State<StatefulWidget> createState() => _ConvertouchConversionPageState();
}

class _ConvertouchConversionPageState extends State<ConvertouchConversionPage> {
  late bool _isPopupMenuOpen;
  late PanelController _panelController;

  @override
  void initState() {
    super.initState();
    _isPopupMenuOpen = false;
    _panelController = PanelController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationBloc, NavigationState>(
      listener: (_, navigationState) {
        if (_isPopupMenuOpen) {
          Navigator.of(context).pop();
        }
      },
      child: appBlocBuilder(
        builderFunc: (appState) {
          PageColorScheme pageColors = appColors[appState.theme].page;
          DropdownColorScheme popupColors = appColors[appState.theme].popupMenu;

          WidgetColorScheme floatingButtonColor =
              appColors[appState.theme].conversionPageFloatingButton;

          return singleGroupBlocBuilder(
            builderFunc: (singleGroupState) {
              UnitGroupModel unitGroup = singleGroupState.unitGroup;

              return ConvertouchPage(
                title: unitGroup.name,
                colors: pageColors,
                appBarTrailingWidgets: [
                  conversionBlocBuilder(
                    builderFunc: (pageState) {
                      return Visibility(
                        visible: pageState.conversion.params != null,
                        child: IconButton(
                          icon: IconUtils.getIcon(
                            IconNames.parameters,
                            color: pageColors.appBar.foreground.regular,
                            size: 22,
                          ),
                          onPressed: () {
                            if (_panelController.isAttached) {
                              if (_panelController.isPanelClosed) {
                                _panelController.open();
                              } else {
                                _panelController.close();
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                  conversionBlocBuilder(
                    builderFunc: (pageState) {
                      bool paramsCanBeAdded =
                          pageState.conversion.params != null &&
                              pageState.conversion.params!.paramSetsCanBeAdded;
                      bool paramsCanBeRemoved = pageState.conversion.params !=
                              null &&
                          pageState.conversion.params!.optionalParamSetsExist;
                      bool paramsOptionsExist =
                          paramsCanBeAdded || paramsCanBeRemoved;

                      return ConvertouchPopupMenu(
                        width: 230,
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
                          paramsCanBeAdded
                              ? PopupMenuItemModel(
                                  text: 'Add Parameters',
                                  icon: Icons.add,
                                  onTap: () {
                                    paramSetsController.showParametersForAdding(
                                      context,
                                      groupId: unitGroup.id,
                                      params: pageState.conversion.params,
                                    );
                                  },
                                )
                              : null,
                          paramsCanBeRemoved
                              ? PopupMenuItemModel(
                                  text: 'Remove Parameters',
                                  icon: Icons.delete_outline_rounded,
                                  iconColor: popupColors.removalItem.regular,
                                  textColor: popupColors.removalItem.regular,
                                  onTap: () {
                                    conversionController.removeOptionalParams(
                                      context,
                                    );
                                  },
                                )
                              : null,
                          paramsOptionsExist
                              ? PopupMenuItemModel.divider
                              : null,
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
                          PopupMenuItemModel(
                            text: "Units Dictionary",
                            icon: Icons.dashboard_customize_outlined,
                            onTap: () {
                              unitsController.showUnits(
                                context,
                                groupId: unitGroup.id,
                              );
                            },
                          ),
                          PopupMenuItemModel(
                            text: "Clear Conversion",
                            icon: Icons.delete_outline_rounded,
                            iconColor: popupColors.removalItem.regular,
                            textColor: popupColors.removalItem.regular,
                            onTap: () {
                              conversionController.clearConversion(
                                context,
                                preserveParams:
                                    appState.keepParamsOnConversionCleanup,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
                body: Container(
                  color: Colors.transparent,
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: conversionBlocBuilder(
                      builderFunc: (pageState) {
                        final conversion = pageState.conversion;

                        return Column(
                          children: [
                            ConversionParamsView(
                              panelController: _panelController,
                              params: conversion.params,
                              colors: appColors[appState.theme].paramSetPanel,
                              onParamSetAdd: () {
                                paramSetsController.showParametersForAdding(
                                  context,
                                  groupId: unitGroup.id,
                                  params: conversion.params,
                                );
                              },
                              onParamSetSelect: (newIndex) {
                                conversionController.showParamSet(
                                  context,
                                  index: newIndex,
                                );
                              },
                              onParamUnitTap: (paramValue) {
                                unitsController.showUnitsForChangeInParam(
                                  context,
                                  paramValue: paramValue,
                                );
                              },
                              onValueChanged: (paramValue, newValue) {
                                conversionController.changeParamValue(
                                  context,
                                  paramValue: paramValue,
                                  newValue: newValue,
                                );
                              },
                              onSelectedParamSetRemove: () {
                                conversionController.removeSelectedParamSet(
                                  context,
                                );
                              },
                            ),
                            Expanded(
                              child: ConvertouchConversionItemsView(
                                conversion.convertedUnitValues,
                                sourceUnitId: conversion.srcUnitValue?.unit.id,
                                onUnitItemTap: (item) {
                                  if (appState.unitTapAction ==
                                      UnitTapAction.selectReplacingUnit) {
                                    unitsController
                                        .showUnitsForChangeInConversionItem(
                                      context,
                                      groupId: conversion.unitGroup.id,
                                      currentUnitId: item.unit.id,
                                      excludedUnitIds: conversion
                                          .convertedUnitValues
                                          .map((e) => e.unit.id)
                                          .whereNot((id) => id == item.unit.id)
                                          .toList(),
                                    );
                                  } else if (appState.unitTapAction ==
                                      UnitTapAction.showUnitInfo) {
                                    unitDetailsController.showUnitDetails(
                                      context,
                                      unit: item.unit,
                                      unitGroup: unitGroup,
                                    );
                                  }
                                },
                                onValueChanged: (item, value) {
                                  conversionController
                                      .changeConversionItemValue(
                                    context,
                                    unitId: item.unit.id,
                                    newValue: value,
                                  );
                                },
                                onItemRemoveTap: (item) {
                                  conversionController.removeConversionItem(
                                    context,
                                    unitId: item.unit.id,
                                  );
                                },
                                theme: appState.theme,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                floatingActionButton: conversionBlocBuilder(
                  builderFunc: (pageState) {
                    final conversion = pageState.conversion;

                    return Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      alignment: WrapAlignment.end,
                      children: [
                        pageState.showRefreshButton
                            ? ConvertouchRefreshFloatingButton(
                                unitGroupName: unitGroup.name,
                                params: conversion.params!.active!,
                              )
                            : const SizedBox.shrink(),
                        ConvertouchFloatingActionButton.adding(
                          onClick: () {
                            unitsController.showUnitsForAdding(
                              context,
                              groupId: unitGroup.id,
                              addedUnitIds: conversion.convertedUnitValues
                                  .map((unitValue) => unitValue.unit.id)
                                  .toList(),
                              markedItemsSelectionMinNum:
                                  minimumNumberOfConversionItems,
                            );
                          },
                          colorScheme: floatingButtonColor,
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
