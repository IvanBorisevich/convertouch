import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/view/items_menu/item/list_item.dart';
import 'package:flutter/material.dart';

class ConvertouchItemsList extends StatefulWidget {
  const ConvertouchItemsList(this.items, {super.key});

  final List<ItemModel> items;

  @override
  State<ConvertouchItemsList> createState() => _ConvertouchItemsListState();
}

class _ConvertouchItemsListState extends State<ConvertouchItemsList> {
  static const double _listItemsSpacingSize = 5;
  static const int _durationMillis = 110;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  final List<ItemModel> _listItems = [];

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
          _listItems.add(widget.items[i]);
          _listKey.currentState?.insertItem(_listItems.length - 1,
              duration: const Duration(milliseconds: _durationMillis));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _listItems.length,
      itemBuilder: (context, index, animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                  _listItemsSpacingSize,
                  _listItemsSpacingSize,
                  _listItemsSpacingSize,
                  index == widget.items.length - 1 ? _listItemsSpacingSize : 0),
              child: ConvertouchListItem(_listItems[index]),
            ),
          ),
        );
      },
    );
  }
}
