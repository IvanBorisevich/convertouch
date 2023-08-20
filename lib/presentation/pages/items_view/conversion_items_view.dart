import 'package:convertouch/domain/entities/unit_group_entity.dart';
import 'package:convertouch/domain/entities/unit_value_entity.dart';
import 'package:convertouch/presentation/pages/items_view/item/item.dart';
import 'package:convertouch/presentation/pages/scaffold/bloc_wrappers.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItemsView extends StatefulWidget {
  const ConvertouchConversionItemsView(
    this.convertedItems, {
    required this.sourceUnitId,
    required this.sourceValue,
    required this.unitGroup,
    this.onItemTap,
    this.onItemValueChanged,
    super.key,
  });

  final List<UnitValueEntity> convertedItems;
  final int sourceUnitId;
  final String sourceValue;
  final UnitGroupEntity unitGroup;
  final void Function(UnitValueEntity)? onItemTap;
  final void Function(UnitValueEntity, String)? onItemValueChanged;

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
      padding: const EdgeInsetsDirectional.fromSTEB(_listSpacingLeftRight,
          _listSpacingTop, _listSpacingLeftRight, _listSpacingBottom),
      itemBuilder: (context, index) {
        UnitValueEntity item = widget.convertedItems[index];
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
              index == widget.convertedItems.length - 1
                  ? _listItemSpacing
                  : 0)),
      itemCount: widget.convertedItems.length,
    );
  }
}
