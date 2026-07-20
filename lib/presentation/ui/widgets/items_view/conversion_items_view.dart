import 'dart:developer';

import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
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
        return prev != next && next is ConversionBuilt;
      },
      builder: (_, conversionState) {
        if (conversionState is! ConversionBuilt) {
          return const SizedBox.shrink();
        }

        log("Unit values view ConversionBloc builder(), "
            "state: $conversionState");

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

            log("ConversionItemsView list view itemBuilder(), "
                "unit value: $unitValue");

            return Padding(
              key: ValueKey(unitValue.id),
              padding: const EdgeInsets.only(
                bottom: _spacing,
              ),
              child: ConvertouchConversionItem(
                model: unitValue,
                conversionGroupName: unitGroup.name,
                conversionParams: params,
                draggable: true,
                index: index,
                readonly: !unitValue.unit.invertible,
                isSource: unitValue.unit.id == srcUnitId,
                isLast: isLast,
                removable: removable,
                onUnitItemTap: () {
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
                onValueChanged: (value, {listValues}) {
                  conversionController.editConversionUnitValue(
                    context,
                    unitId: unitValue.unit.id,
                    newValue: value,
                    listValues: listValues,
                  );
                },
                onItemRemoved: () {
                  conversionController.removeConversionItem(
                    context,
                    unitId: unitValue.unit.id,
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
