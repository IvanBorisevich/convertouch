import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/sliding_panel_bloc/sliding_panel_bloc.dart';
import 'package:convertouch/presentation/bloc/common/sliding_panel_bloc/sliding_panel_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/groups_controller.dart';
import 'package:convertouch/presentation/controller/param_sets_controller.dart';
import 'package:convertouch/presentation/controller/unit_group_details_controller.dart';
import 'package:convertouch/presentation/controller/units_controller.dart';
import 'package:convertouch/presentation/ui/model/add_units_button_view_model.dart';
import 'package:convertouch/presentation/ui/model/conversion_popup_menu_view_model.dart';
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
            BlocSelector<ConversionBloc, ConversionState, bool>(
              selector: (state) {
                return state is ConversionBuilt &&
                    state.conversion.params != null;
              },
              builder: (_, paramsExist) {
                return paramsExist
                    ? IconButton(
                        icon: IconUtils.getIcon(
                          IconNames.parameters,
                          color: pageColors.appBar.foreground.regular,
                          size: 22,
                        ),
                        onPressed: () {
                          BlocProvider.of<SlidingPanelBloc>(context).add(
                            const SwitchSlidingPanel(),
                          );
                        },
                      )
                    : const SizedBox.shrink();
              },
            ),
            BlocSelector<ConversionBloc, ConversionState,
                ConversionPopupMenuViewModel?>(
              selector: (state) {
                if (state is ConversionBuilt) {
                  final conversion = state.conversion;
                  bool paramsCanBeAdded = conversion.params != null &&
                      conversion.params!.paramSetsCanBeAdded;
                  bool paramsCanBeRemoved = conversion.params != null &&
                      conversion.params!.optionalParamSetsExist;
                  bool paramsOptionsExist =
                      paramsCanBeAdded || paramsCanBeRemoved;
                  List<int> addedParamSetIds = conversion.params?.paramSetValues
                          .map((item) => item.paramSet.id)
                          .toList() ??
                      [];

                  return ConversionPopupMenuViewModel(
                    paramsCanBeAdded: paramsCanBeAdded,
                    paramsCanBeRemoved: paramsCanBeRemoved,
                    paramsOptionsExist: paramsOptionsExist,
                    addedParamSetIds: addedParamSetIds,
                    unitGroup: conversion.unitGroup,
                  );
                }

                return null;
              },
              builder: (_, popupViewModel) {
                if (popupViewModel == null) {
                  return const SizedBox.shrink();
                }

                return ConvertouchPopupMenu(
                  width: 230,
                  colors: popupColors,
                  customIcon: Icon(
                    Icons.more_vert_rounded,
                    color: pageColors.appBar.foreground.regular,
                  ),
                  items: [
                    popupViewModel.paramsCanBeAdded
                        ? PopupMenuItemModel(
                            text: 'Add Parameters',
                            icon: Icons.add,
                            onTap: () {
                              paramSetsController.showParametersForAdding(
                                context,
                                unitGroupId: popupViewModel.unitGroup.id,
                                addedParamSetIds:
                                    popupViewModel.addedParamSetIds,
                              );
                            },
                          )
                        : null,
                    popupViewModel.paramsCanBeRemoved
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
                    popupViewModel.paramsOptionsExist
                        ? PopupMenuItemModel.divider
                        : null,
                    PopupMenuItemModel(
                      text: popupViewModel.unitGroup.oob
                          ? 'Group Info'
                          : 'Edit Group',
                      icon: popupViewModel.unitGroup.oob
                          ? Icons.info_outline_rounded
                          : Icons.edit_outlined,
                      onTap: () {
                        unitGroupDetailsController.showGroupDetails(
                          context,
                          unitGroup: popupViewModel.unitGroup,
                        );
                      },
                    ),
                    PopupMenuItemModel(
                      text: "Units Dictionary",
                      icon: Icons.dashboard_customize_outlined,
                      onTap: () {
                        groupsController.showGroup(
                          context,
                          unitGroup: popupViewModel.unitGroup,
                        );

                        unitsController.showUnits(
                          context,
                          groupId: popupViewModel.unitGroup.id,
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
            ),
          ],
          body: Container(
            color: Colors.transparent,
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: Column(
                children: [
                  ConversionParamsView(
                    theme: appState.theme,
                  ),
                  Expanded(
                    child: ConvertouchConversionItemsView(
                      unitTapAction: appState.unitTapAction,
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
                    visible: refreshButtonState.visible,
                    disabled: refreshButtonState.disabled,
                    theme: appState.theme,
                  );
                },
              ),
              BlocSelector<ConversionBloc, ConversionState,
                  AddUnitsButtonViewModel?>(
                selector: (state) {
                  if (state is ConversionBuilt) {
                    return AddUnitsButtonViewModel(
                      addedUnitIds: state.conversion.convertedUnitValues
                          .map((item) => item.unit.id)
                          .toList(),
                      paramsApplicable:
                          areParamsApplicable(state.conversion.params?.active),
                      unitGroupId: state.conversion.unitGroup.id,
                    );
                  }

                  return null;
                },
                builder: (_, viewModel) {
                  if (viewModel == null) {
                    return const SizedBox.shrink();
                  }

                  return ConvertouchFloatingActionButton.adding(
                    onClick: () {
                      unitsController.showUnitsForAdding(
                        context,
                        groupId: viewModel.unitGroupId,
                        addedUnitIds: viewModel.addedUnitIds,
                        paramsApplicable: viewModel.paramsApplicable,
                      );
                    },
                    colorScheme: floatingButtonColor,
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
