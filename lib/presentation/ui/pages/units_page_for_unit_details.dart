import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/menu_items_reactive_view.dart';
import 'package:convertouch/presentation/ui/widgets/search_bar.dart';
import 'package:convertouch/presentation/ui/widgets/secondary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageForUnitDetails extends StatelessWidget {
  const ConvertouchUnitsPageForUnitDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    final itemsSelectionBloc =
        BlocProvider.of<ItemsSelectionBlocForUnitDetails>(context);
    final unitsBloc = BlocProvider.of<UnitsBlocForUnitDetails>(context);
    final unitDetailsBloc = BlocProvider.of<UnitDetailsBloc>(context);

    return appBlocBuilder(
      builderFunc: (appState) {
        return unitsBlocBuilder(
          bloc: unitsBloc,
          builderFunc: (pageState) {
            return itemsSelectionBlocBuilder(
              bloc: itemsSelectionBloc,
              builderFunc: (itemsSelectionState) {
                return ConvertouchPage(
                  title: "Select Argument Unit",
                  secondaryAppBar: SecondaryAppBar(
                    theme: appState.theme,
                    child: ConvertouchSearchBar(
                      placeholder: "Search units...",
                      theme: appState.theme,
                      pageViewMode: appState.unitsViewMode,
                      onViewModeChange: () {
                        appBloc.add(
                          ChangeSetting(
                            settingKey: SettingKeys.unitsViewMode,
                            settingValue: appState.unitsViewMode.next.value,
                          ),
                        );
                      },
                      onSearchStringChanged: (text) {
                        unitsBloc.add(
                          FetchItems(
                            parentItemId: pageState.parentItemId,
                            searchString: text,
                          ),
                        );
                      },
                      onSearchReset: () {
                        unitsBloc.add(
                          FetchItems(
                            parentItemId: pageState.parentItemId,
                          ),
                        );
                      },
                    ),
                  ),
                  body: ConvertouchMenuItemsReactiveView(
                    itemsListBloc: unitsBloc,
                    onItemTap: (unit) {
                      unitDetailsBloc.add(
                        ChangeArgumentUnitInUnitDetails(
                          argumentUnit: unit,
                        ),
                      );
                    },
                    onItemTapForRemoval: null,
                    onItemLongPress: null,
                    checkedItemIds: const [],
                    disabledItemIds: itemsSelectionState.excludedIds,
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
