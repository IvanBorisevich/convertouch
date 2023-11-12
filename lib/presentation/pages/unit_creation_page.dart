import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/units/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units/units_events.dart';
import 'package:convertouch/presentation/pages/animation/fade_scale_animation.dart';
import 'package:convertouch/presentation/pages/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/pages/items_view/item/menu_item.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/pages/scaffold/scaffold.dart';
import 'package:convertouch/presentation/pages/scaffold/textbox.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
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
  String _equivalentUnitValue = "1";

  @override
  Widget build(BuildContext context) {
    return unitCreationListener(
      context,
      ConvertouchScaffold(
        pageTitle: "New Unit",
        appBarRightWidgets: [
          unitCreationBloc((unitCreationPrepared) {
            return checkIcon(
              context,
              isEnabled: _unitName.isNotEmpty,
              onPressedFunc: () {
                FocusScope.of(context).unfocus();
                BlocProvider.of<UnitsBloc>(context).add(
                  AddUnit(
                    unitName: _unitName,
                    unitAbbreviation:
                        _unitAbbr.isNotEmpty ? _unitAbbr : _unitAbbrHint,
                    unitGroup: unitCreationPrepared.unitGroup,
                    newUnitValue: double.tryParse(_newUnitValue) ?? 1,
                    equivalentUnit: unitCreationPrepared.equivalentUnit,
                    equivalentUnitValue: double.tryParse(_equivalentUnitValue),
                    markedUnits: unitCreationPrepared.markedUnits,
                  ),
                );
              },
              color: scaffoldColor[ConvertouchUITheme.light]!,
            );
          }),
        ],
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsetsDirectional.fromSTEB(7, 10, 7, 0),
            child: Column(children: [
              unitCreationBloc((unitCreationPrepared) {
                UnitGroupModel unitGroup = unitCreationPrepared.unitGroup;
                return ConvertouchMenuItem(
                  unitGroup,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    BlocProvider.of<UnitGroupsBloc>(context).add(
                      FetchUnitGroups(
                        selectedUnitGroupId: unitGroup.id!,
                        markedUnits: unitCreationPrepared.markedUnits,
                        action: ConvertouchAction
                            .fetchUnitGroupsToSelectForUnitCreation,
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 20),
              ConvertouchTextBox(
                label: 'Unit Name',
                controller: _unitNameFieldController,
                onChanged: (String value) async {
                  setState(() {
                    _unitName = value;
                    _unitAbbrHint = _getInitialUnitAbbreviationFromName(value);
                  });
                },
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
              ),
              const SizedBox(height: 25),
              unitCreationBloc((unitCreationPrepared) {
                bool newUnitNameEntered = _unitName.isNotEmpty;
                bool equivalentUnitExists =
                    unitCreationPrepared.equivalentUnit != null;
                if (equivalentUnitExists) {
                  return Column(
                    children: [
                      ConvertouchFadeScaleAnimation(
                        duration: const Duration(milliseconds: 150),
                        reverse: !newUnitNameEntered,
                        child: _horizontalDividerWithText(
                          "Set unit value equivalent",
                        ),
                      ),
                      const SizedBox(height: 25),
                      ConvertouchFadeScaleAnimation(
                        duration: const Duration(milliseconds: 150),
                        reverse: !newUnitNameEntered,
                        child: ConvertouchConversionItem(
                          UnitValueModel(
                            unit: UnitModel(
                              name: _unitName,
                              abbreviation: _unitAbbr.isNotEmpty
                                  ? _unitAbbr
                                  : _unitAbbrHint,
                              unitGroupId: unitCreationPrepared.unitGroup.id!,
                            ),
                            value: double.tryParse(_newUnitValue),
                          ),
                          onValueChanged: (value) {
                            setState(() {
                              _newUnitValue = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 9),
                      ConvertouchFadeScaleAnimation(
                        duration: const Duration(milliseconds: 150),
                        reverse: !newUnitNameEntered,
                        child: ConvertouchConversionItem(
                          UnitValueModel(
                            unit: unitCreationPrepared.equivalentUnit!,
                            value: double.tryParse(_equivalentUnitValue),
                          ),
                          onValueChanged: (value) {
                            setState(() {
                              _equivalentUnitValue = value;
                            });
                          },
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            BlocProvider.of<UnitsBloc>(context).add(
                              FetchUnits(
                                unitGroupId: unitCreationPrepared.unitGroup.id!,
                                selectedUnit:
                                    unitCreationPrepared.equivalentUnit,
                                markedUnits: unitCreationPrepared.markedUnits,
                                action: ConvertouchAction
                                    .fetchUnitsToSelectForUnitCreation,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  );
                } else {
                  return ConvertouchFadeScaleAnimation(
                    duration: const Duration(milliseconds: 150),
                    child: Container(
                      padding: const EdgeInsetsDirectional.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFE7EFFF),
                      ),
                      child: const Column(
                        children: [
                          Row(
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
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Text(
                              "It's a first unit you are going to add to the "
                              "current group, so there isn't an equivalent "
                              "unit yet to be selected",
                              style: TextStyle(
                                color: Color(0xFF426F99),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _horizontalDividerWithText(String text) {
    return Row(children: [
      Expanded(
        child: Divider(
          color: dividerWithTextColor[ConvertouchUITheme.light],
          thickness: 1.2,
        ),
      ),
      const SizedBox(width: 7),
      Text(
        text,
        style: TextStyle(
          color: dividerWithTextColor[ConvertouchUITheme.light],
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(width: 7),
      Expanded(
        child: Divider(
          color: dividerWithTextColor[ConvertouchUITheme.light],
          thickness: 1.2,
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    _unitNameFieldController.dispose();
    _unitAbbrFieldController.dispose();
    super.dispose();
  }
}

const int _unitAbbreviationMaxLength = 4;

String _getInitialUnitAbbreviationFromName(String unitName) {
  return unitName.length > _unitAbbreviationMaxLength
      ? unitName.substring(0, _unitAbbreviationMaxLength)
      : unitName;
}
