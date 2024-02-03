import 'dart:ui';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItemsView extends StatefulWidget {
  final List<ConversionItemModel> convertedItems;
  final void Function(ConversionItemModel)? onItemTap;
  final void Function(ConversionItemModel, String)? onItemValueChanged;
  final void Function(ConversionItemModel)? onItemRemove;
  final ConvertouchUITheme theme;

  const ConvertouchConversionItemsView(
    this.convertedItems, {
    this.onItemTap,
    this.onItemValueChanged,
    this.onItemRemove,
    required this.theme,
    super.key,
  });

  @override
  State createState() => _ConvertouchConversionItemsViewState();
}

class _ConvertouchConversionItemsViewState
    extends State<ConvertouchConversionItemsView> {
  static const double _listSpacingLeft = 1;
  static const double _listSpacingRight = 7;
  static const double _listSpacingTop = 9;
  static const double _listItemSpacing = 9;
  static const double _dragHandlerWidth = 38;
  static const double _dragHandlerHeight = 35;
  static const double _removalHandlerWidth = 32;
  static const double _removalHandlerHeight = 35;

  @override
  Widget build(BuildContext context) {
    ConversionItemColorScheme conversionItemColorScheme =
        conversionItemColors[widget.theme]!;

    final List<Card> cards = <Card>[
      for (int index = 0; index < widget.convertedItems.length; index += 1)
        Card(
          key: Key('$index'),
          margin: EdgeInsets.zero,
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(bottom: _listItemSpacing),
            child: Row(
              children: [
                Container(
                  width: _dragHandlerWidth,
                  height: _dragHandlerHeight,
                  padding: EdgeInsets.zero,
                  child: ReorderableDragStartListener(
                    index: index,
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: Icon(
                        Icons.drag_indicator_outlined,
                        color: conversionItemColorScheme.handler,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ConvertouchConversionItem(
                    widget.convertedItems[index],
                    onTap: () {
                      widget.onItemTap?.call(widget.convertedItems[index]);
                    },
                    onValueChanged: (String value) {
                      widget.onItemValueChanged?.call(
                        widget.convertedItems[index],
                        value,
                      );
                    },
                    theme: widget.theme,
                  ),
                ),
                Container(
                  width: _removalHandlerWidth,
                  height: _removalHandlerHeight,
                  padding: EdgeInsets.zero,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    // on tap effect color
                    highlightColor: Colors.transparent,
                    // on long pressed effect color
                    padding: const EdgeInsets.only(left: 5),
                    onPressed: () {
                      widget.onItemRemove?.call(widget.convertedItems[index]);
                    },
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: conversionItemColorScheme.handler,
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
        padding: const EdgeInsets.fromLTRB(
          _listSpacingLeft,
          _listSpacingTop,
          _listSpacingRight,
          0,
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
      return noItemsView("No Conversions Added");
    }
  }
}
