import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final conversionItemController = di.locator.get<ConversionItemController>();

class ConversionItemController {
  const ConversionItemController();

  void updateItemValue(
    BuildContext context, {
    required String id,
    required ItemValueModel newItemValue,
    bool isSource = false,
  }) {
    BlocProvider.of<ConversionItemBloc>(context).add(
      UpdateItemValue(
        id: id,
        newValue: newItemValue,
        isSource: isSource,
      ),
    );
  }

  void resetItemValues(BuildContext context) {
    BlocProvider.of<ConversionItemBloc>(context).add(
      const ResetItemValues(),
    );
  }
}
