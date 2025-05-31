import 'package:convertouch/domain/constants/constants.dart';
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
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
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
    final conversionBloc = BlocProvider.of<ConversionBloc>(context);
    final singleGroupBloc = BlocProvider.of<SingleGroupBloc>(context);
    final refreshingJobsBloc = BlocProvider.of<RefreshingJobsBloc>(context);
    final itemsSelectionBloc = BlocProvider.of<ItemsSelectionBloc>(context);
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return itemsSelectionBlocBuilder(
      bloc: itemsSelectionBloc,
      builderFunc: (itemsSelectionState) {
        return ConvertouchPage(
          title: 'Conversion Groups',
          customLeadingIcon: itemsSelectionState.showCancelIcon
              ? CancelItemsSelectionIcon(
                  bloc: itemsSelectionBloc,
                )
              : null,
          body: ConvertouchMenuItemsView(
            itemsListBloc: unitGroupsBloc,
            pageName: PageName.conversionGroupsPage,
            viewModeSettingKey: SettingKey.unitGroupsViewMode,
            searchBarPlaceholder: 'Search groups...',
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
                  onComplete: () {
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
            checkedItemIds: itemsSelectionState.markedIds,
            disabledItemIds: const [],
            editableItemsVisible: true,
            checkableItemsVisible: itemsSelectionState.showCancelIcon,
            removalModeEnabled: itemsSelectionState.showCancelIcon,
          ),
          floatingActionButton: appBlocBuilder(
            builderFunc: (appState) {
              ConvertouchColorScheme floatingButtonColor =
                  unitGroupsPageFloatingButtonColors[appState.theme]!;
              ConvertouchColorScheme removalButtonColor =
                  removalFloatingButtonColors[appState.theme]!;

              return itemsSelectionState.showCancelIcon
                  ? ConvertouchFloatingActionButton.removal(
                      visible: itemsSelectionState.markedIds.isNotEmpty,
                      extraLabelText:
                          itemsSelectionState.markedIds.length.toString(),
                      colorScheme: removalButtonColor,
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
                      colorScheme: floatingButtonColor,
                    );
            },
          ),
        );
      },
    );
  }
}
