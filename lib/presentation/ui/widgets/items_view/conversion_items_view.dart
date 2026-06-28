import 'dart:developer';

import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_states.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/unit_details_controller.dart';
import 'package:convertouch/presentation/controller/units_controller.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/no_items_info_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const double _spacing = 10;
const double _bottomSpacing = 85;

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
    return BlocBuilder<ConversionBloc, ConversionState>(
      buildWhen: (prev, next) {
        return prev != next &&
            next is ConversionBuilt &&
            next.rebuildUnitValues;
      },
      builder: (_, conversionState) {
        log("${DateTime.now()} - conversion item view bloc builder()");

        if (conversionState is! ConversionBuilt) {
          return const SizedBox.shrink();
        }

        if (conversionState.conversion.convertedUnitValues.isEmpty) {
          return Center(
            child: NoItemsInfoLabel(
              text: "No conversion items added",
              colors: appColors[theme].unitsMenu.noItemsInfoBox,
            ),
          );
        }

        final unitGroup = conversionState.conversion.unitGroup;
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
              child: BlocBuilder<ConversionUnitValueBloc,
                  ConversionUnitValueState>(
                buildWhen: (prev, next) {
                  return prev != next &&
                      (next is ConversionUnitValueInitialState ||
                          next.id == unitValue.id);
                },
                builder: (_, itemState) {
                  final resultUnitValue =
                      itemState is ConversionUnitValueInitialState
                          ? unitValue
                          : (itemState.id == unitValue.id
                              ? itemState.value!
                              : unitValue);

                  log("${DateTime.now()} - conversion item view builder() resultUnitValue = $resultUnitValue, unit value state: $itemState");

                  final isSource = itemState is ConversionUnitValueInitialState
                      ? unitValue.unit.id == srcUnitId
                      : itemState.isSource;

                  return ConvertouchConversionItem(
                    model: resultUnitValue,
                    draggable: true,
                    index: index,
                    readonly: !resultUnitValue.unit.invertible,
                    isSource: isSource,
                    isLast: isLast,
                    removable: removable,
                    onUnitItemTap: () {
                      if (unitTapAction == UnitTapAction.selectReplacingUnit) {
                        unitsController.showUnitsForChangeInConversionItem(
                          context,
                          currentUnitId: resultUnitValue.unit.id,
                          unitGroupId: unitGroup.id,
                          convertedUnitValues: unitValues,
                        );
                      } else if (unitTapAction == UnitTapAction.showUnitInfo) {
                        unitDetailsController.showUnitDetails(
                          context,
                          unit: resultUnitValue.unit,
                          unitGroup: unitGroup,
                        );
                      }
                    },
                    onValueChanged: (value) {
                      conversionController.editConversionItemValue(
                        context,
                        unitId: resultUnitValue.unit.id,
                        newValue: value,
                      );
                    },
                    onItemRemoved: () {
                      conversionController.removeConversionItem(
                        context,
                        unitId: resultUnitValue.unit.id,
                      );
                    },
                    colors: appColors[theme].conversionItem,
                    dialogColors: appColors[theme].dialog,
                    theme: theme,
                  );
                },
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
