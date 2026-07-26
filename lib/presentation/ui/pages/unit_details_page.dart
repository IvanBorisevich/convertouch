import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_states.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/groups_controller.dart';
import 'package:convertouch/presentation/controller/unit_details_controller.dart';
import 'package:convertouch/presentation/controller/units_controller.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/details_item.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box_icon.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_list_item.dart';
import 'package:convertouch/presentation/ui/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

const double _spacing = 10;
const double _bottomSpacing = 85;
const double _unitButtonWidth = 76;

class ConvertouchUnitDetailsPage extends StatelessWidget {
  const ConvertouchUnitDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder(
      builderFunc: (appState) {
        InputBoxColorScheme detailsItemColors =
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
                  padding: const EdgeInsets.only(
                    top: _spacing,
                    left: _spacing,
                    right: _spacing,
                    bottom: _bottomSpacing,
                  ),
                  child: Column(
                    children: [
                      pageState.details.editMode
                          ? ConvertouchMenuListItem(
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
                            )
                          : ConvertouchDetailsItem(
                              name: 'Unit Group',
                              savedValue: pageState.details.unitGroup.name,
                              visible: true,
                              colors: detailsItemColors,
                              dialogColors: dialogColors,
                              theme: appState.theme,
                            ),
                      ConvertouchDetailsItem(
                        name: 'Unit Name',
                        draftValue: pageState.details.draftUnitData.name,
                        savedValue: pageState.details.savedUnitData.name,
                        editable: pageState.details.editMode,
                        colors: detailsItemColors,
                        dialogColors: dialogColors,
                        theme: appState.theme,
                        topMargin: _spacing,
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
                        topMargin: _spacing,
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
                        topMargin: _spacing,
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
                        topMargin: _spacing,
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
                        topMargin: _spacing,
                      ),
                      _conversionRule(
                        context,
                        pageState: pageState,
                        detailsItemColors: detailsItemColors,
                        dialogColors: dialogColors,
                        theme: appState.theme,
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

  Widget _conversionRule(
    BuildContext context, {
    required UnitDetailsReady pageState,
    required InputBoxColorScheme detailsItemColors,
    required WidgetColorScheme dialogColors,
    required ConvertouchUITheme theme,
  }) {
    if (pageState.details.editMode &&
        pageState.details.conversionRule.configVisible) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 5,
            ),
            child: Text(
              'Conversion Rule',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: detailsItemColors.textBox.label.regular,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(height: 7),
          ConvertouchConversionItem(
            model: ConversionUnitValueModel(
              unit: pageState.details.resultUnit,
              value: pageState.details.conversionRule.unitValue,
              defaultValue: ValueModel.one,
            ),
            readonly: !pageState.details.conversionRule.configEditable,
            suffixWidgets: [
              ConvertouchInputBoxIcon.suffix(
                width: _unitButtonWidth,
                dividerColor:
                    appColors[theme].conversionItem.inputBox.divider.regular,
                visible: pageState.details.resultUnit.exists,
                builder: () => Text(
                  pageState.details.resultUnit.code,
                  style: TextStyle(
                    color: appColors[theme].conversionItem.unitButton.regular,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                ),
              ),
            ],
            onValueChanged: (value, {listValues}) {
              unitDetailsController.updateUnitValue(
                context,
                newValue: value,
              );
            },
            colors: appColors[theme].conversionItem,
            dialogColors: dialogColors,
            theme: theme,
          ),
          const SizedBox(height: _spacing),
          ConvertouchConversionItem(
            model: ConversionUnitValueModel(
              unit: pageState.details.conversionRule.argUnit,
              value: pageState.details.conversionRule.draftArgValue,
              defaultValue: pageState.details.conversionRule.savedArgValue,
            ),
            readonly: !pageState.details.conversionRule.configEditable,
            tooltipDirection: TooltipDirection.up,
            suffixWidgets: [
              ConvertouchInputBoxIcon.suffix(
                width: _unitButtonWidth,
                dividerColor:
                    appColors[theme].conversionItem.inputBox.divider.regular,
                visible: pageState.details.conversionRule.argUnit.exists,
                onTap: () {
                  FocusScope.of(context).unfocus();

                  unitsController.showArgUnitsForChange(
                    context,
                    currentUnitId: pageState.details.resultUnit.id,
                    currentGroupId: pageState.details.unitGroup.id,
                    currentArgUnitId:
                        pageState.details.conversionRule.argUnit.id,
                  );
                },
                builder: () => Text(
                  pageState.details.conversionRule.argUnit.code,
                  style: TextStyle(
                    color: appColors[theme].conversionItem.unitButton.regular,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                ),
              ),
            ],
            onValueChanged: (value, {listValues}) {
              unitDetailsController.updateArgUnitValue(
                context,
                newValue: value,
              );
            },
            colors: appColors[theme].conversionItem,
            dialogColors: dialogColors,
            theme: theme,
          ),
        ],
      );
    } else if (pageState.details.conversionRule.readOnlyDescription != null ||
        pageState.details.conversionRule.configVisible) {
      return ConvertouchDetailsItem(
        name: 'Conversion Rule',
        savedValue: pageState.details.conversionRule.readOnlyDescription,
        colors: detailsItemColors,
        dialogColors: dialogColors,
        theme: theme,
        topMargin: _spacing,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
