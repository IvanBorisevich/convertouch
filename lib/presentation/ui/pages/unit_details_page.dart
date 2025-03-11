import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_list_item.dart';
import 'package:convertouch/presentation/ui/widgets/parameter_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitDetailsPage extends StatefulWidget {
  const ConvertouchUnitDetailsPage({super.key});

  @override
  State createState() => _ConvertouchUnitDetailsPageState();
}

class _ConvertouchUnitDetailsPageState
    extends State<ConvertouchUnitDetailsPage> {
  final _unitNameTextController = TextEditingController();
  final _unitCodeTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final unitGroupsBlocForDetails =
        BlocProvider.of<UnitGroupsBlocForUnitDetails>(context);
    final unitsBlocForDetails =
        BlocProvider.of<UnitsBlocForUnitDetails>(context);
    final unitsBloc = BlocProvider.of<UnitsBloc>(context);
    final unitDetailsBloc = BlocProvider.of<UnitDetailsBloc>(context);
    final itemsSelectionBloc =
        BlocProvider.of<ItemsSelectionBlocForUnitDetails>(context);
    final conversionBloc = BlocProvider.of<ConversionBloc>(context);
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return appBlocBuilder(
      builderFunc: (appState) {
        InputBoxColorScheme textBoxColor = unitTextBoxColors[appState.theme]!;
        ConvertouchColorScheme floatingButtonColor =
            unitsPageFloatingButtonColors[appState.theme]!;

        return unitDetailsBlocBuilder(
          builderFunc: (pageState) {
            _unitNameTextController.text = pageState.details.draftUnitData.name;
            _unitCodeTextController.text = pageState.details.draftUnitData.code;

            return ConvertouchPage(
              title: pageState.details.existingUnit ? 'Unit Info' : 'New Unit',
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 23,
                    right: 20,
                    bottom: 0,
                  ),
                  child: Column(
                    children: [
                      pageState.details.editMode
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: ConvertouchMenuListItem(
                                pageState.details.unitGroup,
                                itemName: pageState.details.unitGroup.name,
                                checkIconVisible: false,
                                checkIconVisibleIfUnchecked: false,
                                checked: false,
                                colors: unitGroupItemColors[appState.theme]!,
                                disabled: false,
                                editIconVisible: false,
                                logoFunc: (
                                  item, {
                                  required Color foreground,
                                  required Color matchForeground,
                                  required Color matchBackground,
                                }) {
                                  return IconUtils.getUnitGroupIcon(
                                    iconName: item.iconName,
                                    color: foreground,
                                    size: 29,
                                  );
                                },
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  unitGroupsBlocForDetails.add(
                                    const FetchItems(),
                                  );

                                  itemsSelectionBloc.add(
                                    StartItemSelection(
                                      previouslySelectedId:
                                          pageState.details.unitGroup.id,
                                    ),
                                  );

                                  navigationBloc.add(
                                    const NavigateToPage(
                                      pageName:
                                          PageName.unitGroupsPageForUnitDetails,
                                    ),
                                  );
                                },
                              ),
                            )
                          : ConvertouchParameterItem(
                              name: 'Unit Group',
                              value: pageState.details.unitGroup.name,
                              visible: true,
                              textBoxColor: textBoxColor,
                            ),
                      ConvertouchParameterItem(
                        name: 'Unit Name',
                        value: pageState.details.savedUnitData.name,
                        valueChangeController: _unitNameTextController,
                        editable: pageState.details.editMode,
                        textBoxColor: textBoxColor,
                        onValueChanged: (value) {
                          unitDetailsBloc.add(
                            UpdateUnitNameInUnitDetails(
                              newValue: value,
                            ),
                          );
                        },
                      ),
                      ConvertouchParameterItem(
                        name: 'Unit Code',
                        value: pageState.details.savedUnitData.code,
                        valueChangeController: _unitCodeTextController,
                        editable: pageState.details.editMode,
                        textBoxColor: textBoxColor,
                        editableValueMaxLength:
                            UnitDetailsModel.unitCodeMaxLength,
                        editableValueLengthVisible: true,
                        onValueChanged: (value) {
                          unitDetailsBloc.add(
                            UpdateUnitCodeInUnitDetails(
                              newValue: value,
                            ),
                          );
                        },
                      ),
                      ConvertouchParameterItem(
                        name: 'Value Type',
                        value: pageState.details.draftUnitData.valueType.name,
                        textBoxColor: textBoxColor,
                      ),
                      ConvertouchParameterItem(
                        name: 'Min Value',
                        value: pageState.details.savedUnitData.minValue.alt,
                        visible:
                            pageState.details.savedUnitData.minValue.isNotEmpty,
                        textBoxColor: textBoxColor,
                      ),
                      ConvertouchParameterItem(
                        name: 'Max Value',
                        value: pageState.details.savedUnitData.maxValue.alt,
                        visible:
                            pageState.details.savedUnitData.maxValue.isNotEmpty,
                        textBoxColor: textBoxColor,
                      ),
                      ConvertouchParameterItem(
                        name: 'Conversion Rule',
                        nameVisible: pageState.details.conversionRule
                                    .readOnlyDescription !=
                                null ||
                            pageState.details.conversionRule.configVisible,
                        value: pageState
                            .details.conversionRule.readOnlyDescription,
                        textBoxColor: textBoxColor,
                        content: Visibility(
                          visible: pageState.details.editMode &&
                              pageState.details.conversionRule.configVisible,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              ConvertouchConversionItem(
                                ConversionUnitValueModel(
                                  unit: pageState.details.resultUnit,
                                  value: pageState
                                      .details.conversionRule.unitValue,
                                  defaultValue: ValueModel.one,
                                ),
                                disabled: !pageState
                                    .details.conversionRule.configEditable,
                                itemNameFunc: (item) => item.unit.name,
                                unitItemCodeFunc: (item) => item.unit.code,
                                controlsVisible: false,
                                onValueChanged: (value) {
                                  unitDetailsBloc.add(
                                    UpdateUnitValueInUnitDetails(
                                      newValue: value,
                                    ),
                                  );
                                },
                                colors: conversionItemColors[appState.theme]!,
                              ),
                              const SizedBox(height: 12),
                              ConvertouchConversionItem(
                                ConversionUnitValueModel(
                                  unit:
                                      pageState.details.conversionRule.argUnit,
                                  value: pageState
                                      .details.conversionRule.draftArgValue,
                                  defaultValue: pageState
                                      .details.conversionRule.savedArgValue,
                                ),
                                disabled: !pageState
                                    .details.conversionRule.configEditable,
                                itemNameFunc: (item) => item.unit.name,
                                unitItemCodeFunc: (item) => item.unit.code,
                                controlsVisible: false,
                                onValueChanged: (value) {
                                  unitDetailsBloc.add(
                                    UpdateArgumentUnitValueInUnitDetails(
                                      newValue: value,
                                    ),
                                  );
                                },
                                onTap: () {
                                  unitsBlocForDetails.add(
                                    FetchItems(
                                      parentItemId:
                                          pageState.details.unitGroup.id,
                                    ),
                                  );
                                  itemsSelectionBloc.add(
                                    StartItemSelection(
                                      previouslySelectedId: pageState
                                          .details.conversionRule.argUnit.id,
                                      excludedIds: [
                                        pageState.details.resultUnit.id
                                      ],
                                    ),
                                  );
                                  navigationBloc.add(
                                    const NavigateToPage(
                                      pageName:
                                          PageName.unitsPageForUnitDetails,
                                    ),
                                  );
                                },
                                colors: conversionItemColors[appState.theme]!,
                              ),
                              const SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: conversionBlocBuilder(
                builderFunc: (conversionState) {
                  return ConvertouchFloatingActionButton(
                    icon: Icons.check_outlined,
                    visible: pageState.details.deltaDetected,
                    onClick: () {
                      FocusScope.of(context).unfocus();
                      unitsBloc.add(
                        SaveItem(
                          item: pageState.details.resultUnit,
                          onItemSave: (savedUnit) {
                            conversionBloc.add(
                              EditConversionItemUnit(
                                editedUnit: savedUnit,
                              ),
                            );
                            navigationBloc.add(
                              const NavigateBack(),
                            );
                          },
                        ),
                      );
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

  @override
  void dispose() {
    _unitNameTextController.dispose();
    _unitCodeTextController.dispose();
    super.dispose();
  }
}
