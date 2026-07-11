import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/refresh_button/refresh_button_bloc.dart';
import 'package:convertouch/presentation/bloc/common/refresh_button/refresh_button_states.dart';
import 'package:convertouch/presentation/bloc/common/sliding_panel_bloc/sliding_panel_bloc.dart';
import 'package:convertouch/presentation/bloc/common/sliding_panel_bloc/sliding_panel_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/groups_controller.dart';
import 'package:convertouch/presentation/controller/param_sets_controller.dart';
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

class ConvertouchConversionPage extends StatelessWidget {
  const ConvertouchConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder(
      builderFunc: (appState) {
        PageColorScheme pageColors = appColors[appState.theme].page;
        DropdownColorScheme popupColors = appColors[appState.theme].popupMenu;
        WidgetColorScheme floatingButtonColor =
            appColors[appState.theme].conversionPageFloatingButton;

        return ConvertouchPage(
          titleWidget: singleGroupBlocBuilder(
            builderFunc: (singleGroupState) {
              return Text(
                singleGroupState.unitGroup.name,
                style: TextStyle(
                  color: pageColors.appBar.foreground.regular,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
          colors: pageColors,
          appBarTrailingWidgets: [
            singleGroupBlocBuilder(
              builderFunc: (singleGroupState) {
                return BlocBuilder<ConversionBloc, ConversionState>(
                  buildWhen: (prev, next) =>
                      prev != next &&
                      next is ConversionBuilt &&
                      next.conversion.unitGroup.id ==
                          singleGroupState.unitGroup.id,
                  builder: (_, conversionState) {
                    if (conversionState is! ConversionBuilt ||
                        conversionState.conversion.params == null) {
                      return const SizedBox.shrink();
                    }

                    return IconButton(
                      icon: IconUtils.getParamSetIcon(
                        color: pageColors.appBar.foreground.regular,
                        size: 22,
                      ),
                      onPressed: () {
                        BlocProvider.of<SlidingPanelBloc>(context).add(
                          const SwitchSlidingPanel(),
                        );
                      },
                    );
                  },
                );
              },
            ),
            singleGroupBlocBuilder(
              builderFunc: (singleGroupState) {
                return BlocBuilder<ConversionBloc, ConversionState>(
                  buildWhen: (prev, next) =>
                      prev != next &&
                      next is ConversionBuilt &&
                      next.conversion.unitGroup.id ==
                          singleGroupState.unitGroup.id,
                  builder: (_, conversionState) {
                    if (conversionState is! ConversionBuilt) {
                      return const SizedBox.shrink();
                    }

                    final conversion = conversionState.conversion;
                    bool paramsCanBeAdded = conversion.params != null &&
                        conversion.params!.paramSetsCanBeAdded;
                    bool paramsCanBeRemoved = conversion.params != null &&
                        conversion.params!.optionalParamSetsExist;
                    bool paramsOptionsExist =
                        paramsCanBeAdded || paramsCanBeRemoved;
                    List<int> addedParamSetIds = conversion
                            .params?.paramSetValues
                            .map((item) => item.paramSet.id)
                            .toList() ??
                        [];

                    return ConvertouchPopupMenu(
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
                                    unitGroupId: conversion.unitGroup.id,
                                    addedParamSetIds: addedParamSetIds,
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
                                  conversionController.removeOptionalParamSets(
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
                            groupsController.showGroup(
                              context,
                              unitGroup: conversion.unitGroup,
                            );

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
                            conversionController.cleanupConversion(
                              context,
                              preserveParams:
                                  appState.keepParamsOnConversionCleanup,
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          body: Container(
            color: Colors.transparent,
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: Column(
                children: [
                  singleGroupBlocBuilder(
                    builderFunc: (singleGroupState) {
                      return ConversionParamsView(
                        unitGroupId: singleGroupState.unitGroup.id,
                        theme: appState.theme,
                      );
                    },
                  ),
                  Expanded(
                    child: singleGroupBlocBuilder(
                      builderFunc: (singleGroupState) {
                        return ConvertouchConversionItemsView(
                          unitGroupId: singleGroupState.unitGroup.id,
                          unitTapAction: appState.unitTapAction,
                          theme: appState.theme,
                        );
                      },
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
              singleGroupBlocBuilder(
                builderFunc: (singleGroupState) {
                  return BlocBuilder<RefreshButtonBloc, RefreshButtonState>(
                    buildWhen: (prev, next) =>
                        prev != next &&
                        next.unitGroupId == singleGroupState.unitGroup.id,
                    builder: (_, refreshButtonState) {
                      return ConvertouchRefreshFloatingButton(
                        visible: refreshButtonState.visible,
                        disabled: refreshButtonState.disabled,
                        theme: appState.theme,
                      );
                    },
                  );
                },
              ),
              singleGroupBlocBuilder(
                builderFunc: (singleGroupState) {
                  return BlocBuilder<ConversionBloc, ConversionState>(
                    buildWhen: (prev, next) =>
                        prev != next &&
                        next is ConversionBuilt &&
                        next.conversion.unitGroup.id ==
                            singleGroupState.unitGroup.id,
                    builder: (_, conversionState) {
                      if (conversionState is! ConversionBuilt) {
                        return const SizedBox.shrink();
                      }

                      return ConvertouchFloatingActionButton.adding(
                        onClick: () {
                          unitsController.showUnitsForAdding(
                            context,
                            groupId: conversionState.conversion.unitGroup.id,
                            addedUnitIds: conversionState
                                .conversion.convertedUnitValues
                                .map((item) => item.unit.id)
                                .toList(),
                            paramsApplicable: areParamsApplicable(
                              conversionState.conversion.params?.active,
                            ),
                          );
                        },
                        colorScheme: floatingButtonColor,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
