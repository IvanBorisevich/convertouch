import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_states.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_unit_details.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_unit_details.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:convertouch/presentation/ui/animation/fade_scale_animation.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/items_view/item/menu_item.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/textbox.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitDetailsPage extends StatefulWidget {
  const ConvertouchUnitDetailsPage({super.key});

  @override
  State createState() => _ConvertouchUnitDetailsPageState();
}

class _ConvertouchUnitDetailsPageState
    extends State<ConvertouchUnitDetailsPage> {
  final _unitNameFieldController = TextEditingController();
  final _unitCodeFieldController = TextEditingController();

  String _unitName = "";
  String _unitCode = "";
  String _unitCodeHint = "";

  String _newUnitValue = "";
  String _baseUnitValue = "";

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      ButtonColorSet floatingButtonColor =
          unitsPageFloatingButtonColors[appState.theme]!;

      return MultiBlocListener(
        listeners: [
          BlocListener<UnitsBloc, UnitsState>(
            listener: (_, unitsState) {
              if (unitsState is UnitExists) {
                showAlertDialog(
                  context,
                  message: "Unit '${unitsState.unitName}' already exist",
                );
              } else if (unitsState is UnitsFetched) {
                Navigator.of(context).pop();
              }
            },
          ),
          BlocListener<UnitDetailsBloc, UnitDetailsState>(
            listener: (_, unitDetailsState) {
              if (unitDetailsState is UnitDetailsNotificationState) {
                showSnackBar(
                  context,
                  message: unitDetailsState.message,
                  severity: unitDetailsState.severity,
                  theme: appState.theme,
                );
              }
            },
          ),
        ],
        child: unitDetailsBlocBuilder((pageState) {
          return ConvertouchPage(
            title: "Add Unit",
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(7, 10, 7, 60),
                child: Column(
                  children: [
                    pageState.unitDetails.unitGroup != null
                        ? ConvertouchMenuItem(
                            pageState.unitDetails.unitGroup!,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              BlocProvider.of<UnitGroupsBlocForUnitDetails>(
                                context,
                              ).add(
                                FetchUnitGroupsForUnitDetails(
                                  currentUnitGroupInUnitDetails:
                                      pageState.unitDetails.unitGroup!,
                                  searchString: null,
                                ),
                              );
                              Navigator.of(context).pushNamed(
                                PageName.unitGroupsPageForUnitDetails.name,
                              );
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
                          _unitCodeHint = _getInitialUnitCodeByName(value);
                        });
                      },
                      theme: appState.theme,
                    ),
                    ConvertouchTextBox(
                      label: 'Unit Code',
                      controller: _unitCodeFieldController,
                      onChanged: (String value) async {
                        setState(() {
                          _unitCode = value;
                        });
                      },
                      maxTextLength: _unitCodeMaxLength,
                      textLengthCounterVisible: true,
                      hintText: _unitCodeHint,
                      theme: appState.theme,
                    ),
                    pageState.unitDetails.argumentUnit != null
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
                                  ConversionItemModel.fromStrValue(
                                    unit: UnitModel(
                                      name: _unitName,
                                      code: _unitCode.isNotEmpty
                                          ? _unitCode
                                          : _unitCodeHint,
                                      unitGroupId:
                                          pageState.unitDetails.unitGroup!.id!,
                                    ),
                                    strValue: _newUnitValue,
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
                                  ConversionItemModel.fromStrValue(
                                    unit: pageState.unitDetails.argumentUnit!,
                                    strValue: _baseUnitValue,
                                  ),
                                  onValueChanged: (value) {
                                    setState(() {
                                      _baseUnitValue = value;
                                    });
                                  },
                                  onTap: () {
                                    BlocProvider.of<UnitsBlocForUnitDetails>(
                                      context,
                                    ).add(
                                      FetchUnitsForUnitDetails(
                                        unitGroup:
                                            pageState.unitDetails.unitGroup!,
                                        currentSelectedBaseUnit:
                                            pageState.unitDetails.argumentUnit,
                                        searchString: null,
                                      ),
                                    );
                                    Navigator.of(context).pushNamed(
                                      PageName.unitsPageForUnitDetails.name,
                                    );
                                  },
                                  theme: appState.theme,
                                ),
                              ),
                              const SizedBox(height: 25),
                            ],
                          )
                        : empty(),
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
                    unitDetails: UnitDetailsModel(
                      unitGroup: pageState.unitDetails.unitGroup!,
                      unitName: _unitName,
                      unitCode:
                          _unitCode.isNotEmpty ? _unitCode : _unitCodeHint,
                      unitValue: _newUnitValue,
                      argumentUnit: pageState.unitDetails.argumentUnit,
                      argumentUnitValue: _baseUnitValue,
                    ),
                  ),
                );
              },
              colorSet: floatingButtonColor,
            ),
          );
        }),
      );
    });
  }

  @override
  void dispose() {
    _unitNameFieldController.dispose();
    _unitCodeFieldController.dispose();
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

const int _unitCodeMaxLength = 4;

String _getInitialUnitCodeByName(String unitName) {
  return unitName.length > _unitCodeMaxLength
      ? unitName.substring(0, _unitCodeMaxLength)
      : unitName;
}
