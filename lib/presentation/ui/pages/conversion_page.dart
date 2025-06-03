import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/conversion_param_sets_page/conversion_param_sets_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_param_sets_page/single_param_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
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
    _isPopupMenuOpen = false;
    _panelController = PanelController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final unitsBloc = BlocProvider.of<UnitsBloc>(context);
    final unitsSelectionBloc = BlocProvider.of<ItemsSelectionBloc>(context);
    final unitGroupDetailsBloc = BlocProvider.of<UnitGroupDetailsBloc>(context);
    final paramSetsBloc = BlocProvider.of<ConversionParamSetsBloc>(context);
    final conversionBloc = BlocProvider.of<ConversionBloc>(context);
    final singleParamBloc = BlocProvider.of<SingleParamBloc>(context);
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return BlocListener<NavigationBloc, NavigationState>(
      listener: (_, navigationState) {
        if (_isPopupMenuOpen) {
          Navigator.of(context).pop();
        }
      },
      child: appBlocBuilder(
        builderFunc: (appState) {
          PageColorScheme pageColorScheme = pageColors[appState.theme]!;
          ConvertouchColorScheme floatingButtonColor =
              conversionPageFloatingButtonColors[appState.theme]!;

          return singleGroupBlocBuilder(
            builderFunc: (singleGroupState) {
              UnitGroupModel unitGroup = singleGroupState.unitGroup;

              return ConvertouchPage(
                title: unitGroup.name,
                appBarRightWidgets: [
                  conversionBlocBuilder(
                    builderFunc: (pageState) {
                      return Visibility(
                        visible: pageState.conversion.params != null,
                        child: IconButton(
                          icon: IconUtils.getIcon(
                            IconNames.parameters,
                            color: pageColorScheme.appBar.foreground.regular,
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
                  ConvertouchPopupMenu(
                    width: 210,
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
                          unitGroupDetailsBloc.add(
                            GetExistingUnitGroupDetails(
                              unitGroup: unitGroup,
                            ),
                          );
                        },
                      ),
                      PopupMenuItemModel(
                        text: "Units Dictionary",
                        icon: Icons.dashboard_customize_outlined,
                        onTap: () {
                          unitsBloc.add(
                            FetchItems(
                              params: UnitsFetchParams(
                                parentItemId: unitGroup.id,
                                parentItemType: ItemType.unitGroup,
                              ),
                              onFirstFetch: () {
                                navigationBloc.add(
                                  const NavigateToPage(
                                    pageName: PageName.unitsPageRegular,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      PopupMenuItemModel(
                        text: "Clear Conversion",
                        icon: Icons.delete_outline_rounded,
                        onTap: () {
                          conversionBloc.add(const ClearConversion());
                        },
                      ),
                    ],
                    backgroundColor: pageColorScheme.appBar.background.regular,
                    iconColor: pageColorScheme.appBar.foreground.regular,
                    textColor: pageColorScheme.appBar.foreground.regular,
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
                              onParamSetAdd: () {
                                paramSetsBloc.add(
                                  FetchItems(
                                    params: UnitsFetchParams(
                                      parentItemId: unitGroup.id,
                                      parentItemType: ItemType.unitGroup,
                                    ),
                                  ),
                                );
                                unitsSelectionBloc.add(
                                  StartItemsMarking(
                                    previouslyMarkedIds: conversion
                                        .params?.paramSetValues
                                        .map((item) => item.paramSet.id)
                                        .toList(),
                                    excludedIds: conversion
                                            .params?.paramSetValues
                                            .where((item) =>
                                                item.paramSet.mandatory)
                                            .map((item) => item.paramSet.id)
                                            .toList() ??
                                        [],
                                  ),
                                );
                                navigationBloc.add(
                                  const NavigateToPage(
                                    pageName: PageName.paramSetsPage,
                                  ),
                                );
                              },
                              onParamSetSelect: (newIndex) {
                                conversionBloc.add(
                                  SelectParamSetInConversion(
                                    newSelectedParamSetIndex: newIndex,
                                  ),
                                );
                              },
                              onParamUnitTap: (paramValue) {
                                singleParamBloc.add(
                                  ShowParam(
                                    param: paramValue.param,
                                  ),
                                );

                                unitsBloc.add(
                                  FetchItems(
                                    params: UnitsFetchParams(
                                      parentItemId: paramValue.param.id,
                                      parentItemType: ItemType.conversionParam,
                                    ),
                                  ),
                                );

                                unitsSelectionBloc.add(
                                  StartItemSelection(
                                    previouslySelectedId: paramValue.unit!.id,
                                  ),
                                );

                                navigationBloc.add(
                                  const NavigateToPage(
                                    pageName:
                                        PageName.unitsPageForConversionParams,
                                  ),
                                );
                              },
                              onValueChanged: (paramValue, newValue) {
                                conversionBloc.add(
                                  EditConversionParamValue(
                                    newValue: newValue,
                                    paramId: paramValue.param.id,
                                    paramSetId: paramValue.param.paramSetId,
                                  ),
                                );
                              },
                              onSelectedParamSetRemove: () {
                                conversionBloc.add(
                                  const RemoveSelectedParamSetFromConversion(),
                                );
                              },
                              onParamSetsBulkRemove: () {
                                conversionBloc.add(
                                  const RemoveAllParamSetsFromConversion(),
                                );
                              },
                              theme: appState.theme,
                            ),
                            Expanded(
                              child: ConvertouchConversionItemsView(
                                conversion.convertedUnitValues,
                                sourceUnitId: conversion.srcUnitValue?.unit.id,
                                onUnitItemTap: (item) {
                                  unitsBloc.add(
                                    FetchItems(
                                      params: UnitsFetchParams(
                                        parentItemId: conversion.unitGroup.id,
                                        parentItemType: ItemType.unitGroup,
                                      ),
                                    ),
                                  );

                                  unitsSelectionBloc.add(
                                    StartItemSelection(
                                      previouslySelectedId: item.unit.id,
                                      excludedIds: conversion
                                          .convertedUnitValues
                                          .map((e) => e.unit.id)
                                          .whereNot((id) => id == item.unit.id)
                                          .toList(),
                                    ),
                                  );

                                  navigationBloc.add(
                                    const NavigateToPage(
                                      pageName: PageName.unitsPageForConversion,
                                    ),
                                  );
                                },
                                onTextValueChanged: (item, value) {
                                  conversionBloc.add(
                                    EditConversionItemValue(
                                      newValue: value,
                                      unitId: item.unit.id,
                                    ),
                                  );
                                },
                                onItemRemoveTap: (item) {
                                  conversionBloc.add(
                                    RemoveConversionItems(
                                      unitIds: [item.unit.id],
                                    ),
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
                        ConvertouchRefreshFloatingButton(
                          unitGroupName: unitGroup.name,
                          visible: pageState.showRefreshButton,
                        ),
                        ConvertouchFloatingActionButton.adding(
                          onClick: () {
                            unitsBloc.add(
                              FetchItems(
                                params: UnitsFetchParams(
                                  parentItemId: unitGroup.id,
                                  parentItemType: ItemType.unitGroup,
                                ),
                              ),
                            );
                            unitsSelectionBloc.add(
                              StartItemsMarking(
                                previouslyMarkedIds: conversion
                                    .convertedUnitValues
                                    .map((unitValue) => unitValue.unit.id)
                                    .toList(),
                                markedItemsSelectionMinNum: 2,
                              ),
                            );
                            navigationBloc.add(
                              const NavigateToPage(
                                pageName: PageName.unitsPageForConversion,
                              ),
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
