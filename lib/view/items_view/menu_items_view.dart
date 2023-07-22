import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:flutter/material.dart';

class ConvertouchMenuItemsView extends StatefulWidget {
  const ConvertouchMenuItemsView(this.items, {
    this.onItemTap,
    this.markedItemIds,
    this.viewMode = ItemsViewMode.grid,
    this.removalModeEnabled = false,
    this.markItemsOnTap = false,
    super.key
  });

  final List<ItemModelWithIdName> items;
  final void Function(ItemModelWithIdName)? onItemTap;
  final List<int>? markedItemIds;
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
              markedItemIds: widget.markedItemIds,
              onItemTap: widget.onItemTap,
              removalModeEnabled: widget.removalModeEnabled,
              markItemsOnTap: widget.markItemsOnTap,
            );
          case ItemsViewMode.list:
            return ConvertouchItemsList(
              widget.items,
              markedItemIds: widget.markedItemIds,
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
  const ConvertouchItemsGrid(this.items, {
    this.markedItemIds,
    this.onItemTap,
    this.removalModeEnabled = false,
    this.markItemsOnTap = false,
    super.key
  });

  static const double _listItemsSpacingSize = 5.0;
  static const int _numberOfItemsInRow = 4;

  final List<ItemModelWithIdName> items;
  final List<int>? markedItemIds;
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
        ItemModelWithIdName item = items[index];
        bool isMarkedToSelect = (markedItemIds ?? []).contains(item.id);
        return ConvertouchItem.createItem(
          item,
          onTap: () {
            onItemTap?.call(item);
          },
          isMarkedToSelect: isMarkedToSelect,
          markOnTap: markItemsOnTap,
        ).buildForGrid();
      },
    );
  }
}

class ConvertouchItemsList extends StatelessWidget {
  const ConvertouchItemsList(this.items, {
    this.markedItemIds,
    this.onItemTap,
    this.removalModeEnabled = false,
    this.markItemsOnTap = false,
    super.key
  });

  static const double _listItemsSpacingSize = 5;

  final List<ItemModelWithIdName> items;
  final List<int>? markedItemIds;
  final void Function(ItemModelWithIdName)? onItemTap;
  final bool removalModeEnabled;
  final bool markItemsOnTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(_listItemsSpacingSize),
      itemCount: items.length,
      itemBuilder: (context, index) {
        ItemModelWithIdName item = items[index];
        bool isMarkedToSelect = (markedItemIds ?? []).contains(item.id);
        return ConvertouchItem.createItem(
          item,
          isMarkedToSelect: isMarkedToSelect,
          onTap: () {
            onItemTap?.call(item);
          },
          markOnTap: markItemsOnTap,
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
