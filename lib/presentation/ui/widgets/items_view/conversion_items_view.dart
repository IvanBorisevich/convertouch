import 'dart:ui';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItemsView extends StatefulWidget {
  final List<ConversionItemModel> convertedItems;
  final ConvertouchValueType valueType;
  final void Function(ConversionItemModel)? onUnitItemTap;
  final void Function(ConversionItemModel, String)? onTextValueChanged;
  final void Function(ConversionItemModel)? onItemRemoveTap;
  final Widget noItemsView;
  final double listItemSpacingAfterLast;
  final ConvertouchUITheme theme;

  const ConvertouchConversionItemsView(
    this.convertedItems, {
    required this.valueType,
    this.onUnitItemTap,
    this.onTextValueChanged,
    this.onItemRemoveTap,
    required this.noItemsView,
    this.listItemSpacingAfterLast = 90,
    required this.theme,
    super.key,
  });

  @override
  State createState() => _ConvertouchConversionItemsViewState();
}

class _ConvertouchConversionItemsViewState
    extends State<ConvertouchConversionItemsView> {
  static const double _listSpacingTop = 5;
  static const double _listItemSpacing = 11;
  static const double _dragHandlerWidth = 38;
  static const double _dragHandlerHeight = 50;
  static const double _removalHandlerWidth = 41;
  static const double _removalHandlerHeight = 50;

  @override
  Widget build(BuildContext context) {
    ConversionItemColorScheme conversionItemColorScheme =
        conversionItemColors[widget.theme]!;

    final List<Card> cards = <Card>[
      for (int index = 0; index < widget.convertedItems.length; index += 1)
        Card(
          key: Key('$index'),
          margin: EdgeInsets.zero,
          elevation: 0,
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: index == widget.convertedItems.length - 1
                  ? widget.listItemSpacingAfterLast
                  : _listItemSpacing,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: _dragHandlerWidth,
                  height: _dragHandlerHeight,
                  child: ReorderableDragStartListener(
                    index: index,
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: Icon(
                        Icons.drag_indicator_outlined,
                        color: conversionItemColorScheme
                            .handler.foreground.regular,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ConvertouchConversionItem(
                    widget.convertedItems[index],
                    disabled: !widget.convertedItems[index].unit.invertible,
                    valueType: widget.convertedItems[index].unit.valueType ??
                        widget.valueType,
                    onTap: () {
                      widget.onUnitItemTap?.call(widget.convertedItems[index]);
                    },
                    onValueChanged: (String value) {
                      widget.onTextValueChanged?.call(
                        widget.convertedItems[index],
                        value,
                      );
                    },
                    theme: widget.theme,
                  ),
                ),
                SizedBox(
                  width: _removalHandlerWidth,
                  height: _removalHandlerHeight,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      widget.onItemRemoveTap
                          ?.call(widget.convertedItems[index]);
                    },
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color:
                          conversionItemColorScheme.handler.foreground.regular,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    ];

    /* animation when an item is dragged and dropped */
    Widget proxyDecorator(
      Widget child,
      int index,
      Animation<double> animation,
    ) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(1, 6, animValue)!;
          final double scale = lerpDouble(1, 1.02, animValue)!;
          return Transform.scale(
            scale: scale,
            child: Card(
              elevation: elevation,
              shadowColor: Colors.transparent,
              color: cards[index].color,
              child: cards[index].child,
            ),
          );
        },
        child: child,
      );
    }

    if (widget.convertedItems.isNotEmpty) {
      return ReorderableListView.builder(
        itemBuilder: (context, index) {
          return cards[index];
        },
        itemCount: widget.convertedItems.length,
        buildDefaultDragHandles: false,
        proxyDecorator: proxyDecorator,
        padding: const EdgeInsets.only(
          top: _listSpacingTop,
        ),
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
      );
    } else {
      return widget.noItemsView;
    }
  }
}
