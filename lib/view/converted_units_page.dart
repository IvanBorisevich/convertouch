import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/presenter/bloc/converted_units_bloc.dart';
import 'package:convertouch/presenter/states/converted_items_state.dart';
import 'package:convertouch/view/items_model/converted_unit_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchConvertedUnitsPage extends StatefulWidget {
  const ConvertouchConvertedUnitsPage({super.key});

  @override
  State<ConvertouchConvertedUnitsPage> createState() =>
      _ConvertouchConvertedUnitsPageState();
}

class _ConvertouchConvertedUnitsPageState
    extends State<ConvertouchConvertedUnitsPage> {
  static const double _listSpacingLeftRight = 7;
  static const double _listSpacingTop = 9;
  static const double _listSpacingBottom = 8;
  static const double _listItemSpacing = 9;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConvertedUnitsBloc, ConvertedItemsState>(
        builder: (_, convertedItemsState) {
      List<UnitValueModel> convertedItems = convertedItemsState.convertedItems;

      return ListView.separated(
          padding: const EdgeInsetsDirectional.fromSTEB(_listSpacingLeftRight,
              _listSpacingTop, _listSpacingLeftRight, _listSpacingBottom),
          itemBuilder: (context, index) {
            return ConvertouchConvertedUnitItem(convertedItems[index]);
          },
          separatorBuilder: (context, index) => Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                  _listItemSpacing,
                  _listItemSpacing,
                  _listItemSpacing,
                  index == convertedItems.length - 1 ? _listItemSpacing : 0)),
          itemCount: convertedItems.length);
    });
  }
}
