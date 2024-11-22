import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_state.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_states.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/info_box_no_items.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_grid_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_list_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/items_grid_view.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/items_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchMenuItemsView<T extends IdNameItemModel>
    extends StatefulWidget {
  final ItemsListBloc<T, ItemsFetched<T>> itemsListBloc;
  final AppBloc appBloc;
  final PageName pageName;
  final void Function(T)? onItemTap;
  final void Function(T)? onItemTapForRemoval;
  final void Function(T)? onItemLongPress;
  final List<int> checkedItemIds;
  final List<int> disabledItemIds;
  final int? selectedItemId;
  final int batchSize;
  final int numOfGridItemsInRow;
  final bool editableItemsVisible;
  final bool checkableItemsVisible;
  final bool removalModeEnabled;
  final double itemsSpacing;
  final double itemsBottomSpacing;

  const ConvertouchMenuItemsView({
    required this.itemsListBloc,
    required this.appBloc,
    required this.pageName,
    this.onItemTap,
    this.onItemTapForRemoval,
    this.onItemLongPress,
    this.checkedItemIds = const [],
    this.disabledItemIds = const [],
    this.selectedItemId,
    this.batchSize = 40,
    this.numOfGridItemsInRow = 4,
    this.editableItemsVisible = false,
    this.checkableItemsVisible = false,
    this.removalModeEnabled = false,
    this.itemsSpacing = 8,
    this.itemsBottomSpacing = 85,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ConvertouchMenuItemsViewState<T>();
}

class _ConvertouchMenuItemsViewState<T extends IdNameItemModel>
    extends State<ConvertouchMenuItemsView<T>> {
  static const double defaultLogoIconSize = 29;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (_, appState) {
        if (appState is AppStateReady) {
          ItemsViewMode itemsViewMode = T == UnitGroupModel
              ? appState.unitGroupsViewMode
              : appState.unitsViewMode;

          return itemsListBlocBuilder(
            bloc: widget.itemsListBloc,
            builderFunc: (itemsState) {
              ConvertouchColorScheme colors;
              if (T == UnitGroupModel) {
                colors = unitGroupPageEmptyViewColor[appState.theme]!;
              } else {
                colors = unitPageEmptyViewColor[appState.theme]!;
              }

              switch (itemsState.status) {
                case FetchingStatus.failure:
                  return Center(
                    child: InfoBoxNoItems(
                      text: T == UnitGroupModel
                          ? "Failed to fetch new unit groups"
                          : "Failed to fetch new units",
                      colors: colors,
                    ),
                  );
                case FetchingStatus.success:
                  if (itemsState.items.isEmpty) {
                    return Center(
                      child: InfoBoxNoItems(
                        text: T == UnitGroupModel
                            ? "No unit groups added"
                            : "No units added",
                        colors: colors,
                      ),
                    );
                  }

                  ListItemColorScheme itemColors;
                  Widget Function(T, Color) itemLogoFunc;
                  String Function(T) itemNameFunc;

                  if (T == UnitGroupModel) {
                    itemColors = unitGroupItemColors[appState.theme]!;
                    itemLogoFunc = (T item, Color color) {
                      UnitGroupModel unitGroup = item as UnitGroupModel;
                      return IconUtils.getUnitGroupIcon(
                        iconName: unitGroup.iconName,
                        color: color,
                        size: defaultLogoIconSize,
                      );
                    };
                    itemNameFunc = (T item) {
                      return item.name;
                    };
                  } else {
                    itemColors = unitItemColors[appState.theme]!;
                    itemLogoFunc = (T item, Color color) {
                      UnitModel unit = item as UnitModel;
                      return Text(
                        unit.code,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontFamily: quicksandFontFamily,
                          fontSize: 16,
                        ),
                      );
                    };
                    itemNameFunc = (T item) {
                      UnitModel unit = item as UnitModel;
                      return unit.symbol != null
                          ? "${unit.name} (${unit.symbol})"
                          : unit.name;
                    };
                  }

                  switch (itemsViewMode) {
                    case ItemsViewMode.list:
                      return ConvertouchItemsListView<T>(
                        items: itemsState.items as List<T>,
                        onItemTap: widget.onItemTap,
                        onItemLongPress: widget.onItemLongPress,
                        onItemTapForRemoval: widget.onItemTapForRemoval,
                        onScroll: (scrollController) {
                          _onScroll(ItemsViewMode.list, scrollController);
                        },
                        logoFunc: itemLogoFunc,
                        colors: itemColors,
                        itemsSpacing: widget.itemsSpacing,
                        itemsBottomSpacing: widget.itemsBottomSpacing,
                        selectedItemId: widget.selectedItemId,
                        itemNameFunc: itemNameFunc,
                        onLoadMore: () {
                          widget.itemsListBloc.add(
                            const FetchItems(firstFetch: false),
                          );
                        },
                      );
                    case ItemsViewMode.grid:
                      return ConvertouchItemsGridView<T>(
                        items: itemsState.items as List<T>,
                        onItemTap: widget.onItemTap,
                        onItemLongPress: widget.onItemLongPress,
                        onItemTapForRemoval: widget.onItemTapForRemoval,
                        onScroll: (scrollController) {
                          _onScroll(ItemsViewMode.grid, scrollController);
                        },
                        logoFunc: itemLogoFunc,
                        colors: itemColors,
                        itemsSpacing: widget.itemsSpacing,
                        itemsBottomSpacing: widget.itemsBottomSpacing,
                        selectedItemId: widget.selectedItemId,
                        itemNameFunc: itemNameFunc,
                        onLoadMore: () {
                          widget.itemsListBloc.add(
                            const FetchItems(firstFetch: false),
                          );
                        },
                      );
                  }

                //   CustomScrollView(
                //   controller: _scrollController,
                //   slivers: [
                //     SliverPadding(
                //       padding: EdgeInsets.only(
                //         top: widget.itemsSpacing,
                //         left: widget.itemsSpacing,
                //         right: widget.itemsSpacing,
                //         bottom: widget.itemsBottomSpacing,
                //       ),
                //       sliver: SliverGrid.builder(
                //         itemCount: itemsState.hasReachedMax
                //             ? itemsState.items.length
                //             : itemsState.items.length + 1,
                //         gridDelegate:
                //             SliverGridDelegateWithMaxCrossAxisExtent(
                //           mainAxisExtent: itemHeight,
                //           maxCrossAxisExtent: itemWidth,
                //           mainAxisSpacing: widget.itemsSpacing,
                //           crossAxisSpacing: widget.itemsSpacing,
                //         ),
                //         itemBuilder: _itemBuilder(
                //           items: itemsState.items,
                //           itemsViewMode: itemsViewMode,
                //           theme: appState.theme,
                //         ),
                //       ),
                //     ),
                //   ],
                // );
              }
            },
          );
        } else {
          return const SizedBox(
            height: 0,
            width: 0,
          );
        }
      },
    );
  }

  void _onScroll(ItemsViewMode viewMode, ScrollController controller) {
    bool hasReachedMax = widget.itemsListBloc.state.hasReachedMax;

    if (!hasReachedMax && _isBottom(viewMode, controller)) {
      widget.itemsListBloc.add(
        FetchItems(
          firstFetch: false,
          pageSize: widget.batchSize,
        ),
      );
    }
  }

  bool _isBottom(ItemsViewMode itemsViewMode, ScrollController controller) {
    if (!controller.hasClients) {
      return false;
    }

    double seenExtent =
        controller.position.pixels + controller.position.viewportDimension;
    double filledExtent = _calculateFilledExtent(itemsViewMode);

    return filledExtent <= seenExtent;
  }

  double _calculateFilledExtent(ItemsViewMode itemsViewMode) {
    double itemHeight = itemsViewMode == ItemsViewMode.grid
        ? ConvertouchMenuGridItem.defaultHeight
        : ConvertouchMenuListItem.defaultHeight;

    int itemsNum = widget.itemsListBloc.state.items.length;

    int itemsInRow =
        itemsViewMode == ItemsViewMode.grid ? widget.numOfGridItemsInRow : 1;

    int numOfFullRows = (itemsNum / itemsInRow).floor();
    double rowHeight = itemHeight + widget.itemsSpacing;

    return rowHeight * numOfFullRows;
  }
}
