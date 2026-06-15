import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/param_sets_controller.dart';
import 'package:convertouch/presentation/controller/refresh_button_controller.dart';
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
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../controller/refreshing_job_controller.dart';

class ConvertouchConversionPage extends StatefulWidget {
  const ConvertouchConversionPage({super.key});

  @override
  State<StatefulWidget> createState() => _ConvertouchConversionPageState();
}

class _ConvertouchConversionPageState extends State<ConvertouchConversionPage> {
  late PanelController _panelController;

  @override
  void initState() {
    super.initState();
    _panelController = PanelController();
  }

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder(
      builderFunc: (appState) {
        PageColorScheme pageColors = appColors[appState.theme].page;
        DropdownColorScheme popupColors = appColors[appState.theme].popupMenu;

        WidgetColorScheme floatingButtonColor =
            appColors[appState.theme].conversionPageFloatingButton;

        return conversionBlocBuilder(
          builderFunc: (pageState) {
            final conversion = pageState.conversion;

            bool paramsCanBeAdded = conversion.params != null &&
                conversion.params!.paramSetsCanBeAdded;
            bool paramsCanBeRemoved = conversion.params != null &&
                conversion.params!.optionalParamSetsExist;
            bool paramsOptionsExist = paramsCanBeAdded || paramsCanBeRemoved;

            return ConvertouchPage(
              title: conversion.unitGroup.name,
              colors: pageColors,
              appBarTrailingWidgets: [
                Visibility(
                  visible: conversion.params != null,
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
                ),
                ConvertouchPopupMenu(
                  width: 230,
                  colors: popupColors,
                  customIcon: Icon(
                    Icons.more_vert_rounded,
                    color: pageColors.appBar.foreground.regular,
                  ),
                  items: [
                    paramsCanBeAdded
                        ? PopupMenuItemModel(
                            text: 'Add Parameters',
                            icon: Icons.add,
                            onTap: () {
                              paramSetsController.showParametersForAdding(
                                context,
                                conversion: conversion,
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
                    paramsOptionsExist ? PopupMenuItemModel.divider : null,
                    PopupMenuItemModel(
                      text: conversion.unitGroup.oob
                          ? 'Group Info'
                          : 'Edit Group',
                      icon: conversion.unitGroup.oob
                          ? Icons.info_outline_rounded
                          : Icons.edit_outlined,
                      onTap: () {
                        unitGroupDetailsController.showGroupDetails(
                          context,
                          unitGroup: conversion.unitGroup,
                        );
                      },
                    ),
                    PopupMenuItemModel(
                      text: "Units Dictionary",
                      icon: Icons.dashboard_customize_outlined,
                      onTap: () {
                        unitsController.showUnits(
                          context,
                          groupId: conversion.unitGroup.id,
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
                ),
              ],
              body: Container(
                color: Colors.transparent,
                child: ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: Column(
                    children: [
                      ConversionParamsView(
                        params: conversion.params,
                        unitGroupName: conversion.unitGroup.name,
                        panelController: _panelController,
                        colors: appColors[appState.theme].paramSetPanel,
                        dialogColors: appColors[appState.theme].dialog,
                        onParamSetAdd: () {
                          paramSetsController.showParametersForAdding(
                            context,
                            conversion: conversion,
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
                            onChanged: (newConversion, {info}) {
                              refreshButtonController.changeState(
                                context,
                                visible: newConversion.refreshable,
                                disabled: !newConversion.readyToRefresh,
                              );

                              if (newConversion.refreshable &&
                                  newConversion.readyToRefresh) {
                                refreshingJobController.startRefreshingJob(
                                  context,
                                  conversion: newConversion,
                                  jobExecutionMode:
                                      JobExecutionMode.startNewJob,
                                );
                              } else {
                                refreshingJobController.stopRefreshingJob(
                                  context,
                                  conversion: newConversion,
                                );
                              }
                            },
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
                                currentUnitId: item.unit.id,
                                conversion: conversion,
                              );
                            } else if (appState.unitTapAction ==
                                UnitTapAction.showUnitInfo) {
                              unitDetailsController.showUnitDetails(
                                context,
                                unit: item.unit,
                                unitGroup: conversion.unitGroup,
                              );
                            }
                          },
                          onValueChanged: (item, value) {
                            conversionController.changeConversionItemValue(
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
                  ),
                ),
              ),
              floatingActionButton: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                alignment: WrapAlignment.end,
                children: [
                  refreshButtonBlocBuilder(
                    builderFunc: (refreshButtonState) {
                      return ConvertouchRefreshFloatingButton(
                        conversion: conversion,
                        visible: refreshButtonState.visible,
                        disabled: refreshButtonState.disabled,
                        onFetchSuccess: (jobResult) {
                          if (jobResult.data != null) {
                            conversionController.updateWithDynamicData(
                              context,
                              data: jobResult.data!,
                            );
                          }
                        },
                      );
                    },
                  ),
                  ConvertouchFloatingActionButton.adding(
                    onClick: () {
                      unitsController.showUnitsForAdding(
                        context,
                        groupId: conversion.unitGroup.id,
                        conversion: conversion,
                      );
                    },
                    colorScheme: floatingButtonColor,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
