import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_state.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_states.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_unit_details.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_unit_details.dart';
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
    return appBlocBuilder((appState) {
      TextBoxColorScheme textBoxColor = unitTextBoxColors[appState.theme]!;
      ConvertouchColorScheme floatingButtonColor =
          unitsPageFloatingButtonColors[appState.theme]!;

      return unitDetailsBlocBuilder((pageState) {
        _unitNameTextController.text = pageState.details.draft.unitData.name;
        _unitCodeTextController.text = pageState.details.draft.unitData.code;

        return ConvertouchPage(
          title: pageState.details.editMode
              ? pageState.details.saved.unitData.name
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
                    hintText: pageState.details.saved.unitData.name,
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
                    hintText: pageState.details.saved.unitData.code,
                    valueChangeController: _unitCodeTextController,
                    editable: pageState.details.editMode,
                    textBoxColor: textBoxColor,
                    editableValueMaxLength: UnitDetailsModel.unitCodeMaxLength,
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
                    hintText: pageState.details.saved.unitData.valueType!.name,
                    textBoxColor: textBoxColor,
                  ),
                  _renderUnitDetailItem(
                    context,
                    name: 'Min Value',
                    hintText: DoubleValueUtils.formatValueScientific(
                      pageState.details.saved.unitData.minValue,
                      noValueStr: '-',
                    ),
                    textBoxColor: textBoxColor,
                  ),
                  _renderUnitDetailItem(
                    context,
                    name: 'Max Value',
                    hintText: DoubleValueUtils.formatValueScientific(
                      pageState.details.saved.unitData.maxValue,
                      noValueStr: '-',
                    ),
                    textBoxColor: textBoxColor,
                  ),
                  _renderUnitDetailItem(
                    context,
                    name: 'Unit Group',
                    hintText: pageState.details.saved.unitGroup.name,
                    visible: !pageState.details.editMode,
                    textBoxColor: textBoxColor,
                  ),
                  _renderUnitDetailItem(
                    context,
                    name: 'Conversion Rule',
                    hintText: pageState.details.conversionDescription,
                    visible: !pageState.details.conversionConfigVisible,
                    textBoxColor: textBoxColor,
                  ),
                  _renderUnitDetailItem(
                    context,
                    styledHintText: Center(
                      child: Text(
                        "Conversion Rule Setting",
                        style: TextStyle(
                          color: textBoxColor.foreground.regular,
                          fontWeight: FontWeight.w500,
                          fontFamily: quicksandFontFamily,
                        ),
                      ),
                    ),
                    visible: pageState.details.conversionConfigVisible,
                    textBoxColor: textBoxColor,
                  ),
                  _renderConversionRuleItem(
                    context,
                    unit: pageState.details.draft.unitData,
                    value: pageState.details.draft.value,
                    valueType: pageState.details.draft.unitData.valueType!,
                    hintValue: pageState.details.saved.value,
                    editable: pageState.details.conversionConfigEditable,
                    visible: pageState.details.conversionConfigVisible,
                    appState: appState,
                    onValueChanged: (value) {
                      BlocProvider.of<UnitDetailsBloc>(context).add(
                        UpdateUnitValueInUnitDetails(
                          newValue: value,
                        ),
                      );
                    },
                  ),
                  _renderConversionRuleItem(
                    context,
                    unit: pageState.details.draft.argUnit,
                    value: pageState.details.draft.argValue,
                    valueType: pageState.details.draft.unitData.valueType!,
                    hintValue: pageState.details.saved.argValue,
                    editable: pageState.details.conversionConfigEditable,
                    visible: pageState.details.conversionConfigVisible,
                    appState: appState,
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
                        FetchUnitsForUnitDetails(
                          unitGroup: pageState.details.draft.unitGroup,
                          selectedArgUnit: pageState.details.draft.argUnit,
                          unitIdBeingEdited:
                              pageState.details.saved.unitData.id,
                          searchString: null,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: conversionBlocBuilder((conversionState) {
            return ConvertouchFloatingActionButton(
              icon: Icons.check_outlined,
              visible: pageState.details.unitToSave != null,
              onClick: () {
                FocusScope.of(context).unfocus();
                BlocProvider.of<UnitsBloc>(context).add(
                  SaveUnit(
                    unit: pageState.details.unitToSave!,
                    unitGroup: pageState.details.draft.unitGroup,
                    unitGroupChanged: pageState.details.unitGroupChanged,
                  ),
                );
              },
              colorScheme: floatingButtonColor,
            );
          }),
        );
      });
    });
  }

  Widget _renderGroupItem(
    BuildContext context, {
    required UnitDetailsReady state,
    required AppStateReady appState,
  }) {
    if (state.details.draft.unitGroup.empty || state.details.editMode) {
      return empty();
    }

    return Column(
      children: [
        ConvertouchMenuItem(
          state.details.draft.unitGroup,
          onTap: () {
            FocusScope.of(context).unfocus();
            BlocProvider.of<UnitGroupsBlocForUnitDetails>(
              context,
            ).add(
              FetchUnitGroupsForUnitDetails(
                currentUnitGroupInUnitDetails: state.details.draft.unitGroup,
                searchString: null,
              ),
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

  Widget _renderConversionRuleItem(
    BuildContext context, {
    required UnitModel unit,
    required ValueModel value,
    required ValueModel hintValue,
    required bool visible,
    required bool editable,
    required ConvertouchValueType valueType,
    required AppStateReady appState,
    Function(String)? onValueChanged,
    Function()? onTap,
  }) {
    return Visibility(
      visible: visible,
      child: ConvertouchConversionItem(
        ConversionItemModel(
          unit: UnitModel(
            name: unit.name,
            code: unit.code,
          ),
          value: value,
          defaultValue: hintValue,
        ),
        valueType: valueType,
        disabled: !editable,
        onValueChanged: onValueChanged,
        onTap: () {
          if (editable) {
            onTap?.call();
          }
        },
        theme: appState.theme,
      ),
    );
  }

  @override
  void dispose() {
    _unitNameTextController.dispose();
    _unitCodeTextController.dispose();
    super.dispose();
  }
}
