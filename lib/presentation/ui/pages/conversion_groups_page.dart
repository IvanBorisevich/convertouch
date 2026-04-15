import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/single_group_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/widgets/cancel_items_selection_icon.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/menu_items_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversionGroupsPage extends StatelessWidget {
  const ConversionGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final unitGroupsBloc = BlocProvider.of<UnitGroupsBloc>(context);
    final unitGroupDetailsBloc = BlocProvider.of<UnitGroupDetailsBloc>(context);
    final unitsBloc = BlocProvider.of<UnitsBloc>(context);
    final unitsSelectionBloc = BlocProvider.of<ItemsSelectionBloc>(context);
    final conversionBloc = BlocProvider.of<ConversionBloc>(context);
    final singleGroupBloc = BlocProvider.of<SingleGroupBloc>(context);
    final refreshingJobsBloc = BlocProvider.of<RefreshingJobsBloc>(context);
    final itemsSelectionBloc = BlocProvider.of<ItemsSelectionBloc>(context);
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return itemsSelectionBlocBuilder(
      bloc: itemsSelectionBloc,
      builderFunc: (itemsSelectionState) {
        return appBlocBuilder(
          builderFunc: (appState) {
            return ConvertouchPage(
              title: 'Conversion Groups',
              appBarLeadingWidget: itemsSelectionState.showCancelIcon
                  ? CancelItemsSelectionIcon(
                      bloc: itemsSelectionBloc,
                    )
                  : null,
              colors: appColors[appState.theme].page,
              body: ConvertouchMenuItemsView(
                itemsListBloc: unitGroupsBloc,
                pageName: PageName.conversionGroupsPage,
                viewModeSettingKey: SettingKey.unitGroupsViewMode,
                searchBarPlaceholder: 'Search groups...',
                noItemsLabel: 'No unit groups',
                colors: appColors[appState.theme].unitGroupsMenu,
                itemsViewMode: appState.unitGroupsViewMode,
                checkedItemIds: itemsSelectionState.markedIds,
                disabledItemIds: const [],
                editableItemsVisible: true,
                checkableItemsVisible: itemsSelectionState.showCancelIcon,
                removalModeEnabled: itemsSelectionState.showCancelIcon,
                onItemTap: (unitGroup) {
                  singleGroupBloc.add(
                    ShowGroup(unitGroup: unitGroup),
                  );
                  conversionBloc.add(
                    GetConversion(
                      unitGroup: unitGroup,
                      processPrevConversion: (prevConversion) {
                        conversionBloc.add(
                          SaveConversion(conversion: prevConversion),
                        );
                      },
                      processCurrentConversion: (conversion) {
                        if (conversion != null && conversion.hasItems) {
                          if (unitGroup.refreshable) {
                            refreshingJobsBloc.add(
                              FetchRefreshingJob(
                                unitGroupName: unitGroup.name,
                              ),
                            );
                          }
                          navigationBloc.add(
                            const NavigateToPage(
                              pageName: PageName.conversionPage,
                            ),
                          );
                        } else {
                          unitsBloc.add(
                            FetchItems(
                              params: UnitsFetchParams(
                                parentItemId: unitGroup.id,
                                parentItemType: ItemType.unitGroup,
                              ),
                            ),
                          );
                          unitsSelectionBloc.add(
                            const StartItemsMarking(
                              markedItemsSelectionMinNum: unitValuesMinNum,
                            ),
                          );
                          navigationBloc.add(
                            const NavigateToPage(
                              pageName: PageName.unitsPageForConversion,
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
                onItemTapForRemoval: (unitGroup) {
                  itemsSelectionBloc.add(
                    SelectSingleItem(id: unitGroup.id),
                  );
                },
                onItemLongPress: (unitGroup) {
                  if (!itemsSelectionState.showCancelIcon) {
                    itemsSelectionBloc.add(
                      StartItemsMarking(
                        showCancelIcon: true,
                        previouslyMarkedIds: [unitGroup.id],
                        excludedIds: unitGroupsBloc.state.oobIds,
                      ),
                    );
                  }
                },
              ),
              floatingActionButton: itemsSelectionState.showCancelIcon
                  ? ConvertouchFloatingActionButton.removal(
                      visible: itemsSelectionState.markedIds.isNotEmpty,
                      extraLabelText:
                          itemsSelectionState.markedIds.length.toString(),
                      colorScheme:
                          appColors[appState.theme].removalFloatingButton,
                      onClick: () {
                        unitGroupsBloc.add(
                          RemoveItems(
                            ids: itemsSelectionState.markedIds,
                          ),
                        );
                        itemsSelectionBloc.add(
                          const CancelItemsMarking(),
                        );
                      },
                    )
                  : ConvertouchFloatingActionButton.adding(
                      onClick: () {
                        unitGroupDetailsBloc.add(
                          const GetNewUnitGroupDetails(),
                        );
                      },
                      visible: true,
                      colorScheme: appColors[appState.theme]
                          .unitGroupsPageFloatingButton,
                    ),
            );
          },
        );
      },
    );
  }
}
