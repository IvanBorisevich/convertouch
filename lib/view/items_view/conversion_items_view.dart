import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/events/units_menu_events.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/view/items_view/item_view_mode/unit_value_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchConversionItemsView extends StatefulWidget {
  const ConvertouchConversionItemsView(this.convertedItems,
      {required this.sourceUnitId,
      required this.sourceValue,
      required this.unitGroup,
      super.key});

  final List<UnitValueModel> convertedItems;
  final int sourceUnitId;
  final String sourceValue;
  final UnitGroupModel unitGroup;

  @override
  State createState() => _ConvertouchConversionItemsViewState();
}

class _ConvertouchConversionItemsViewState
    extends State<ConvertouchConversionItemsView> {
  static const double _listSpacingLeftRight = 7;
  static const double _listSpacingTop = 9;
  static const double _listSpacingBottom = 8;
  static const double _listItemSpacing = 9;

  late List<int> _conversionUnitIds;

  @override
  void initState() {
    super.initState();
    _conversionUnitIds =
        widget.convertedItems.map((unitValue) => unitValue.unit.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsetsDirectional.fromSTEB(_listSpacingLeftRight,
            _listSpacingTop, _listSpacingLeftRight, _listSpacingBottom),
        itemBuilder: (context, index) {
          UnitValueModel item = widget.convertedItems[index];
          return BlocBuilder<UnitsConversionBloc, UnitsConversionState>(
              buildWhen: (prev, next) {
            return prev != next &&
                next is UnitConverted &&
                next.unitValue.unit.id == item.unit.id;
          }, builder: (_, unitConverted) {
            return ConvertouchUnitValueListItem(
                unitConverted is UnitConverted ? unitConverted.unitValue : item,
                conversionUnitIds: _conversionUnitIds,
              onTap: () {
                BlocProvider.of<UnitsMenuBloc>(context).add(FetchUnits(
                    unitGroupId: widget.unitGroup.id,
                    navigationAction: NavigationAction.push));
              },
            );
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
        itemCount: widget.convertedItems.length);
  }
}
