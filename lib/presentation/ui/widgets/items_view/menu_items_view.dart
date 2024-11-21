import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_state.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_states.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/bottom_loader.dart';
import 'package:convertouch/presentation/ui/widgets/info_box_no_items.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_grid_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_list_item.dart';
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
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ItemsViewMode itemsViewMode = T == UnitGroupModel
        ? (widget.appBloc.state as AppStateReady).unitGroupsViewMode
        : (widget.appBloc.state as AppStateReady).unitsViewMode;

    switch (itemsViewMode) {
      case ItemsViewMode.list:
        _scrollController.addListener(_onListScroll);
        break;
      case ItemsViewMode.grid:
        _scrollController.addListener(_onGridScroll);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listenWhen: (prev, next) {
        return prev is AppStateReady &&
            next is AppStateReady &&
            next.changedFromPage == widget.pageName &&
            (next.unitsViewMode != prev.unitsViewMode ||
                next.unitGroupsViewMode != prev.unitGroupsViewMode);
      },
      listener: (_, appState) {
        if (appState is AppStateReady &&
            appState.changedFromPage == widget.pageName) {
          ItemsViewMode itemsViewMode = T == UnitGroupModel
              ? appState.unitGroupsViewMode
              : appState.unitsViewMode;

          switch (itemsViewMode) {
            case ItemsViewMode.list:
              _scrollController.removeListener(_onGridScroll);
              _scrollController.addListener(_onListScroll);
              _onListScroll();
              break;
            case ItemsViewMode.grid:
              _scrollController.removeListener(_onListScroll);
              _scrollController.addListener(_onGridScroll);
              _onGridScroll();
              break;
          }
        }
      },
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

                  double itemWidth = itemsViewMode == ItemsViewMode.list
                      ? MediaQuery.of(context).size.width
                      : ConvertouchMenuGridItem.defaultWidth;
                  double itemHeight = itemsViewMode == ItemsViewMode.list
                      ? ConvertouchMenuListItem.defaultHeight
                      : ConvertouchMenuGridItem.defaultHeight;

                  return CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(
                          top: widget.itemsSpacing,
                          left: widget.itemsSpacing,
                          right: widget.itemsSpacing,
                          bottom: widget.itemsBottomSpacing,
                        ),
                        sliver: SliverGrid.builder(
                          itemCount: itemsState.hasReachedMax
                              ? itemsState.items.length
                              : itemsState.items.length + 1,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisExtent: itemHeight,
                            maxCrossAxisExtent: itemWidth,
                            mainAxisSpacing: widget.itemsSpacing,
                            crossAxisSpacing: widget.itemsSpacing,
                          ),
                          itemBuilder: _itemBuilder(
                            items: itemsState.items,
                            itemsViewMode: itemsViewMode,
                            theme: appState.theme,
                          ),
                        ),
                      ),
                    ],
                  );
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

  Widget? Function(BuildContext, int) _itemBuilder({
    required List<IdNameItemModel> items,
    required ItemsViewMode itemsViewMode,
    required ConvertouchUITheme theme,
  }) {
    return (BuildContext context, int index) {
      if (index < items.length) {
        T item = items[index] as T;

        bool selected = item.id == widget.selectedItemId;
        bool disabled = widget.disabledItemIds.contains(item.id);
        bool checked = widget.checkedItemIds.contains(item.id);

        return ConvertouchMenuItem(
          item,
          itemsViewMode: itemsViewMode,
          onTap: () {
            if (widget.removalModeEnabled) {
              if (!item.oob) {
                widget.onItemTapForRemoval?.call(item);
              }
            } else {
              if (!selected && !disabled) {
                FocusScope.of(context).unfocus();
                widget.onItemTap?.call(item);
              }
            }
          },
          onLongPress: () {
            widget.onItemLongPress?.call(item);
          },
          checked: checked || selected,
          disabled: disabled,
          checkIconVisible:
              widget.checkableItemsVisible || widget.removalModeEnabled,
          checkIconVisibleIfUnchecked: !item.oob && widget.removalModeEnabled,
          editIconVisible: !item.oob && widget.editableItemsVisible,
          theme: theme,
        );
      } else {
        return BottomLoader(
          onTap: () {
            widget.itemsListBloc.add(
              const FetchItems(firstFetch: false),
            );
          },
          colors: T == UnitGroupModel
              ? unitGroupBottomLoaderColors[theme]
              : unitBottomLoaderColors[theme],
        );
      }
    };
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onListScroll);
    _scrollController.removeListener(_onGridScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onListScroll() {
    _onScroll(ItemsViewMode.list);
  }

  void _onGridScroll() {
    _onScroll(ItemsViewMode.grid);
  }

  void _onScroll(ItemsViewMode viewMode) {
    bool hasReachedMax = widget.itemsListBloc.state.hasReachedMax;

    if (!hasReachedMax && _isBottom(viewMode)) {
      widget.itemsListBloc.add(
        FetchItems(
          firstFetch: false,
          pageSize: widget.batchSize,
        ),
      );
    }
  }

  bool _isBottom(ItemsViewMode itemsViewMode) {
    if (!_scrollController.hasClients) {
      return false;
    }

    double seenExtent = _scrollController.position.pixels +
        _scrollController.position.viewportDimension;
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
