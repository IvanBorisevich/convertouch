import 'dart:ui';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/presentation/pages/items_view/item/conversion_item.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItemsView extends StatefulWidget {
  final List<UnitValueModel> convertedItems;
  final void Function(UnitValueModel)? onItemTap;
  final void Function(UnitValueModel, String)? onItemValueChanged;
  final void Function(UnitValueModel)? onItemRemove;
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
                    child: const Card(
                      margin: EdgeInsets.zero,
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: Icon(
                        Icons.drag_indicator_outlined,
                        color: Color(0xFF7FA0BE),
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
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Color(0xFF7FA0BE),
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
          final UnitValueModel item = widget.convertedItems.removeAt(oldIndex);
          widget.convertedItems.insert(newIndex, item);
        });
      },
    );
  }
}
