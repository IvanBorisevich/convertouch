import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/util/menu_util.dart';
import 'package:convertouch/presenter/bloc/items_menu_view_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/events/units_menu_events.dart';
import 'package:convertouch/presenter/states/items_menu_view_state.dart';
import 'package:convertouch/view/items_model/menu_grid_item.dart';
import 'package:convertouch/view/items_model/menu_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchItemsMenuView extends StatelessWidget {
  const ConvertouchItemsMenuView(this.items, {super.key});

  final List<ItemModel> items;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsMenuViewBloc, ItemsMenuViewState>(
        builder: (_, itemsMenuViewState) {
      return LayoutBuilder(builder: (context, constraints) {
        if (items.isNotEmpty) {
          switch (itemsMenuViewState.itemsMenuView) {
            case ItemsMenuViewMode.grid:
              return ConvertouchItemsGrid(items);
            case ItemsMenuViewMode.list:
              return ConvertouchItemsList(items);
          }
        }
        return const ConvertouchItemsEmptyView();
      });
    });
  }
}

class ConvertouchItemsGrid extends StatelessWidget {
  const ConvertouchItemsGrid(this.items, {super.key});

  static const double _listItemsSpacingSize = 5.0;
  static const int _numberOfItemsInRow = 4;

  final List<ItemModel> items;

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
        return ConvertouchMenuGridItem(items[index], onPressed: () {
          ItemModel item = items[index];
          if (item.itemType == ItemType.unitGroup) {
            BlocProvider.of<UnitsMenuBloc>(context).add(FetchUnits(
                unitGroupId: item.id, navigationAction: NavigationAction.push));
          }
        });
      },
    );
  }
}

class ConvertouchItemsList extends StatelessWidget {
  const ConvertouchItemsList(this.items, {super.key});

  static const double _listItemsSpacingSize = 5;

  final List<ItemModel> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(_listItemsSpacingSize),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ConvertouchMenuListItem(items[index], onPressed: () {
          ItemModel item = items[index];
          if (item.itemType == ItemType.unitGroup) {
            BlocProvider.of<UnitsMenuBloc>(context).add(FetchUnits(
                unitGroupId: item.id, navigationAction: NavigationAction.push));
          }
        });
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
