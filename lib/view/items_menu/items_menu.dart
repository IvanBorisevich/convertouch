import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/item_view_mode.dart';
import 'package:convertouch/view/items_menu/item_view_mode/items_list.dart';
import 'package:convertouch/view/items_menu/item_view_mode/items_grid.dart';
import 'package:flutter/material.dart';

class ConvertouchItemsMenuPage extends StatefulWidget {
  const ConvertouchItemsMenuPage(this.items,
      {
        super.key,
        this.itemViewMode = ItemViewMode.list,
      });

  final List<ItemModel> items;
  final ItemViewMode itemViewMode;

  @override
  State<ConvertouchItemsMenuPage> createState() =>
      _ConvertouchItemsMenuPageState();
}

class _ConvertouchItemsMenuPageState extends State<ConvertouchItemsMenuPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF6F9FF),
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            switch(widget.itemViewMode) {
              case ItemViewMode.grid:
                return ConvertouchItemsGrid(widget.items);
              case ItemViewMode.list:
              default:
                return ConvertouchItemsList(widget.items);
            }
          })),
    );
  }
}
