import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/menu_items_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPageForUnitDetails extends StatelessWidget {
  const ConvertouchUnitGroupsPageForUnitDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final unitGroupsBloc =
        BlocProvider.of<UnitGroupsBlocForUnitDetails>(context);
    final unitGroupSelectionBloc =
        BlocProvider.of<ItemsSelectionBlocForUnitDetails>(context);
    final unitDetailsBloc = BlocProvider.of<UnitDetailsBloc>(context);

    return itemsSelectionBlocBuilder(
      bloc: unitGroupSelectionBloc,
      builderFunc: (itemsSelectionState) {
        return ConvertouchPage(
          title: "Select Group",
          body: ConvertouchMenuItemsView(
            itemsListBloc: unitGroupsBloc,
            pageName: PageName.unitGroupsPageForUnitDetails,
            viewModeSettingKey: SettingKey.unitGroupsViewMode,
            searchBarPlaceholder: "Search unit groups...",
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
          ),
        );
      },
    );
  }
}
