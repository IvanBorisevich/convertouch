import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/view/menu_items/item/list_item.dart';
import 'package:flutter/material.dart';

class ConvertouchItemsList extends StatefulWidget {
  const ConvertouchItemsList(this.items, {super.key});

  final List<ItemModel> items;

  @override
  State<ConvertouchItemsList> createState() => _ConvertouchItemsListState();
}

class _ConvertouchItemsListState extends State<ConvertouchItemsList> {
  static const double _listItemsSpacingSize = 5;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(_listItemsSpacingSize),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return ConvertouchListItem(widget.items[index]);
      },
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
            _listItemsSpacingSize,
            _listItemsSpacingSize,
            _listItemsSpacingSize,
            index == widget.items.length - 1 ? _listItemsSpacingSize : 0),
      ),
    );
  }
}
