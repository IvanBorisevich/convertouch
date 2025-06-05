import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/no_items_info_label.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItemsView extends StatefulWidget {
  final List<ConversionUnitValueModel> convertedItems;
  final int? sourceUnitId;
  final void Function(ConversionUnitValueModel)? onUnitItemTap;
  final void Function(ConversionUnitValueModel, String?)? onTextValueChanged;
  final void Function(ConversionUnitValueModel)? onItemRemoveTap;
  final double listItemSpacingAfterLast;
  final ConvertouchUITheme theme;

  const ConvertouchConversionItemsView(
    this.convertedItems, {
    this.sourceUnitId,
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
  static const double _viewTopPadding = 7;
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

    return ReorderableListView.builder(
      itemCount: widget.convertedItems.length,
      buildDefaultDragHandles: false,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      proxyDecorator: (child, index, animation) {
        return Material(
          key: ValueKey(index),
          color: Colors.transparent,
          child: child, // place your ui
        );
      },
      padding: const EdgeInsets.only(
        top: _viewTopPadding,
        bottom: _bottomSpacing,
      ),
      itemBuilder: (context, index) {
        ConversionUnitValueModel item = widget.convertedItems[index];

        return Padding(
          key: Key('$index'),
          padding: const EdgeInsets.only(),
          child: ConvertouchConversionItem(
            item,
            index: index,
            isSource:
                widget.convertedItems[index].unit.id == widget.sourceUnitId,
            wrapped: true,
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
    );
  }
}
