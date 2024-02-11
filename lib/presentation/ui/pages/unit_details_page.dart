import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_states.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_unit_details.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_unit_details.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
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
  final _unitNameTextController = TextEditingController();
  final _unitCodeTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      ButtonColorSet floatingButtonColor =
          unitsPageFloatingButtonColors[appState.theme]!;

      return MultiBlocListener(
        listeners: [
          unitDetailsListener(context: context, handlers: {
            UnitDetailsNotificationState: (state) {
              showSnackBar(
                context,
                exception: (state as UnitDetailsNotificationState).exception,
                theme: appState.theme,
              );
            },
          }),
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
        ],
        child: unitDetailsBlocBuilder((pageState) {
          _unitNameTextController.text = pageState.draftDetails.unit.name;
          _unitCodeTextController.text = pageState.draftDetails.unit.code;

          return ConvertouchPage(
            title: pageState.editMode ? "Edit Unit" : "Add Unit",
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(7, 10, 7, 60),
                child: Column(
                  children: [
                    pageState.draftDetails.unitGroup != null
                        ? ConvertouchMenuItem(
                            pageState.draftDetails.unitGroup!,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              BlocProvider.of<UnitGroupsBlocForUnitDetails>(
                                context,
                              ).add(
                                FetchUnitGroupsForUnitDetails(
                                  currentUnitGroupInUnitDetails:
                                      pageState.draftDetails.unitGroup!,
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
                      controller: _unitNameTextController,
                      onChanged: (String value) async {
                        BlocProvider.of<UnitDetailsBloc>(context).add(
                          UpdateUnitNameInUnitDetails(
                            newValue: value,
                          ),
                        );
                      },
                      hintText: pageState.savedDetails.unit.name,
                      theme: appState.theme,
                    ),
                    ConvertouchTextBox(
                      label: 'Unit Code',
                      controller: _unitCodeTextController,
                      onChanged: (String value) async {
                        BlocProvider.of<UnitDetailsBloc>(context).add(
                          UpdateUnitCodeInUnitDetails(
                            newValue: value,
                          ),
                        );
                      },
                      maxTextLength: UnitDetailsModel.unitCodeMaxLength,
                      textLengthCounterVisible: true,
                      hintText: pageState.savedDetails.unit.code,
                      theme: appState.theme,
                    ),
                    Visibility(
                      visible: pageState.showConversionRule,
                      child: Column(
                        children: [
                          _horizontalDividerWithText(
                            "Conversion Rule",
                            appState.theme,
                          ),
                          const SizedBox(height: 25),
                          ConvertouchConversionItem(
                            ConversionItemModel(
                              unit: UnitModel(
                                name: pageState.draftDetails.unit.named
                                    ? pageState.draftDetails.unit.name
                                    : pageState.savedDetails.unit.name,
                                code:
                                    pageState.draftDetails.unit.code.isNotEmpty
                                        ? pageState.draftDetails.unit.code
                                        : pageState.savedDetails.unit.code,
                              ),
                              value: pageState.draftDetails.value,
                              defaultValue: pageState.savedDetails.value,
                            ),
                            onValueChanged: (value) {
                              BlocProvider.of<UnitDetailsBloc>(context).add(
                                UpdateUnitValueInUnitDetails(
                                  newValue: value,
                                ),
                              );
                            },
                            theme: appState.theme,
                          ),
                          const SizedBox(height: 9),
                          ConvertouchConversionItem(
                            ConversionItemModel(
                              unit: pageState.draftDetails.argUnit,
                              value: pageState.draftDetails.argValue,
                              defaultValue: pageState.savedDetails.argValue,
                            ),
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
                                  unitGroup: pageState.draftDetails.unitGroup!,
                                  selectedArgUnit:
                                      pageState.draftDetails.argUnit,
                                  currentEditedUnit:
                                      pageState.draftDetails.unit,
                                  searchString: null,
                                ),
                              );
                              Navigator.of(context).pushNamed(
                                PageName.unitsPageForUnitDetails.name,
                              );
                            },
                            theme: appState.theme,
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: ConvertouchFloatingActionButton(
              icon: Icons.check_outlined,
              visible: pageState.unitToBeSaved != null,
              onClick: () {
                FocusScope.of(context).unfocus();
                if (pageState.unitToBeSaved != null) {
                  BlocProvider.of<UnitsBloc>(context).add(
                    SaveUnit(
                      unitToBeSaved: pageState.unitToBeSaved!,
                      unitGroup: pageState.draftDetails.unitGroup!,
                    ),
                  );
                }
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
    _unitNameTextController.dispose();
    _unitCodeTextController.dispose();
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
