import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/conversion_rule_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_state.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_states.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/info_box.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_item.dart';
import 'package:convertouch/presentation/ui/widgets/textbox.dart';
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
    return appBlocBuilder(
      builderFunc: (appState) {
        TextBoxColorScheme textBoxColor = unitTextBoxColors[appState.theme]!;
        ConvertouchColorScheme floatingButtonColor =
            unitsPageFloatingButtonColors[appState.theme]!;

        return unitDetailsBlocBuilder(
          builderFunc: (pageState) {
            _unitNameTextController.text = pageState.details.draftUnitData.name;
            _unitCodeTextController.text = pageState.details.draftUnitData.code;

            return ConvertouchPage(
              title: pageState.details.editMode
                  ? pageState.details.savedUnitData.name
                  : 'New Unit',
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
                      _renderGroupItem(
                        context,
                        state: pageState,
                        appState: appState,
                      ),
                      _renderUnitDetailItem(
                        context,
                        name: 'Unit Name',
                        hintText: pageState.details.savedUnitData.name,
                        valueChangeController: _unitNameTextController,
                        editable: pageState.details.editMode,
                        textBoxColor: textBoxColor,
                        onValueChange: (value) {
                          BlocProvider.of<UnitDetailsBloc>(context).add(
                            UpdateUnitNameInUnitDetails(
                              newValue: value,
                            ),
                          );
                        },
                      ),
                      _renderUnitDetailItem(
                        context,
                        name: 'Unit Code',
                        hintText: pageState.details.savedUnitData.code,
                        valueChangeController: _unitCodeTextController,
                        editable: pageState.details.editMode,
                        textBoxColor: textBoxColor,
                        editableValueMaxLength:
                            UnitDetailsModel.unitCodeMaxLength,
                        editableValueLengthVisible: true,
                        onValueChange: (value) {
                          BlocProvider.of<UnitDetailsBloc>(context).add(
                            UpdateUnitCodeInUnitDetails(
                              newValue: value,
                            ),
                          );
                        },
                      ),
                      _renderUnitDetailItem(
                        context,
                        name: 'Value Type',
                        hintText:
                            pageState.details.draftUnitData.valueType!.name,
                        textBoxColor: textBoxColor,
                      ),
                      _renderUnitDetailItem(
                        context,
                        name: 'Min Value',
                        hintText: pageState
                            .details.savedUnitData.minValue?.scientific,
                        visible: pageState
                                .details.savedUnitData.minValue?.isDefined ??
                            false,
                        textBoxColor: textBoxColor,
                      ),
                      _renderUnitDetailItem(
                        context,
                        name: 'Max Value',
                        hintText: pageState
                            .details.savedUnitData.maxValue?.scientific,
                        visible: pageState
                                .details.savedUnitData.maxValue?.isDefined ??
                            false,
                        textBoxColor: textBoxColor,
                      ),
                      _renderUnitDetailItem(
                        context,
                        name: 'Unit Group',
                        hintText: pageState.details.unitGroup.name,
                        visible: !pageState.details.editMode,
                        textBoxColor: textBoxColor,
                      ),
                      _renderConversionRule(
                        context,
                        unitGroup: pageState.details.unitGroup,
                        unit: pageState.details.draftUnitData,
                        conversionRule: pageState.details.conversionRule,
                        textBoxColor: textBoxColor,
                        editMode: pageState.details.editMode,
                        appState: appState,
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: conversionBlocBuilder(
                builderFunc: (conversionState) {
                  return ConvertouchFloatingActionButton(
                    icon: Icons.check_outlined,
                    visible: pageState.details.unitToSave.exists,
                    onClick: () {
                      FocusScope.of(context).unfocus();
                      BlocProvider.of<UnitsBloc>(context).add(
                        SaveUnit(
                          unit: pageState.details.draftUnitData,
                          unitGroup: pageState.details.unitGroup,
                          unitGroupChanged: pageState.details.unitGroupChanged,
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

  Widget _renderGroupItem(
    BuildContext context, {
    required UnitDetailsReady state,
    required AppStateReady appState,
  }) {
    if (state.details.unitGroup.exists || state.details.editMode) {
      return empty();
    }

    return Column(
      children: [
        ConvertouchMenuItem(
          state.details.unitGroup,
          onTap: () {
            FocusScope.of(context).unfocus();
            BlocProvider.of<UnitGroupsBlocForUnitDetails>(
              context,
            ).add(
              const FetchUnitGroups(),
            );
          },
          theme: appState.theme,
          itemsViewMode: ItemsViewMode.list,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _renderUnitDetailItem(
    BuildContext context, {
    String? name,
    String? hintText,
    Widget? styledHintText,
    bool visible = true,
    bool editable = false,
    required TextBoxColorScheme textBoxColor,
    TextEditingController? valueChangeController,
    void Function(String)? onValueChange,
    int? editableValueMaxLength,
    bool editableValueLengthVisible = false,
  }) {
    if (!visible) {
      return empty();
    }

    return editable
        ? ConvertouchTextBox(
            label: name ?? "",
            controller: valueChangeController,
            onChanged: onValueChange,
            hintText: hintText,
            colors: textBoxColor,
            textLengthCounterVisible: editableValueLengthVisible,
            maxTextLength: editableValueMaxLength,
          )
        : ConvertouchInfoBox(
            headerText: name,
            bodyText: hintText,
            bodyColor: textBoxColor.foreground.regular,
            margin: const EdgeInsets.only(
              bottom: 20,
            ),
            child: styledHintText,
          );
  }

  Widget _renderConversionRule(
    BuildContext context, {
    required bool editMode,
    required UnitGroupModel unitGroup,
    required UnitModel unit,
    required ConversionRule conversionRule,
    required AppStateReady appState,
    required TextBoxColorScheme textBoxColor,
  }) {
    if (editMode) {
      return Visibility(
        visible: conversionRule.configVisible,
        child: Column(
          children: [
            ConvertouchInfoBox(
              child: Center(
                child: Text(
                  "Conversion Rule",
                  style: TextStyle(
                    color: textBoxColor.foreground.regular,
                    fontWeight: FontWeight.w500,
                    fontFamily: quicksandFontFamily,
                  ),
                ),
              ),
            ),
            ConvertouchConversionItem(
              ConversionItemModel(
                unit: unit,
                value: conversionRule.unitValue,
                defaultValue: ValueModel.one,
              ),
              valueType: unit.valueType ?? unitGroup.valueType,
              disabled: !conversionRule.configEditable,
              onValueChanged: (value) {
                BlocProvider.of<UnitDetailsBloc>(context).add(
                  UpdateUnitValueInUnitDetails(
                    newValue: value,
                  ),
                );
              },
              theme: appState.theme,
            ),
            const SizedBox(height: 12),
            ConvertouchConversionItem(
              ConversionItemModel(
                unit: unit,
                value: conversionRule.draftArgValue,
                defaultValue: conversionRule.savedArgValue,
              ),
              valueType: unit.valueType ?? unitGroup.valueType,
              disabled: !conversionRule.configEditable,
              onValueChanged: (value) {
                BlocProvider.of<UnitDetailsBloc>(context).add(
                  UpdateArgumentUnitValueInUnitDetails(
                    newValue: value,
                  ),
                );
              },
              onTap: () {
                BlocProvider.of<UnitsBlocForUnitDetails>(
                  context,
                ).add(
                  FetchUnits(
                    unitGroup: unitGroup,
                  ),
                );
              },
              theme: appState.theme,
            ),
            const SizedBox(height: 25),
          ],
        ),
      );
    } else {
      return _renderUnitDetailItem(
        context,
        name: 'Conversion Rule',
        hintText: conversionRule.readOnlyDescription,
        visible: conversionRule.readOnlyDescription != null,
        textBoxColor: textBoxColor,
      );
    }
  }

  @override
  void dispose() {
    _unitNameTextController.dispose();
    _unitCodeTextController.dispose();
    super.dispose();
  }
}
