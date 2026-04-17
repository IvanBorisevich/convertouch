import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/groups_controller.dart';
import 'package:convertouch/presentation/controller/navigation_controller.dart';
import 'package:convertouch/presentation/controller/refreshing_job_controller.dart';
import 'package:convertouch/presentation/controller/unit_group_details_controller.dart';
import 'package:convertouch/presentation/controller/units_controller.dart';
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
    final itemsSelectionBloc = BlocProvider.of<ItemsSelectionBloc>(context);

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
                  groupsController.showGroup(context, unitGroup: unitGroup);

                  conversionController.getConversion(
                    context,
                    unitGroup: unitGroup,
                    processCurrentConversion: (conversion) {
                      if (conversion != null && conversion.hasItems) {
                        refreshingJobController.getJobs(
                          context,
                          unitGroup: unitGroup,
                        );

                        navigationController.navigateTo(
                          context,
                          pageName: PageName.conversionPage,
                        );
                      } else {
                        unitsController.showUnitsForAdding(
                          context,
                          groupId: unitGroup.id,
                          markedItemsSelectionMinNum:
                              minimumNumberOfConversionItems,
                        );
                      }
                    },
                  );
                },
                onItemTapForRemoval: (unitGroup) {
                  groupsController.markForRemoval(
                    context,
                    groupId: unitGroup.id,
                  );
                },
                onItemLongPress: (unitGroup) {
                  groupsController.startRemoval(
                    context,
                    showCancelIcon: itemsSelectionState.showCancelIcon,
                    groupId: unitGroup.id,
                    oobIds: unitGroupsBloc.state.oobIds,
                  );
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
                        groupsController.remove(
                          context,
                          groupIds: itemsSelectionState.markedIds,
                        );
                      },
                    )
                  : ConvertouchFloatingActionButton.adding(
                      onClick: () {
                        unitGroupDetailsController.startGroupCreation(context);
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
