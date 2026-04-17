import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/conversion_param_sets_page/single_param_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/controller/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final unitsController = di.locator.get<UnitsController>();

class UnitsController {
  const UnitsController();

  void fetchUnits(
    BuildContext context, {
    required int groupId,
    void Function()? onFirstFetch,
  }) {
    BlocProvider.of<UnitsBloc>(context).add(
      FetchItems(
        params: UnitsFetchParams(
          parentItemId: groupId,
          parentItemType: ItemType.unitGroup,
        ),
        onFirstFetch: onFirstFetch,
      ),
    );
  }

  void showUnits(BuildContext context, {required int groupId}) {
    fetchUnits(
      context,
      groupId: groupId,
      onFirstFetch: () {
        navigationController.navigateTo(
          context,
          pageName: PageName.unitsPageRegular,
        );
      },
    );
  }

  void markUnit(BuildContext context, {required int unitId}) {
    BlocProvider.of<ItemsSelectionBloc>(context).add(
      SelectSingleItem(id: unitId),
    );
  }

  void showUnitsForAdding(
    BuildContext context, {
    required int groupId,
    List<int> addedUnitIds = const [],
    required int markedItemsSelectionMinNum,
  }) {
    fetchUnits(context, groupId: groupId);

    BlocProvider.of<ItemsSelectionBloc>(context).add(
      StartItemsMarking(
        previouslyMarkedIds: addedUnitIds,
        markedItemsSelectionMinNum: markedItemsSelectionMinNum,
      ),
    );

    navigationController.navigateTo(
      context,
      pageName: PageName.unitsPageForConversion,
    );
  }

  void showUnitsForChangeInConversionItem(
    BuildContext context, {
    required int groupId,
    required int currentUnitId,
    List<int> excludedUnitIds = const [],
  }) {
    fetchUnits(context, groupId: groupId);

    BlocProvider.of<ItemsSelectionBloc>(context).add(
      StartItemSelection(
        previouslySelectedId: currentUnitId,
        excludedIds: excludedUnitIds,
      ),
    );

    navigationController.navigateTo(
      context,
      pageName: PageName.unitsPageForConversion,
    );
  }

  void showUnitsForChangeInParam(
    BuildContext context, {
    required ConversionParamValueModel paramValue,
  }) {
    BlocProvider.of<SingleParamBloc>(context).add(
      ShowParam(param: paramValue.param),
    );

    BlocProvider.of<UnitsBloc>(context).add(
      FetchItems(
        params: UnitsFetchParams(
          parentItemId: paramValue.param.id,
          parentItemType: ItemType.conversionParam,
        ),
      ),
    );

    BlocProvider.of<ItemsSelectionBloc>(context).add(
      StartItemSelection(
        previouslySelectedId: paramValue.unit!.id,
      ),
    );

    navigationController.navigateTo(
      context,
      pageName: PageName.unitsPageForConversionParams,
    );
  }

  void showArgUnitsForChange(
    BuildContext context, {
    required int currentUnitId,
    required int currentGroupId,
    required int currentArgUnitId,
  }) {
    BlocProvider.of<UnitsBlocForUnitDetails>(context).add(
      FetchItems(
        params: UnitsFetchParams(
          parentItemId: currentGroupId,
          parentItemType: ItemType.unitGroup,
        ),
      ),
    );

    BlocProvider.of<ItemsSelectionBlocForUnitDetails>(context).add(
      StartItemSelection(
        previouslySelectedId: currentArgUnitId,
        excludedIds: [currentUnitId],
      ),
    );

    navigationController.navigateTo(
      context,
      pageName: PageName.unitsPageForUnitDetails,
    );
  }

  void startRemoval(
    BuildContext context, {
    required bool showCancelIcon,
    required int unitId,
    List<int> oobIds = const [],
  }) {
    if (!showCancelIcon) {
      BlocProvider.of<ItemsSelectionBloc>(context).add(
        StartItemsMarking(
          showCancelIcon: true,
          previouslyMarkedIds: [unitId],
          excludedIds: oobIds,
        ),
      );
    }
  }

  void save(
    BuildContext context, {
    required UnitModel unit,
    required int currentGroupId,
    void Function(UnitModel)? onSaved,
  }) {
    BlocProvider.of<UnitsBloc>(context).add(
      SaveItem(
        item: unit,
        onItemSave: (savedUnit) {
          unitsController.fetchUnits(context, groupId: currentGroupId);
          onSaved?.call(savedUnit);
          navigationController.navigateBack(context);
        },
      ),
    );
  }

  void remove(
    BuildContext context, {
    List<int> unitIds = const [],
    void Function()? onSuccess,
  }) {
    BlocProvider.of<UnitsBloc>(context).add(
      RemoveItems(ids: unitIds),
    );

    BlocProvider.of<ItemsSelectionBloc>(context).add(
      const CancelItemsMarking(),
    );

    onSuccess?.call();
  }
}
