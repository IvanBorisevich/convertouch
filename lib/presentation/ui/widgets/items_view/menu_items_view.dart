import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_states.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_grid_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_list_item.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/mixin/items_lazy_loading_mixin.dart';
import 'package:convertouch/presentation/ui/widgets/no_items_info_label.dart';
import 'package:convertouch/presentation/ui/widgets/scroll/no_glow_scroll_behavior.dart';
import 'package:convertouch/presentation/ui/widgets/search_bar.dart';
import 'package:convertouch/presentation/ui/widgets/text_search_match.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchMenuItemsView<T extends IdNameSearchableItemModel>
    extends StatefulWidget {
  final ItemsListBloc<T, ItemsFetched<T>> itemsListBloc;
  final PageName pageName;
  final SettingKey viewModeSettingKey;
  final String? searchBarPlaceholder;
  final void Function(T)? onItemTap;
  final void Function(T)? onItemTapForRemoval;
  final void Function(T)? onItemLongPress;
  final List<int> checkedItemIds;
  final List<int> disabledItemIds;
  final int? selectedItemId;
  final bool editableItemsVisible;
  final bool checkableItemsVisible;
  final bool checkIconVisibleIfUnchecked;
  final bool removalModeEnabled;

  const ConvertouchMenuItemsView({
    required this.itemsListBloc,
    required this.pageName,
    required this.viewModeSettingKey,
    this.searchBarPlaceholder,
    this.onItemTap,
    this.onItemTapForRemoval,
    this.onItemLongPress,
    this.checkedItemIds = const [],
    this.disabledItemIds = const [],
    this.selectedItemId,
    this.editableItemsVisible = false,
    this.checkableItemsVisible = false,
    this.checkIconVisibleIfUnchecked = false,
    this.removalModeEnabled = false,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ConvertouchMenuItemsViewState<T>();
}

class _ConvertouchMenuItemsViewState<T extends IdNameSearchableItemModel>
    extends State<ConvertouchMenuItemsView<T>> with ItemsLazyLoadingMixin {
  static const double _itemsSpacing = 8;
  static const double _bottomSpacing = 85;

  late Widget Function(
    T, {
    required Color foreground,
    required Color matchForeground,
    required Color matchBackground,
  }) _itemLogoFunc;

  late String Function(T) _itemNameFunc;

  late final List<T> _itemsFullList;
  late final Map<ConvertouchUITheme, ListItemColorScheme> _itemColors;
  late final Map<ConvertouchUITheme, ConvertouchColorScheme> _emptyViewColors;
  late final ScrollController _listScrollController;
  late final ScrollController _gridScrollController;

  late final void Function(BuildContext, T, {bool callable}) _onItemTap;
  late final Widget? Function(
    BuildContext,
    int, {
    required ListItemColorScheme itemColors,
    required ItemsViewMode itemsViewMode,
    required bool checkIconVisible,
  }) _itemBuilder;

  @override
  void initState() {
    super.initState();

    _itemsFullList = widget.itemsListBloc.state.pageItems.isNotEmpty
        ? widget.itemsListBloc.state.pageItems
        : [];

    if (T == UnitGroupModel) {
      _itemColors = unitGroupItemColors;
      _emptyViewColors = unitGroupPageEmptyViewColor;

      _itemLogoFunc = (
        T item, {
        required Color foreground,
        required Color matchForeground,
        required Color matchBackground,
      }) {
        UnitGroupModel unitGroup = item as UnitGroupModel;
        return IconUtils.getUnitGroupIcon(
          iconName: unitGroup.iconName,
          color: foreground,
          size: 29,
        );
      };

      _itemNameFunc = (T item) {
        return item.name;
      };
    } else {
      _itemColors = unitItemColors;
      _emptyViewColors = unitPageEmptyViewColor;

      _itemLogoFunc = (
        T item, {
        required Color foreground,
        required Color matchForeground,
        required Color matchBackground,
      }) {
        UnitModel unit = item as UnitModel;
        return TextSearchMatch(
          sourceString: unit.code,
          match: item.codeMatch,
          foreground: foreground,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          matchBackground: matchBackground,
          matchForeground: matchForeground,
        );
      };

      _itemNameFunc = (T item) {
        UnitModel unit = item as UnitModel;
        return unit.symbol != null
            ? "${unit.name} (${unit.symbol})"
            : unit.name;
      };
    }

    _itemBuilder = (
      context,
      index, {
      required ListItemColorScheme itemColors,
      required ItemsViewMode itemsViewMode,
      required bool checkIconVisible,
    }) {
      if (index < _itemsFullList.length) {
        T item = _itemsFullList[index];

        bool selected = item.id == widget.selectedItemId;
        bool disabled = widget.disabledItemIds.contains(item.id);
        bool checked = widget.checkedItemIds.contains(item.id);
        bool checkIconVisibleIfUnchecked = !disabled &&
            (widget.checkIconVisibleIfUnchecked ||
                !item.oob && widget.removalModeEnabled);
        bool editIconVisible = !item.oob && widget.editableItemsVisible;

        onTap() {
          _onItemTap(
            context,
            item,
            callable: !selected && !disabled,
          );
        }

        onLongPress() {
          widget.onItemLongPress?.call(item);
        }

        switch (itemsViewMode) {
          case ItemsViewMode.list:
            return Padding(
              padding: const EdgeInsets.only(
                bottom: _itemsSpacing,
              ),
              child: ConvertouchMenuListItem(
                item,
                checked: checked || selected,
                colors: itemColors,
                disabled: disabled,
                logoFunc: _itemLogoFunc,
                itemName: _itemNameFunc.call(item),
                checkIconVisible: checkIconVisible,
                checkIconVisibleIfUnchecked: checkIconVisibleIfUnchecked,
                editIconVisible: editIconVisible,
                onTap: onTap,
                onLongPress: onLongPress,
              ),
            );
          case ItemsViewMode.grid:
            return ConvertouchMenuGridItem(
              item,
              checked: checked || selected,
              colors: itemColors,
              disabled: disabled,
              logoFunc: _itemLogoFunc,
              itemName: _itemNameFunc.call(item),
              checkIconVisible: checkIconVisible,
              checkIconVisibleIfUnchecked: checkIconVisibleIfUnchecked,
              editIconVisible: editIconVisible,
              onTap: onTap,
              onLongPress: onLongPress,
            );
        }
      }
      return null;
    };

    onLoadMore() {
      widget.itemsListBloc.add(
        const FetchItems(firstFetch: false),
      );
    }

    _listScrollController = ScrollController();
    _listScrollController.addListener(() {
      onScroll(
        controller: _listScrollController,
        hasReachedMax: widget.itemsListBloc.state.hasReachedMax,
        itemsNum: _itemsFullList.length,
        itemsNumInRow: 1,
        itemHeight: ConvertouchMenuListItem.defaultHeight,
        itemsSpacing: _itemsSpacing,
        onLoad: onLoadMore,
      );
    });

    _gridScrollController = ScrollController();
    _gridScrollController.addListener(() {
      onScroll(
        controller: _gridScrollController,
        hasReachedMax: widget.itemsListBloc.state.hasReachedMax,
        itemsNum: _itemsFullList.length,
        itemsNumInRow: 4,
        itemHeight: ConvertouchMenuGridItem.defaultHeight,
        itemsSpacing: _itemsSpacing,
        onLoad: onLoadMore,
      );
    });

    _onItemTap = (context, item, {bool callable = true}) {
      if (widget.removalModeEnabled) {
        if (!item.oob) {
          widget.onItemTapForRemoval?.call(item);
        }
      } else {
        if (callable) {
          FocusScope.of(context).unfocus();
          widget.onItemTap?.call(item);
        }
      }
    };
  }

  @override
  void dispose() {
    _itemsFullList.clear();
    _listScrollController.dispose();
    _gridScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkIconVisible =
        widget.checkableItemsVisible || widget.removalModeEnabled;

    return Column(
      children: [
        itemsListBlocBuilder(
          bloc: widget.itemsListBloc,
          builderFunc: (state) {
            return ConvertouchSearchBar(
              placeholder: widget.searchBarPlaceholder,
              pageName: widget.pageName,
              viewModeSettingKey: widget.viewModeSettingKey,
              onSearchStringChanged: (text) {
                widget.itemsListBloc.add(
                  FetchItems(
                    searchString: text,
                    parentItemId: state.parentItemId,
                  ),
                );
              },
              onSearchReset: () {
                widget.itemsListBloc.add(
                  FetchItems(parentItemId: state.parentItemId),
                );
              },
            );
          },
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: BlocListener<ItemsListBloc<T, ItemsFetched<T>>,
                ItemsFetched<T>>(
              bloc: widget.itemsListBloc,
              listener: (_, state) {
                setState(() {
                  if (state.pageNum <= 1) {
                    _itemsFullList.clear();
                  }
                  _itemsFullList.addAll(state.pageItems);
                });
              },
              child: appBlocBuilder(
                builderFunc: (appState) {
                  if (_itemsFullList.isEmpty) {
                    return Center(
                      child: NoItemsInfoLabel(
                        text: T == UnitGroupModel
                            ? "No unit groups added"
                            : "No units added",
                        colors: _emptyViewColors[appState.theme]!,
                      ),
                    );
                  }

                  ItemsViewMode itemsViewMode = T == UnitGroupModel
                      ? appState.unitGroupsViewMode
                      : appState.unitsViewMode;

                  var itemColors = _itemColors[appState.theme]!;

                  switch (itemsViewMode) {
                    case ItemsViewMode.list:
                      return ListView.builder(
                        controller: _listScrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _itemsFullList.length,
                        itemExtent: ConvertouchMenuListItem.defaultHeight +
                            _itemsSpacing,
                        padding: const EdgeInsets.only(
                          top: _itemsSpacing,
                          left: _itemsSpacing,
                          right: _itemsSpacing,
                          bottom: _bottomSpacing,
                        ),
                        itemBuilder: (context, index) {
                          return _itemBuilder.call(
                            context,
                            index,
                            itemColors: itemColors,
                            itemsViewMode: itemsViewMode,
                            checkIconVisible: checkIconVisible,
                          );
                        },
                      );
                    case ItemsViewMode.grid:
                      return GridView.builder(
                        controller: _gridScrollController,
                        itemCount: _itemsFullList.length,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          top: _itemsSpacing,
                          left: _itemsSpacing,
                          right: _itemsSpacing,
                          bottom: _bottomSpacing,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: _itemsSpacing,
                          mainAxisSpacing: _itemsSpacing,
                        ),
                        itemBuilder: (context, index) {
                          return _itemBuilder.call(
                            context,
                            index,
                            itemColors: itemColors,
                            itemsViewMode: itemsViewMode,
                            checkIconVisible: checkIconVisible,
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
