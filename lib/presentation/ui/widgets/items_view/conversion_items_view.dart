import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_values_model.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/conversion_params_view.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/no_items_info_label.dart';
import 'package:convertouch/presentation/ui/widgets/scroll/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItemsView extends StatefulWidget {
  final List<ConversionUnitValueModel> convertedItems;
  final ConvertouchValueType parentValueType;
  final void Function(ConversionUnitValueModel)? onUnitItemTap;
  final void Function(ConversionUnitValueModel, String?)? onTextValueChanged;
  final void Function(ConversionUnitValueModel)? onItemRemoveTap;
  final double listItemSpacingAfterLast;
  final ConvertouchUITheme theme;

  const ConvertouchConversionItemsView(
    this.convertedItems, {
    required this.parentValueType,
    this.onUnitItemTap,
    this.onTextValueChanged,
    this.onItemRemoveTap,
    this.listItemSpacingAfterLast = 90,
    required this.theme,
    super.key,
  });

  @override
  State createState() => _ConvertouchConversionItemsViewState();
}

class _ConvertouchConversionItemsViewState
    extends State<ConvertouchConversionItemsView> {
  static const double _itemsSpacing = 14;
  static const double _itemPadding = _itemsSpacing / 2;
  static const double _bottomSpacing = 85;

  @override
  Widget build(BuildContext context) {
    if (widget.convertedItems.isEmpty) {
      return Center(
        child: NoItemsInfoLabel(
          text: "No conversion items added",
          colors: unitPageEmptyViewColor[widget.theme]!,
        ),
      );
    }

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: Column(
        children: [
          ConversionParamsView(
            paramSetValues: ConversionParamSetValuesModel(
                paramSet: const ConversionParamSetModel(
                  name: "Example 1",
                  groupId: 1,
                ),
                values: [
                  ConversionParamValueModel(
                    param: ConversionParamModel.listBased(
                      name: "Gender",
                      listValueType: ConvertouchListValueType.gender,
                      paramSetId: 1,
                    ),
                  ),
                  ConversionParamValueModel(
                    param: ConversionParamModel.listBased(
                      name: "Garment",
                      listValueType: ConvertouchListValueType.garment,
                      paramSetId: 1,
                    ),
                  ),
                ]),
            theme: widget.theme,
          ),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: widget.convertedItems.length,
              buildDefaultDragHandles: false,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                top: _itemPadding,
                bottom: _bottomSpacing,
              ),
              itemBuilder: (context, index) {
                ConversionUnitValueModel item = widget.convertedItems[index];

                return Padding(
                  key: Key('$index'),
                  padding: const EdgeInsets.only(
                    top: _itemPadding,
                    bottom: _itemPadding,
                  ),
                  child: ConvertouchConversionItem(
                    item,
                    index: index,
                    disabled: !widget.convertedItems[index].unit.invertible,
                    itemNameFunc: (item) => item.unit.name,
                    unitItemCodeFunc: (item) => item.unit.code,
                    onTap: () {
                      widget.onUnitItemTap?.call(widget.convertedItems[index]);
                    },
                    onValueChanged: (value) {
                      widget.onTextValueChanged?.call(
                        widget.convertedItems[index],
                        value,
                      );
                    },
                    onRemove: () {
                      widget.onItemRemoveTap?.call(item);
                    },
                    colors: conversionItemColors[widget.theme]!,
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final ConversionUnitValueModel item =
                      widget.convertedItems.removeAt(oldIndex);
                  widget.convertedItems.insert(newIndex, item);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
