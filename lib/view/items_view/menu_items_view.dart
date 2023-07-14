import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItemsView extends StatefulWidget {
  const ConvertouchMenuItemsView(this.items,
      {this.selectedItemIds = const [],
      this.viewMode = ItemsMenuViewMode.grid,
      super.key});

  final List<ItemModelWithIdName> items;
  final List<int> selectedItemIds;
  final ItemsMenuViewMode viewMode;

  @override
  State createState() => _ConvertouchMenuItemsViewState();
}

class _ConvertouchMenuItemsViewState extends State<ConvertouchMenuItemsView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (widget.items.isNotEmpty) {
        switch (widget.viewMode) {
          case ItemsMenuViewMode.grid:
            return ConvertouchItemsGrid(widget.items,
                selectedItemIds: widget.selectedItemIds);
          case ItemsMenuViewMode.list:
            return ConvertouchItemsList(widget.items,
                selectedItemIds: widget.selectedItemIds);
        }
      }
      return const ConvertouchItemsEmptyView();
    });
  }
}

class ConvertouchItemsGrid extends StatelessWidget {
  const ConvertouchItemsGrid(this.items,
      {this.selectedItemIds = const [], super.key});

  static const double _listItemsSpacingSize = 5.0;
  static const int _numberOfItemsInRow = 4;

  final List<ItemModelWithIdName> items;
  final List<int> selectedItemIds;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _numberOfItemsInRow,
        mainAxisSpacing: _listItemsSpacingSize,
        crossAxisSpacing: _listItemsSpacingSize,
      ),
      padding: const EdgeInsets.all(_listItemsSpacingSize),
      itemBuilder: (context, index) {
        ItemModelWithIdName item = items[index];
        bool isSelected = selectedItemIds.contains(item.id);
        return ConvertouchItem.createItem(item, isSelected: isSelected)
            .buildForGrid(context);
      },
    );
  }
}

class ConvertouchItemsList extends StatelessWidget {
  const ConvertouchItemsList(this.items,
      {this.selectedItemIds = const [], super.key});

  static const double _listItemsSpacingSize = 5;

  final List<ItemModelWithIdName> items;
  final List<int> selectedItemIds;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(_listItemsSpacingSize),
      itemCount: items.length,
      itemBuilder: (context, index) {
        ItemModelWithIdName item = items[index];
        bool isSelected = selectedItemIds.contains(item.id);
        return ConvertouchItem.createItem(item, isSelected: isSelected)
            .buildForList(context);
      },
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
            _listItemsSpacingSize,
            _listItemsSpacingSize,
            _listItemsSpacingSize,
            index == items.length - 1 ? _listItemsSpacingSize : 0),
      ),
    );
  }
}

class ConvertouchItemsEmptyView extends StatelessWidget {
  const ConvertouchItemsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Center(
          child: Text(
        "No Items",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      )),
    );
  }
}
