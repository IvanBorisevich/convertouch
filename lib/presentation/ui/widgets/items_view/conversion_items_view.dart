import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_states.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/conversion_item_controller.dart';
import 'package:convertouch/presentation/controller/unit_details_controller.dart';
import 'package:convertouch/presentation/controller/units_controller.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/no_items_info_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const double _spacing = 10;
const double _bottomSpacing = 85;

class ConvertouchConversionItemsView extends StatefulWidget {
  final UnitTapAction unitTapAction;
  final ConvertouchUITheme theme;

  const ConvertouchConversionItemsView({
    required this.unitTapAction,
    required this.theme,
    super.key,
  });

  @override
  State createState() => _ConvertouchConversionItemsViewState();
}

class _ConvertouchConversionItemsViewState
    extends State<ConvertouchConversionItemsView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConversionBloc, ConversionState>(
      listener: (_, state) {
        if (state is ConversionBuilt && state.rebuildUnitValues) {
          conversionItemController.resetItemValues(context);
        }
      },
      buildWhen: (prev, next) =>
          next is ConversionBuilt && next.rebuildUnitValues,
      builder: (_, conversionState) {
        print("Rebuild entire unit values list");

        if (conversionState is! ConversionBuilt) {
          return const SizedBox.shrink();
        }

        if (conversionState.conversion.convertedUnitValues.isEmpty) {
          return Center(
            child: NoItemsInfoLabel(
              text: "No conversion items added",
              colors: appColors[widget.theme].unitsMenu.noItemsInfoBox,
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
              key: Key('$index'),
              padding: const EdgeInsets.only(
                bottom: _spacing,
              ),
              child: BlocBuilder<ConversionItemBloc, ConversionItemState>(
                buildWhen: (prev, next) {
                  return prev != next &&
                      (next is ConversionItemInitialState ||
                          next.id == unitValue.id);
                },
                builder: (_, itemState) {
                  final resultUnitValue =
                      itemState is ConversionItemInitialState
                          ? unitValue
                          : (itemState.value! as ConversionUnitValueModel);

                  final isSource = itemState is ConversionItemInitialState
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
                      if (widget.unitTapAction ==
                          UnitTapAction.selectReplacingUnit) {
                        unitsController.showUnitsForChangeInConversionItem(
                          context,
                          currentUnitId: resultUnitValue.unit.id,
                          unitGroupId: unitGroup.id,
                          convertedUnitValues: unitValues,
                        );
                      } else if (widget.unitTapAction ==
                          UnitTapAction.showUnitInfo) {
                        unitDetailsController.showUnitDetails(
                          context,
                          unit: resultUnitValue.unit,
                          unitGroup: unitGroup,
                        );
                      }
                    },
                    onValueChanged: (value) {
                      conversionController.changeConversionItemValue(
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
                    colors: appColors[widget.theme].conversionItem,
                    dialogColors: appColors[widget.theme].dialog,
                  );
                },
              ),
            );
          },
          onReorderStart: (index) {
            FocusScope.of(context).unfocus();
          },
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final ConversionUnitValueModel item =
                  unitValues.removeAt(oldIndex);
              unitValues.insert(newIndex, item);
            });
          },
        );
      },
    );
  }
}
