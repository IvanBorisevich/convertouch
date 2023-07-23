import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItemsView extends StatefulWidget {
  const ConvertouchMenuItemsView(
    this.items, {
    this.onItemTap,
    this.markedItems,
    this.showMarkedItems = false,
    this.selectedItemId,
    this.showSelectedItem = false,
    this.viewMode = ItemsViewMode.grid,
    this.removalModeEnabled = false,
    this.markItemsOnTap = false,
    super.key,
  });

  final List<ItemModelWithIdName> items;
  final void Function(ItemModelWithIdName)? onItemTap;
  final List<ItemModelWithIdName>? markedItems;
  final bool showMarkedItems;
  final int? selectedItemId;
  final bool showSelectedItem;
  final ItemsViewMode viewMode;
  final bool removalModeEnabled;
  final bool markItemsOnTap;

  @override
  State createState() => _ConvertouchMenuItemsViewState();
}

class _ConvertouchMenuItemsViewState extends State<ConvertouchMenuItemsView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (widget.items.isNotEmpty) {
        switch (widget.viewMode) {
          case ItemsViewMode.grid:
            return ConvertouchItemsGrid(
              widget.items,
              markedItems: widget.markedItems,
              showMarkedItems: widget.showMarkedItems,
              selectedItemId: widget.selectedItemId,
              showSelectedItem: widget.showSelectedItem,
              onItemTap: widget.onItemTap,
              removalModeEnabled: widget.removalModeEnabled,
              markItemsOnTap: widget.markItemsOnTap,
            );
          case ItemsViewMode.list:
            return ConvertouchItemsList(
              widget.items,
              markedItems: widget.markedItems,
              showMarkedItems: widget.showMarkedItems,
              selectedItemId: widget.selectedItemId,
              showSelectedItem: widget.showSelectedItem,
              onItemTap: widget.onItemTap,
              removalModeEnabled: widget.removalModeEnabled,
              markItemsOnTap: widget.markItemsOnTap,
            );
        }
      }
      return const ConvertouchItemsEmptyView();
    });
  }
}

class ConvertouchItemsGrid extends StatelessWidget {
  const ConvertouchItemsGrid(
    this.items, {
    this.markedItems,
    this.showMarkedItems = false,
    this.selectedItemId,
    this.showSelectedItem = false,
    this.onItemTap,
    this.removalModeEnabled = false,
    this.markItemsOnTap = false,
    super.key,
  });

  static const double _listItemsSpacingSize = 5.0;
  static const int _numberOfItemsInRow = 4;

  final List<ItemModelWithIdName> items;
  final List<ItemModelWithIdName>? markedItems;
  final bool showMarkedItems;
  final int? selectedItemId;
  final bool showSelectedItem;
  final void Function(ItemModelWithIdName)? onItemTap;
  final bool removalModeEnabled;
  final bool markItemsOnTap;

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
        return _buildItem(
          context,
          items,
          index,
          markedItems,
          showMarkedItems,
          selectedItemId,
          showSelectedItem,
          onItemTap,
          markItemsOnTap,
        ).buildForGrid();
      },
    );
  }
}

class ConvertouchItemsList extends StatelessWidget {
  const ConvertouchItemsList(
    this.items, {
    this.markedItems,
    this.showMarkedItems = false,
    this.selectedItemId,
    this.showSelectedItem = false,
    this.onItemTap,
    this.removalModeEnabled = false,
    this.markItemsOnTap = false,
    super.key,
  });

  static const double _listItemsSpacingSize = 5;

  final List<ItemModelWithIdName> items;
  final List<ItemModelWithIdName>? markedItems;
  final bool showMarkedItems;
  final int? selectedItemId;
  final bool showSelectedItem;
  final void Function(ItemModelWithIdName)? onItemTap;
  final bool removalModeEnabled;
  final bool markItemsOnTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(_listItemsSpacingSize),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildItem(
          context,
          items,
          index,
          markedItems,
          showMarkedItems,
          selectedItemId,
          showSelectedItem,
          onItemTap,
          markItemsOnTap,
        ).buildForList();
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

ConvertouchItem _buildItem(
  BuildContext context,
  List<ItemModelWithIdName> items,
  int index,
  List<ItemModelWithIdName>? markedItems,
  bool showMarkedItems,
  int? selectedItemId,
  bool showSelectedItem,
  void Function(ItemModelWithIdName)? onItemTap,
  bool markOnTap,
) {
  ItemModelWithIdName item = items[index];
  bool isMarkedToSelect = (markedItems ?? []).contains(item);
  bool isSelected = item.id == selectedItemId;
  return ConvertouchItem.createItem(
    item,
    onTap: () {
      onItemTap?.call(item);
    },
    isMarkedToSelect: showMarkedItems && isMarkedToSelect,
    isSelected: showSelectedItem && isSelected,
    markOnTap: markOnTap,
  );
}
