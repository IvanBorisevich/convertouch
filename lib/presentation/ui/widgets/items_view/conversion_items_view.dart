import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/no_items_info_label.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/scroll/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItemsView extends StatefulWidget {
  final List<ConversionItemModel> convertedItems;
  final ConvertouchValueType parentValueType;
  final void Function(ConversionItemModel)? onUnitItemTap;
  final void Function(ConversionItemModel, String)? onTextValueChanged;
  final void Function(ConversionItemModel)? onItemRemoveTap;
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
          ConversionItemModel item = widget.convertedItems[index];

          return Padding(
            key: Key('$index'),
            padding: const EdgeInsets.only(
              top: _itemPadding,
              bottom: _itemPadding,
            ),
            child: ConvertouchConversionItem(
              item,
              index: index,
              inputType: item.unit.valueType ?? widget.parentValueType,
              disabled: !widget.convertedItems[index].unit.invertible,
              onTap: () {
                widget.onUnitItemTap?.call(widget.convertedItems[index]);
              },
              onValueChanged: (String value) {
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
            final ConversionItemModel item =
                widget.convertedItems.removeAt(oldIndex);
            widget.convertedItems.insert(newIndex, item);
          });
        },
      ),
    );
  }
}
