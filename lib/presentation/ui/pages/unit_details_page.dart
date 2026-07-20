import 'dart:developer';

import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/groups_controller.dart';
import 'package:convertouch/presentation/controller/unit_details_controller.dart';
import 'package:convertouch/presentation/controller/units_controller.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/details_item.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_list_item.dart';
import 'package:convertouch/presentation/ui/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

const double _verticalSpacing = 12;

const EdgeInsets _pagePadding = EdgeInsets.only(
  left: 10,
  right: 10,
  bottom: 70,
);

class ConvertouchUnitDetailsPage extends StatelessWidget {
  const ConvertouchUnitDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    log("ConvertouchUnitDetailsPage build()");

    return appBlocBuilder(
      builderFunc: (appState) {
        DetailsItemColorsScheme detailsItemColors =
            appColors[appState.theme].unitDetailsInputBox;
        WidgetColorScheme floatingButtonColor =
            appColors[appState.theme].unitsPageFloatingButton;
        WidgetColorScheme dialogColors = appColors[appState.theme].dialog;

        return unitDetailsBlocBuilder(
          builderFunc: (pageState) {
            return ConvertouchPage(
              title: pageState.details.existingUnit ? 'Unit Info' : 'New Unit',
              colors: appColors[appState.theme].page,
              body: SingleChildScrollView(
                child: Container(
                  padding: _pagePadding,
                  child: Column(
                    children: [
                      pageState.details.editMode
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: _verticalSpacing,
                              ),
                              child: ConvertouchMenuListItem(
                                pageState.details.unitGroup,
                                checkIconVisible: false,
                                checkIconVisibleIfUnchecked: false,
                                checked: false,
                                colors: appColors[appState.theme]
                                    .unitGroupsMenu
                                    .menuItem,
                                disabled: false,
                                editIconVisible: false,
                                logoFunc: (
                                  item, {
                                  required Color foreground,
                                  required Color matchForeground,
                                  required Color matchBackground,
                                  required double fontSize,
                                  required double iconSize,
                                }) {
                                  return ConvertouchSvgIcon.group(
                                    iconUri: item.iconName,
                                    defaultColor: foreground,
                                    size: iconSize,
                                  );
                                },
                                onTap: () {
                                  FocusScope.of(context).unfocus();

                                  groupsController
                                      .showGroupsForChangeInUnitDetails(
                                    context,
                                    currentGroupId:
                                        pageState.details.unitGroup.id,
                                  );
                                },
                              ),
                            )
                          : ConvertouchDetailsItem(
                              name: 'Unit Group',
                              savedValue: pageState.details.unitGroup.name,
                              visible: true,
                              colors: detailsItemColors,
                              dialogColors: dialogColors,
                              theme: appState.theme,
                              topMargin: _verticalSpacing,
                            ),
                      ConvertouchDetailsItem(
                        name: 'Unit Name',
                        draftValue: pageState.details.draftUnitData.name,
                        savedValue: pageState.details.savedUnitData.name,
                        editable: pageState.details.editMode,
                        colors: detailsItemColors,
                        dialogColors: dialogColors,
                        theme: appState.theme,
                        topMargin: _verticalSpacing,
                        onValueChanged: (value) {
                          unitDetailsController.updateUnitName(
                            context,
                            newValue: value,
                          );
                        },
                      ),
                      ConvertouchDetailsItem(
                        name: 'Unit Code',
                        draftValue: pageState.details.draftUnitData.code,
                        savedValue: pageState.details.savedUnitData.code,
                        editable: pageState.details.editMode,
                        colors: detailsItemColors,
                        dialogColors: dialogColors,
                        theme: appState.theme,
                        topMargin: _verticalSpacing,
                        editableValueMaxLength:
                            UnitDetailsModel.unitCodeMaxLength,
                        editableValueLengthVisible: true,
                        onValueChanged: (value) {
                          unitDetailsController.updateUnitCode(
                            context,
                            newValue: value,
                          );
                        },
                      ),
                      ConvertouchDetailsItem(
                        name: 'Value Type',
                        savedValue:
                            pageState.details.draftUnitData.valueType.name,
                        colors: detailsItemColors,
                        dialogColors: dialogColors,
                        theme: appState.theme,
                        topMargin: _verticalSpacing,
                      ),
                      ConvertouchDetailsItem(
                        name: 'Min Value',
                        savedValue:
                            pageState.details.savedUnitData.minValue?.itemName,
                        visible:
                            pageState.details.savedUnitData.minValue != null,
                        colors: detailsItemColors,
                        dialogColors: dialogColors,
                        theme: appState.theme,
                        topMargin: _verticalSpacing,
                      ),
                      ConvertouchDetailsItem(
                        name: 'Max Value',
                        savedValue:
                            pageState.details.savedUnitData.maxValue?.itemName,
                        visible:
                            pageState.details.savedUnitData.maxValue != null,
                        colors: detailsItemColors,
                        dialogColors: dialogColors,
                        theme: appState.theme,
                        topMargin: _verticalSpacing,
                      ),
                      ConvertouchDetailsItem(
                        name: 'Conversion Rule',
                        nameVisible: pageState.details.conversionRule
                                    .readOnlyDescription !=
                                null ||
                            pageState.details.conversionRule.configVisible,
                        savedValue: pageState
                            .details.conversionRule.readOnlyDescription,
                        colors: detailsItemColors,
                        dialogColors: dialogColors,
                        theme: appState.theme,
                        topMargin: _verticalSpacing,
                        content: Visibility(
                          visible: pageState.details.editMode &&
                              pageState.details.conversionRule.configVisible,
                          child: Column(
                            children: [
                              const SizedBox(height: 7),
                              ConvertouchConversionItem(
                                model: ConversionUnitValueModel(
                                  unit: pageState.details.resultUnit,
                                  value: pageState
                                      .details.conversionRule.unitValue,
                                  defaultValue: ValueModel.one,
                                ),
                                readonly: !pageState
                                    .details.conversionRule.configEditable,
                                onValueChanged: (value, {listValues}) {
                                  unitDetailsController.updateUnitValue(
                                    context,
                                    newValue: value,
                                  );
                                },
                                colors:
                                    appColors[appState.theme].conversionItem,
                                dialogColors: dialogColors,
                                theme: appState.theme,
                              ),
                              const SizedBox(height: 8),
                              ConvertouchConversionItem(
                                model: ConversionUnitValueModel(
                                  unit:
                                      pageState.details.conversionRule.argUnit,
                                  value: pageState
                                      .details.conversionRule.draftArgValue,
                                  defaultValue: pageState
                                      .details.conversionRule.savedArgValue,
                                ),
                                readonly: !pageState
                                    .details.conversionRule.configEditable,
                                isLast: true,
                                onValueChanged: (value, {listValues}) {
                                  unitDetailsController.updateArgUnitValue(
                                    context,
                                    newValue: value,
                                  );
                                },
                                onUnitItemTap: () {
                                  unitsController.showArgUnitsForChange(
                                    context,
                                    currentUnitId:
                                        pageState.details.resultUnit.id,
                                    currentGroupId:
                                        pageState.details.unitGroup.id,
                                    currentArgUnitId: pageState
                                        .details.conversionRule.argUnit.id,
                                  );
                                },
                                colors:
                                    appColors[appState.theme].conversionItem,
                                dialogColors: dialogColors,
                                theme: appState.theme,
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

                      unitsController.save(
                        context,
                        unit: pageState.details.resultUnit,
                        currentGroupId: pageState.details.unitGroup.id,
                        onSaved: (savedUnit) {
                          conversionController.editConversionItemUnit(
                            context,
                            modifiedUnit: savedUnit,
                          );
                        },
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
}
