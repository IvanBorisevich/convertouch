import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/units/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units/units_events.dart';
import 'package:convertouch/presentation/pages/animation/fade_scale_animation.dart';
import 'package:convertouch/presentation/pages/items_view/item/item.dart';
import 'package:convertouch/presentation/pages/scaffold/bloc_wrappers.dart';
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
                    markedUnits: unitCreationPrepared.markedUnits,
                  ),
                );
              },
            );
          }),
        ],
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsetsDirectional.fromSTEB(7, 10, 7, 0),
            child: Column(children: [
              unitCreationBloc((unitCreationPrepared) {
                UnitGroupModel unitGroup = unitCreationPrepared.unitGroup;
                return ConvertouchItem.createItem(
                  unitGroup,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    BlocProvider.of<UnitGroupsBloc>(context).add(
                      FetchUnitGroups(
                        selectedUnitGroupId: unitGroup.id,
                        markedUnits: unitCreationPrepared.markedUnits,
                        action: ConvertouchAction
                            .fetchUnitGroupsToSelectForUnitCreation,
                      ),
                    );
                  },
                ).buildForList();
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
                textBoxColors: textBoxColors[ConvertouchUITheme.light]!,
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
                textBoxColors: textBoxColors[ConvertouchUITheme.light]!,
              ),
              const SizedBox(height: 25),
              unitCreationBloc((unitCreationPrepared) {
                bool equivalentUnitVisible = _unitName.isNotEmpty &&
                    unitCreationPrepared.equivalentUnit != null;
                return Column(
                  children: [
                    ConvertouchFadeScaleAnimation(
                      duration: const Duration(milliseconds: 150),
                      reverse: !equivalentUnitVisible,
                      child: _horizontalDividerWithText(
                        "Set unit value equivalent",
                      ),
                    ),
                    const SizedBox(height: 25),
                    ConvertouchFadeScaleAnimation(
                      duration: const Duration(milliseconds: 150),
                      reverse: !equivalentUnitVisible,
                      child: ConvertouchItem.createItem(
                        UnitValueModel(
                          unit: UnitModel(
                            name: _unitName,
                            abbreviation: _unitAbbr.isNotEmpty
                                ? _unitAbbr
                                : _unitAbbrHint,
                            unitGroupId: unitCreationPrepared.unitGroup.id,
                          ),
                          value: 1,
                        ),
                      ).buildForList(),
                    ),
                    const SizedBox(height: 9),
                    ConvertouchFadeScaleAnimation(
                      duration: const Duration(milliseconds: 150),
                      reverse: !equivalentUnitVisible,
                      child: ConvertouchItem.createItem(
                        UnitValueModel(
                          unit: unitCreationPrepared.equivalentUnit!,
                          value: 1,
                        ),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          BlocProvider.of<UnitsBloc>(context).add(
                            FetchUnits(
                              unitGroupId: unitCreationPrepared.unitGroup.id,
                              selectedUnit: unitCreationPrepared.equivalentUnit,
                              markedUnits: unitCreationPrepared.markedUnits,
                              action: ConvertouchAction
                                  .fetchUnitsToSelectForUnitCreation,
                            ),
                          );
                        },
                      ).buildForList(),
                    ),
                    const SizedBox(height: 25),
                  ],
                );
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
