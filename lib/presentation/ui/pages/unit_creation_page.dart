import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_unit_creation.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_unit_creation.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/animation/fade_scale_animation.dart';
import 'package:convertouch/presentation/ui/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/items_view/item/menu_item.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/textbox.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitCreationPage extends StatefulWidget {
  const ConvertouchUnitCreationPage({super.key});

  @override
  State createState() => _ConvertouchUnitCreationPageState();
}

class _ConvertouchUnitCreationPageState
    extends State<ConvertouchUnitCreationPage> {
  final _unitNameFieldController = TextEditingController();
  final _unitAbbrFieldController = TextEditingController();

  String _unitName = "";
  String _unitAbbr = "";
  String _unitAbbrHint = "";

  String _newUnitValue = "1";
  String _baseUnitValue = "1";

  @override
  Widget build(BuildContext context) {
    return appBloc((appState) {
      FloatingButtonColorVariation floatingButtonColor =
          unitsPageFloatingButtonColors[appState.theme]!;

      return unitCreationListener(
        context,
        child: unitCreationBloc((pageState) {
          return ConvertouchPage(
            appState: appState,
            title: "Add Unit",
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(7, 10, 7, 60),
                child: Column(
                  children: [
                    pageState.unitGroup != null
                        ? ConvertouchMenuItem(
                            pageState.unitGroup!,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              BlocProvider.of<UnitGroupsBlocForUnitCreation>(
                                context,
                              ).add(
                                FetchUnitGroupsForUnitCreation(
                                  currentUnitGroupInUnitCreation:
                                      pageState.unitGroup!,
                                ),
                              );
                              Navigator.of(context)
                                  .pushNamed(unitGroupsPageForUnitCreation);
                            },
                            theme: appState.theme,
                            itemsViewMode: ItemsViewMode.list,
                          )
                        : empty(),
                    const SizedBox(height: 20),
                    ConvertouchTextBox(
                      label: 'Unit Name',
                      controller: _unitNameFieldController,
                      onChanged: (String value) async {
                        setState(() {
                          _unitName = value;
                          _unitAbbrHint =
                              _getInitialUnitAbbreviationFromName(value);
                        });
                      },
                      theme: appState.theme,
                    ),
                    const SizedBox(height: 12),
                    ConvertouchTextBox(
                      label: 'Unit Abbreviation',
                      controller: _unitAbbrFieldController,
                      onChanged: (String value) async {
                        setState(() {
                          _unitAbbr = value;
                        });
                      },
                      maxTextLength: _unitAbbreviationMaxLength,
                      textLengthCounterVisible: true,
                      hintText: _unitAbbrHint,
                      theme: appState.theme,
                    ),
                    const SizedBox(height: 25),
                    pageState.comment == null
                        ? Column(
                            children: [
                              ConvertouchFadeScaleAnimation(
                                duration: const Duration(milliseconds: 150),
                                reverse: !_unitName.isNotEmpty,
                                child: _horizontalDividerWithText(
                                  "New conversion rule",
                                  appState.theme,
                                ),
                              ),
                              const SizedBox(height: 25),
                              ConvertouchFadeScaleAnimation(
                                duration: const Duration(milliseconds: 150),
                                reverse: !_unitName.isNotEmpty,
                                child: ConvertouchConversionItem(
                                  UnitValueModel(
                                    unit: UnitModel(
                                      name: _unitName,
                                      abbreviation: _unitAbbr.isNotEmpty
                                          ? _unitAbbr
                                          : _unitAbbrHint,
                                      unitGroupId: pageState.unitGroup!.id!,
                                    ),
                                    value: double.tryParse(_newUnitValue),
                                  ),
                                  onValueChanged: (value) {
                                    setState(() {
                                      _newUnitValue = value;
                                    });
                                  },
                                  theme: appState.theme,
                                ),
                              ),
                              const SizedBox(height: 9),
                              ConvertouchFadeScaleAnimation(
                                duration: const Duration(milliseconds: 150),
                                reverse: !_unitName.isNotEmpty,
                                child: ConvertouchConversionItem(
                                  UnitValueModel(
                                    unit: pageState.baseUnit!,
                                    value: double.tryParse(_baseUnitValue),
                                  ),
                                  onValueChanged: (value) {
                                    setState(() {
                                      _baseUnitValue = value;
                                    });
                                  },
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    BlocProvider.of<UnitsBlocForUnitCreation>(
                                      context,
                                    ).add(
                                      FetchUnitsForUnitCreation(
                                        unitGroup: pageState.unitGroup!,
                                        currentSelectedBaseUnit:
                                            pageState.baseUnit,
                                      ),
                                    );
                                    Navigator.of(context)
                                        .pushNamed(unitsPageForUnitCreation);
                                  },
                                  theme: appState.theme,
                                ),
                              ),
                              const SizedBox(height: 25),
                            ],
                          )
                        : ConvertouchFadeScaleAnimation(
                            duration: const Duration(milliseconds: 150),
                            child: _infoBox(pageState.comment!),
                          ),
                  ],
                ),
              ),
            ),
            floatingActionButton: ConvertouchFloatingActionButton(
              icon: Icons.check_outlined,
              visible: _unitName.isNotEmpty,
              onClick: () {
                FocusScope.of(context).unfocus();
                BlocProvider.of<UnitsBloc>(context).add(
                  AddUnit(
                    newUnit: UnitModel(
                      name: _unitName,
                      abbreviation:
                          _unitAbbr.isNotEmpty ? _unitAbbr : _unitAbbrHint,
                      unitGroupId: pageState.unitGroup!.id!,
                    ),
                    newUnitValue: _newUnitValue,
                    baseUnit: pageState.baseUnit,
                    baseUnitValue: _baseUnitValue,
                    unitGroup: pageState.unitGroup!,
                  ),
                );
              },
              background: floatingButtonColor.background,
              foreground: floatingButtonColor.foreground,
            ),
          );
        }),
      );
    });
  }

  @override
  void dispose() {
    _unitNameFieldController.dispose();
    _unitAbbrFieldController.dispose();
    super.dispose();
  }
}

Widget _horizontalDividerWithText(String text, ConvertouchUITheme theme) {
  Color dividerColor = dividerWithTextColors[theme]!;

  Widget divider() {
    return Expanded(
      child: Divider(
        color: dividerColor,
        thickness: 1.2,
      ),
    );
  }

  return Row(children: [
    divider(),
    const SizedBox(width: 7),
    Text(
      text,
      style: TextStyle(
        color: dividerColor,
        fontWeight: FontWeight.w500,
      ),
    ),
    const SizedBox(width: 7),
    divider(),
  ]);
}

Widget _infoBox(String comment) {
  return Container(
    padding: const EdgeInsetsDirectional.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: const Color(0xFFE7EFFF),
    ),
    child: Column(
      children: [
        const Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Color(0xFF345E85),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 5,
              ),
              child: Center(
                child: Text(
                  "Note",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF345E85),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Center(
          child: Text(
            comment,
            style: const TextStyle(
              color: Color(0xFF426F99),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );
}

const int _unitAbbreviationMaxLength = 4;

String _getInitialUnitAbbreviationFromName(String unitName) {
  return unitName.length > _unitAbbreviationMaxLength
      ? unitName.substring(0, _unitAbbreviationMaxLength)
      : unitName;
}
