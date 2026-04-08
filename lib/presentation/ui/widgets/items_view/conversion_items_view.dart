import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/presentation/ui/model/conversion_item_model.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/no_items_info_label.dart';
import 'package:flutter/material.dart';

const double _spacing = 10;
const double _bottomSpacing = 85;

class ConvertouchConversionItemsView extends StatefulWidget {
  final List<ConversionUnitValueModel> convertedItems;
  final int? sourceUnitId;
  final void Function(ConversionUnitValueModel)? onUnitItemTap;
  final void Function(ConversionUnitValueModel, dynamic)? onValueChanged;
  final void Function(ConversionUnitValueModel, dynamic)? onValueFocused;
  final void Function(ConversionUnitValueModel)? onItemRemoveTap;
  final ConvertouchUITheme theme;

  const ConvertouchConversionItemsView(
    this.convertedItems, {
    this.sourceUnitId,
    this.onUnitItemTap,
    this.onValueChanged,
    this.onValueFocused,
    this.onItemRemoveTap,
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
    if (widget.convertedItems.isEmpty) {
      return Center(
        child: NoItemsInfoLabel(
          text: "No conversion items added",
          colors: appColors[widget.theme].unitsMenu.noItemsInfoBox,
        ),
      );
    }

    return ReorderableListView.builder(
      itemCount: widget.convertedItems.length,
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
        ConversionUnitValueModel item = widget.convertedItems[index];

        return Padding(
          key: Key('$index'),
          padding: const EdgeInsets.only(
            bottom: _spacing,
          ),
          child: ConvertouchConversionItem(
            ConversionItemModel(
              inputBoxModel: InputBoxModel.ofValue(
                item,
                readonly: !item.unit.invertible,
              ),
              min: item.min,
              max: item.max,
              unit: item.unit,
              index: index,
              isSource: item.unit.id == widget.sourceUnitId,
              isLast: index == widget.convertedItems.length - 1,
              removable: widget.convertedItems.length > unitValuesMinNum,
            ),
            onUnitItemTap: () {
              widget.onUnitItemTap?.call(item);
            },
            onValueChanged: (value) {
              widget.onValueChanged?.call(item, value);
            },
            onValueFocused: (value) {
              widget.onValueFocused?.call(item, value);
            },
            onItemRemoved: () {
              widget.onItemRemoveTap?.call(item);
            },
            colors: appColors[widget.theme].conversionItem,
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
              widget.convertedItems.removeAt(oldIndex);
          widget.convertedItems.insert(newIndex, item);
        });
      },
    );
  }
}
