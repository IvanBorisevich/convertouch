import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/menu_items_reactive_view.dart';
import 'package:convertouch/presentation/ui/widgets/search_bar.dart';
import 'package:convertouch/presentation/ui/widgets/secondary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPageForUnitDetails extends StatelessWidget {
  const ConvertouchUnitGroupsPageForUnitDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    final unitGroupsBloc =
        BlocProvider.of<UnitGroupsBlocForUnitDetails>(context);
    final unitGroupSelectionBloc =
        BlocProvider.of<ItemsSelectionBlocForUnitDetails>(context);
    final unitDetailsBloc = BlocProvider.of<UnitDetailsBloc>(context);

    return appBlocBuilder(
      builderFunc: (appState) {
        return unitGroupsBlocBuilder(
          bloc: unitGroupsBloc,
          builderFunc: (pageState) {
            return itemsSelectionBlocBuilder(
              bloc: unitGroupSelectionBloc,
              builderFunc: (itemsSelectionState) {
                return ConvertouchPage(
                  title: "Select Group",
                  secondaryAppBar: SecondaryAppBar(
                    theme: appState.theme,
                    child: ConvertouchSearchBar(
                      placeholder: "Search unit groups...",
                      theme: appState.theme,
                      pageViewMode: appState.unitGroupsViewMode,
                      onViewModeChange: () {
                        appBloc.add(
                          ChangeSetting(
                            settingKey: SettingKeys.unitGroupsViewMode,
                            settingValue:
                                appState.unitGroupsViewMode.next.value,
                          ),
                        );
                      },
                      onSearchStringChanged: (text) {
                        unitGroupsBloc.add(
                          FetchItems(searchString: text),
                        );
                      },
                      onSearchReset: () {
                        unitGroupsBloc.add(
                          const FetchItems(searchString: null),
                        );
                      },
                    ),
                  ),
                  body: ConvertouchMenuItemsReactiveView(
                    itemsListBloc: unitGroupsBloc,
                    onItemTap: (unitGroup) {
                      unitDetailsBloc.add(
                        ChangeGroupInUnitDetails(
                          unitGroup: unitGroup,
                        ),
                      );
                    },
                    onItemTapForRemoval: null,
                    onItemLongPress: null,
                    checkedItemIds: const [],
                    disabledItemIds: const [],
                    selectedItemId: itemsSelectionState.selectedId,
                    editableItemsVisible: false,
                    checkableItemsVisible: true,
                    removalModeEnabled: false,
                    itemsViewMode: appState.unitsViewMode,
                    theme: appState.theme,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
