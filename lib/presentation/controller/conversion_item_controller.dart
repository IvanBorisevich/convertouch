import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final conversionItemController = di.locator.get<ConversionItemController>();

class ConversionItemController {
  const ConversionItemController();

  void updateUnitValue(
    BuildContext context, {
    required String id,
    required ConversionUnitValueModel newUnitValue,
    bool isSource = false,
  }) {
    BlocProvider.of<ConversionItemBloc>(context).add(
      UpdateUnitValue(
        id: id,
        newItemValue: newUnitValue,
        isSource: isSource,
      ),
    );
  }

  void updateParamValue(
    BuildContext context, {
    required String id,
    required ConversionParamValueModel newParamValue,
  }) {
    BlocProvider.of<ConversionItemBloc>(context).add(
      UpdateParamValue(
        id: id,
        newItemValue: newParamValue,
      ),
    );
  }

  void resetUnitValues(BuildContext context) {
    BlocProvider.of<ConversionItemBloc>(context).add(
      const ResetUnitValues(),
    );
  }

  void resetParamValues(BuildContext context) {
    BlocProvider.of<ConversionItemBloc>(context).add(
      const ResetParamValues(),
    );
  }
}
