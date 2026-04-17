import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/single_group_bloc.dart';
import 'package:convertouch/presentation/controller/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final groupsController = di.locator.get<ConversionGroupsController>();

class ConversionGroupsController {
  const ConversionGroupsController();

  void showGroup(BuildContext context, {required UnitGroupModel unitGroup}) {
    BlocProvider.of<SingleGroupBloc>(context).add(
      ShowGroup(unitGroup: unitGroup),
    );
  }

  void showGroupsForChangeInUnitDetails(
    BuildContext context, {
    required int currentGroupId,
  }) {
    BlocProvider.of<UnitGroupsBlocForUnitDetails>(context).add(
      const FetchItems<UnitGroupsFetchParams>(),
    );

    BlocProvider.of<ItemsSelectionBlocForUnitDetails>(context).add(
      StartItemSelection(previouslySelectedId: currentGroupId),
    );

    navigationController.navigateTo(
      context,
      pageName: PageName.unitGroupsPageForUnitDetails,
    );
  }

  void startRemoval(
    BuildContext context, {
    required bool showCancelIcon,
    required int groupId,
    List<int> oobIds = const [],
  }) {
    if (!showCancelIcon) {
      BlocProvider.of<ItemsSelectionBloc>(context).add(
        StartItemsMarking(
          showCancelIcon: true,
          previouslyMarkedIds: [groupId],
          excludedIds: oobIds,
        ),
      );
    }
  }

  void markForRemoval(BuildContext context, {required int groupId}) {
    BlocProvider.of<ItemsSelectionBloc>(context).add(
      SelectSingleItem(id: groupId),
    );
  }

  void save(
    BuildContext context, {
    required UnitGroupModel unitGroup,
    void Function(UnitGroupModel)? onSaved,
  }) {
    BlocProvider.of<UnitGroupsBloc>(context).add(
      SaveItem(
        item: unitGroup,
        onItemSave: (savedGroup) {
          BlocProvider.of<UnitGroupsBloc>(context).add(
            const FetchItems<UnitGroupsFetchParams>(),
          );

          showGroup(context, unitGroup: savedGroup);

          onSaved?.call(savedGroup);
        },
      ),
    );
  }

  void remove(BuildContext context, {List<int> groupIds = const []}) {
    BlocProvider.of<UnitGroupsBloc>(context).add(
      RemoveItems(ids: groupIds),
    );
    BlocProvider.of<ItemsSelectionBloc>(context).add(
      const CancelItemsMarking(),
    );
  }
}
