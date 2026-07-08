import 'package:collection/collection.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
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

  void fetchUnits<B extends UnitsBloc>(
    BuildContext context, {
    required int groupId,
    void Function()? onFirstFetch,
  }) {
    BlocProvider.of<B>(context).add(
      FetchItems(
        fetchParams: UnitsFetchParams(
          parentItemId: groupId,
          parentItemType: ItemType.unitGroup,
        ),
        onFirstFetch: onFirstFetch,
      ),
    );
  }

  void showUnits(BuildContext context, {required int groupId}) {
    fetchUnits<UnitsBloc>(
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
    bool paramsApplicable = false,
  }) {
    fetchUnits<UnitsBloc>(context, groupId: groupId);

    int markedItemsSelectionMinNum =
        (paramsApplicable || addedUnitIds.isNotEmpty)
            ? 1
            : minimumNumberOfConversionItems;

    BlocProvider.of<ItemsSelectionBloc>(context).add(
      StartItemsMarking(
        previouslyMarkedIds: addedUnitIds,
        markedItemsSelectionMinNum: markedItemsSelectionMinNum,
        excludedIds: addedUnitIds,
      ),
    );

    navigationController.navigateTo(
      context,
      pageName: PageName.unitsPageForConversion,
    );
  }

  void showUnitsForChangeInConversionItem(
    BuildContext context, {
    required int currentUnitId,
    required int unitGroupId,
    required List<ConversionUnitValueModel> convertedUnitValues,
  }) {
    fetchUnits<UnitsBloc>(context, groupId: unitGroupId);

    BlocProvider.of<ItemsSelectionBloc>(context).add(
      StartItemSelection(
        previouslySelectedId: currentUnitId,
        excludedIds: convertedUnitValues
            .map((item) => item.unit.id)
            .whereNot((id) => id == currentUnitId)
            .toList(),
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
        fetchParams: UnitsFetchParams(
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
    fetchUnits<UnitsBlocForUnitDetails>(context, groupId: currentGroupId);

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
    required int unitId,
    List<int> oobIds = const [],
  }) {
    BlocProvider.of<ItemsSelectionBloc>(context).add(
      StartItemsMarking(
        showCancelIcon: true,
        previouslyMarkedIds: [unitId],
        excludedIds: oobIds,
      ),
    );
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
          fetchUnits<UnitsBloc>(context, groupId: currentGroupId);
          navigationController.navigateBack(context);
          onSaved?.call(savedUnit);
        },
        onError: (error) {
          navigationController.showException(context, exception: error);
        },
      ),
    );
  }

  void remove(
    BuildContext context, {
      required int unitGroupId,
    List<int> unitIds = const [],
    void Function()? onSuccess,
  }) {
    BlocProvider.of<UnitsBloc>(context).add(
      RemoveItems(
        ids: unitIds,
        onSuccess: ({info}) {
          fetchUnits<UnitsBloc>(context, groupId: unitGroupId);
          onSuccess?.call();
        },
      ),
    );

    BlocProvider.of<ItemsSelectionBloc>(context).add(
      const CancelItemsMarking(),
    );
  }
}
