import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/view/items_menu/item/grid_item.dart';
import 'package:flutter/material.dart';

class ConvertouchItemsGrid extends StatefulWidget {
  const ConvertouchItemsGrid(this.items, {super.key});

  final List<ItemModel> items;

  @override
  State<ConvertouchItemsGrid> createState() => _ConvertouchItemsGridState();
}

class _ConvertouchItemsGridState extends State<ConvertouchItemsGrid> {
  static const double _listItemsSpacingSize = 5.0;
  static const int _numberOfItemsInRow = 4;
  static const int _durationMillis = 110;

  final GlobalKey<AnimatedGridState> _gridKey = GlobalKey<AnimatedGridState>();
  final List<ItemModel> _gridItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() {
    var future = Future(() {});
    future = future.then((_) {
      return Future.sync(() {
        for (var i = 0; i < widget.items.length; i++) {
          _gridItems.add(widget.items[i]);
          _gridKey.currentState?.insertItem(_gridItems.length - 1,
              duration: const Duration(milliseconds: _durationMillis));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedGrid(
      key: _gridKey,
      initialItemCount: _gridItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _numberOfItemsInRow,
        mainAxisSpacing: _listItemsSpacingSize,
        crossAxisSpacing: _listItemsSpacingSize,
      ),
      padding: const EdgeInsets.all(_listItemsSpacingSize),
      itemBuilder: (context, index, animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: ConvertouchGridItem(_gridItems[index]),
          ),
        );
      },
    );
  }
}
