import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/presentation/pages/items_view/item/item.dart';
import 'package:convertouch/presentation/pages/scaffold/bloc_wrappers.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItemsView extends StatefulWidget {
  const ConvertouchConversionItemsView(
    this.convertedItems, {
    required this.sourceUnitId,
    this.sourceValue,
    required this.unitGroup,
    this.onItemTap,
    this.onItemValueChanged,
    super.key,
  });

  final List<UnitValueModel> convertedItems;
  final int sourceUnitId;
  final double? sourceValue;
  final UnitGroupModel unitGroup;
  final void Function(UnitValueModel)? onItemTap;
  final void Function(UnitValueModel, String)? onItemValueChanged;

  @override
  State createState() => _ConvertouchConversionItemsViewState();
}

class _ConvertouchConversionItemsViewState
    extends State<ConvertouchConversionItemsView> {
  static const double _listSpacingLeftRight = 7;
  static const double _listSpacingTop = 9;
  static const double _listSpacingBottom = 8;
  static const double _listItemSpacing = 9;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(
        _listSpacingLeftRight,
        _listSpacingTop,
        _listSpacingLeftRight,
        _listSpacingBottom,
      ),
      itemBuilder: (context, index) {
        /*
        TODO: change logic to distinguish update conversion item (from bloc)
         and replace it with widget.convertedItems[index]
         */
        UnitValueModel item = widget.convertedItems[index];
        return unitsConversionBlocForItem(item, (item) {
          return ConvertouchItem.createItem(
            item,
            onTap: () {
              widget.onItemTap?.call(item);
            },
            onValueChanged: (String value) {
              widget.onItemValueChanged?.call(item, value);
            },
          ).buildForList();
        });
      },
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          _listItemSpacing,
          _listItemSpacing,
          _listItemSpacing,
          index == widget.convertedItems.length - 1 ? _listItemSpacing : 0,
        ),
      ),
      itemCount: widget.convertedItems.length,
    );
  }
}
