import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/conversion_param_sets_page/conversion_param_sets_bloc.dart';
import 'package:convertouch/presentation/controller/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final paramSetsController = di.locator.get<ConversionParamSetsController>();

class ConversionParamSetsController {
  const ConversionParamSetsController();

  void markForAdding(BuildContext context, {required int paramSetId}) {
    BlocProvider.of<ItemsSelectionBloc>(context).add(
      SelectSingleItem(id: paramSetId),
    );
  }

  void showParametersForAdding(
    BuildContext context, {
    required int groupId,
    required ConversionParamSetValueBulkModel? params,
  }) {
    BlocProvider.of<ConversionParamSetsBloc>(context).add(
      FetchItems(
        params: ParamSetsFetchParams(
          parentItemId: groupId,
        ),
      ),
    );

    BlocProvider.of<ItemsSelectionBloc>(context).add(
      StartItemsMarking(
        previouslyMarkedIds:
            params?.paramSetValues.map((item) => item.paramSet.id).toList(),
        excludedIds: params?.paramSetValues
                .where((item) => item.paramSet.mandatory)
                .map((item) => item.paramSet.id)
                .toList() ??
            [],
      ),
    );

    navigationController.navigateTo(context, pageName: PageName.paramSetsPage);
  }
}
