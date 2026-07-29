import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/unit_details_controller.dart';
import 'package:convertouch/presentation/controller/units_controller.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box_icon.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/no_items_info_label.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

const double _spacing = 10;
const double _bottomSpacing = 85;
const double _dragHandlerWidth = 35;
const double _removalButtonWidth = 35;
const double _unitButtonWidth = 76;

class ConvertouchConversionItemsView extends StatelessWidget {
  final UnitTapAction unitTapAction;
  final ConvertouchUITheme theme;

  const ConvertouchConversionItemsView({
    required this.unitTapAction,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return conversionBlocBuilder(
      builderFunc: (conversionState) {
        if (conversionState.conversion.convertedUnitValues.isEmpty) {
          return Center(
            child: NoItemsInfoLabel(
              text: "No conversion items added",
              colors: appColors[theme].unitsMenu.noItemsInfoBox,
            ),
          );
        }

        final unitGroup = conversionState.conversion.unitGroup;
        final params = conversionState.conversion.params?.active;
        final srcUnitId = conversionState.conversion.srcUnitValue?.unit.id;
        final unitValues = conversionState.conversion.convertedUnitValues;
        final removable = unitValues.length > minimumNumberOfConversionItems;

        return ReorderableListView.builder(
          itemCount: unitValues.length,
          buildDefaultDragHandles: false,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          proxyDecorator: (child, index, animation) {
            return Material(
              key: ValueKey(index),
              color: Colors.transparent,
              child: child,
            );
          },
          padding: const EdgeInsets.only(
            top: _spacing,
            bottom: _bottomSpacing,
            left: _spacing,
            right: _spacing,
          ),
          itemBuilder: (context, index) {
            final unitValue = unitValues[index];
            bool isLast = index == unitValues.length - 1;

            return Padding(
              key: ValueKey(unitValue.id),
              padding: const EdgeInsets.only(
                bottom: _spacing,
              ),
              child: ConvertouchConversionItem(
                model: unitValue,
                conversionGroupName: unitGroup.name,
                conversionParams: params,
                readonly: !unitValue.unit.invertible,
                tooltipDirection:
                    isLast ? TooltipDirection.up : TooltipDirection.down,
                prefixIcons: [
                  InputBoxIconModel.iconWithDivider(
                    width: 30,
                    builder: () => ReorderableDragStartListener(
                      index: index,
                      child: Container(
                        width: _dragHandlerWidth,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: unitValue.unit.id == srcUnitId
                            ? Text(
                                '𝑥',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  height: -0.3,
                                  color: appColors[theme]
                                      .conversionItem
                                      .prefixWidget
                                      .selected,
                                ),
                              )
                            : Icon(
                                Icons.drag_indicator_outlined,
                                color: appColors[theme]
                                    .conversionItem
                                    .prefixWidget
                                    .regular,
                                size: 20,
                              ),
                      ),
                    ),
                  ),
                ],
                suffixIcons: [
                  InputBoxIconModel.iconWithDivider(
                    width: _unitButtonWidth,
                    visible: unitValue.unitItem != null &&
                        unitValue.unitItem!.exists,
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      if (unitTapAction == UnitTapAction.selectReplacingUnit) {
                        unitsController.showUnitsForChangeInConversionItem(
                          context,
                          currentUnitId: unitValue.unit.id,
                          unitGroupId: unitGroup.id,
                          convertedUnitValues: unitValues,
                        );
                      } else if (unitTapAction == UnitTapAction.showUnitInfo) {
                        unitDetailsController.showUnitDetails(
                          context,
                          unit: unitValue.unit,
                          unitGroup: unitGroup,
                        );
                      }
                    },
                    builder: () => Center(
                      child: Text(
                        unitValue.unitItem!.code,
                        style: TextStyle(
                          color: appColors[theme]
                              .conversionItem
                              .unitButton
                              .regular,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  InputBoxIconModel.iconWithDivider(
                    width: _removalButtonWidth,
                    visible: removable,
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      conversionController.removeConversionItem(
                        context,
                        unitId: unitValue.unit.id,
                      );
                    },
                    builder: () => Icon(
                      Icons.remove,
                      color:
                          appColors[theme].conversionItem.removalIcon.regular,
                      size: 20,
                    ),
                  ),
                ],
                onValueChanged: (value, {listValues}) {
                  conversionController.editConversionUnitValue(
                    context,
                    unitId: unitValue.unit.id,
                    newValue: value,
                    listValues: listValues,
                  );
                },
                colors: appColors[theme].conversionItem,
                dialogColors: appColors[theme].dialog,
                theme: theme,
              ),
            );
          },
          onReorderStart: (index) {
            FocusScope.of(context).unfocus();
          },
          onReorder: (int oldIndex, int newIndex) {
            conversionController.moveConversionUnitValue(
              context,
              oldIndex: oldIndex,
              newIndex: newIndex,
            );
          },
        );
      },
    );
  }
}
