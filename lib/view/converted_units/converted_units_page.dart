import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/view/converted_units/converted_unit_item.dart';
import 'package:flutter/material.dart';

class ConvertouchConvertedUnitsPage extends StatefulWidget {
  const ConvertouchConvertedUnitsPage(this.items, {super.key});

  final List<UnitValueModel> items;

  @override
  State<ConvertouchConvertedUnitsPage> createState() =>
      _ConvertouchConvertedUnitsPageState();
}

class _ConvertouchConvertedUnitsPageState
    extends State<ConvertouchConvertedUnitsPage> {
  static const double _listItemsSpacingSize = 12;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.all(_listItemsSpacingSize),
        itemBuilder: (context, index) {
          return ConvertouchConvertedUnitItem(widget.items[index]);
        },
        separatorBuilder: (context, index) => Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                _listItemsSpacingSize,
                _listItemsSpacingSize,
                _listItemsSpacingSize,
                index == widget.items.length - 1 ? _listItemsSpacingSize : 0)),
        itemCount: widget.items.length);
  }
}
