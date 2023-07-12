import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/view/items_view/item_view_mode/unit_value_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchConversionItemsView extends StatelessWidget {
  const ConvertouchConversionItemsView({super.key});

  static const double _listSpacingLeftRight = 7;
  static const double _listSpacingTop = 9;
  static const double _listSpacingBottom = 8;
  static const double _listItemSpacing = 9;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitsConversionBloc, UnitsConversionState>(
        builder: (_, convertedUnitsState) {
      if (convertedUnitsState is UnitsConverted) {
        List<UnitValueModel> convertedItems =
            convertedUnitsState.convertedUnitValues;
        return ListView.separated(
            padding: const EdgeInsetsDirectional.fromSTEB(
                _listSpacingLeftRight,
                _listSpacingTop,
                _listSpacingLeftRight,
                _listSpacingBottom),
            itemBuilder: (context, index) {
              return ConvertouchUnitValueListItem(convertedItems[index]);
            },
            separatorBuilder: (context, index) => Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    _listItemSpacing,
                    _listItemSpacing,
                    _listItemSpacing,
                    index == convertedItems.length - 1 ? _listItemSpacing : 0)),
            itemCount: convertedItems.length);
      } else {
        return const SizedBox();
      }
    });
  }
}
