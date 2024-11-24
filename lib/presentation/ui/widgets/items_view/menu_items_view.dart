import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_state.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_states.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/info_box_no_items.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/items_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchMenuItemsView<T extends IdNameItemModel>
    extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (_, appState) {
        if (appState is AppStateReady) {
          ItemsViewMode itemsViewMode = T == UnitGroupModel
              ? appState.unitGroupsViewMode
              : appState.unitsViewMode;

          ConvertouchColorScheme emptyViewColors;
          if (T == UnitGroupModel) {
            emptyViewColors = unitGroupPageEmptyViewColor[appState.theme]!;
          } else {
            emptyViewColors = unitPageEmptyViewColor[appState.theme]!;
          }

          var itemsState = itemsListBloc.state;

          switch (itemsState.status) {
            case FetchingStatus.failure:
              return Center(
                child: InfoBoxNoItems(
                  text: T == UnitGroupModel
                      ? "Failed to fetch new unit groups"
                      : "Failed to fetch new units",
                  colors: emptyViewColors,
                ),
              );
            case FetchingStatus.success:
              if (itemsState.pageItems.isEmpty && itemsState.pageNum == 0) {
                return Center(
                  child: InfoBoxNoItems(
                    text: T == UnitGroupModel
                        ? "No unit groups added"
                        : "No units added",
                    colors: emptyViewColors,
                  ),
                );
              }
              break;
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
                size: 29,
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

          return ConvertouchItemsListView<T>(
            itemsListBloc: itemsListBloc,
            onItemTap: onItemTap,
            onItemLongPress: onItemLongPress,
            onItemTapForRemoval: onItemTapForRemoval,
            logoFunc: itemLogoFunc,
            colors: itemColors,
            itemsSpacing: itemsSpacing,
            itemsBottomSpacing: itemsBottomSpacing,
            selectedItemId: selectedItemId,
            itemNameFunc: itemNameFunc,
            onLoadMore: () {
              itemsListBloc.add(
                const FetchItems(firstFetch: false),
              );
            },
          );

          // switch (itemsViewMode) {
          //   case ItemsViewMode.list:
          //     return ConvertouchItemsListView<T>(
          //       itemsListBloc: itemsListBloc,
          //       onItemTap: onItemTap,
          //       onItemLongPress: onItemLongPress,
          //       onItemTapForRemoval: onItemTapForRemoval,
          //       logoFunc: itemLogoFunc,
          //       colors: itemColors,
          //       itemsSpacing: itemsSpacing,
          //       itemsBottomSpacing: itemsBottomSpacing,
          //       selectedItemId: selectedItemId,
          //       itemNameFunc: itemNameFunc,
          //       onLoadMore: () {
          //         itemsListBloc.add(
          //           const FetchItems(firstFetch: false),
          //         );
          //       },
          //     );
          //   case ItemsViewMode.grid:
          //     return ConvertouchItemsGridView<T>(
          //       itemsListBloc: itemsListBloc,
          //       onItemTap: onItemTap,
          //       onItemLongPress: onItemLongPress,
          //       onItemTapForRemoval: onItemTapForRemoval,
          //       logoFunc: itemLogoFunc,
          //       colors: itemColors,
          //       itemsSpacing: itemsSpacing,
          //       itemsBottomSpacing: itemsBottomSpacing,
          //       selectedItemId: selectedItemId,
          //       itemNameFunc: itemNameFunc,
          //       onLoadMore: () {
          //         itemsListBloc.add(
          //           const FetchItems(firstFetch: false),
          //         );
          //       },
          //     );
          // }
        } else {
          return const SizedBox(
            height: 0,
            width: 0,
          );
        }
      },
    );
  }
}
