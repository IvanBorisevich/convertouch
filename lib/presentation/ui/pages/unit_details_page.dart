import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
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
      ConvertouchColorScheme unitPageInfoBoxColor =
          unitPageInfoBoxColors[appState.theme]!;

      return unitDetailsBlocBuilder((pageState) {
        _unitNameTextController.text = pageState.draftDetails.unit.name;
        _unitCodeTextController.text = pageState.draftDetails.unit.code;

        return ConvertouchPage(
          title: pageState.isExistingUnit
              ? pageState.savedDetails.unit.name
              : "New Unit",
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 15, 12, 60),
              child: Column(
                children: [
                  (pageState.draftDetails.unit.coefficient != 1 &&
                                  pageState.isExistingUnit ||
                              !pageState.isExistingUnit) &&
                          pageState.draftDetails.unitGroup != null
                      ? Column(
                          children: [
                            ConvertouchMenuItem(
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
                              },
                              disabled: pageState.draftDetails.unit.oob,
                              theme: appState.theme,
                              itemsViewMode: ItemsViewMode.list,
                            ),
                            const SizedBox(height: 20),
                          ],
                        )
                      : empty(),
                  ConvertouchTextBox(
                    label: 'Unit Name',
                    disabled: pageState.draftDetails.unit.oob,
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
                    disabled: pageState.draftDetails.unit.oob,
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
                  LayoutBuilder(builder: (context, constrains) {
                    if (pageState.note != null) {
                      return ConvertouchInfoBox(
                        background: unitPageInfoBoxColor.background.regular,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: pageState.note!,
                              ),
                            ],
                            style: TextStyle(
                              color: textBoxColor.foreground.regular,
                              fontWeight: FontWeight.w500,
                              fontFamily: quicksandFontFamily,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Visibility(
                        visible: pageState.conversionRuleVisible,
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
                                unit: UnitModel(
                                  name: pageState.draftDetails.unit.named
                                      ? pageState.draftDetails.unit.name
                                      : pageState.savedDetails.unit.name,
                                  code: pageState
                                          .draftDetails.unit.code.isNotEmpty
                                      ? pageState.draftDetails.unit.code
                                      : pageState.savedDetails.unit.code,
                                ),
                                value: pageState.draftDetails.value,
                                defaultValue: pageState.savedDetails.value,
                              ),
                              valueType: pageState
                                      .draftDetails.unit.valueType ??
                                  pageState.draftDetails.unitGroup!.valueType,
                              disabled: !pageState.conversionRuleEnabled,
                              onValueChanged: (value) {
                                BlocProvider.of<UnitDetailsBloc>(context).add(
                                  UpdateUnitValueInUnitDetails(
                                    newValue: value,
                                  ),
                                );
                              },
                              theme: appState.theme,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ConvertouchConversionItem(
                              ConversionItemModel(
                                unit: pageState.draftDetails.argUnit,
                                value: pageState.draftDetails.argValue,
                                defaultValue: pageState.savedDetails.argValue,
                              ),
                              valueType: pageState
                                      .draftDetails.argUnit.valueType ??
                                  pageState.draftDetails.unitGroup!.valueType,
                              disabled: !pageState.conversionRuleEnabled,
                              onValueChanged: (value) {
                                BlocProvider.of<UnitDetailsBloc>(context).add(
                                  UpdateArgumentUnitValueInUnitDetails(
                                    newValue: value,
                                  ),
                                );
                              },
                              onTap: () {
                                if (pageState.conversionRuleEnabled) {
                                  BlocProvider.of<UnitsBlocForUnitDetails>(
                                    context,
                                  ).add(
                                    FetchUnitsForUnitDetails(
                                      unitGroup:
                                          pageState.draftDetails.unitGroup!,
                                      selectedArgUnit:
                                          pageState.draftDetails.argUnit,
                                      currentEditedUnit:
                                          pageState.draftDetails.unit,
                                      searchString: null,
                                    ),
                                  );
                                }
                              },
                              theme: appState.theme,
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
          floatingActionButton: conversionBlocBuilder((conversionState) {
            return ConvertouchFloatingActionButton(
              icon: Icons.check_outlined,
              visible: pageState.unitToBeSaved != null,
              onClick: () {
                FocusScope.of(context).unfocus();
                if (pageState.unitToBeSaved != null) {
                  BlocProvider.of<UnitsBloc>(context).add(
                    SaveUnit(
                      unitToBeSaved: pageState.unitToBeSaved!,
                      unitGroup: pageState.draftDetails.unitGroup!,
                      prevUnitGroupId: pageState.savedDetails.unitGroup!.id!,
                      conversionGroupId:
                          conversionState.conversion.unitGroup?.id,
                    ),
                  );
                }
              },
              colorScheme: floatingButtonColor,
            );
          }),
        );
      });
    });
  }

  @override
  void dispose() {
    _unitNameTextController.dispose();
    _unitCodeTextController.dispose();
    super.dispose();
  }
}
