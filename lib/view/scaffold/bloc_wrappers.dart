import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/presenter/bloc/items_menu_view_bloc.dart';
import 'package:convertouch/presenter/bloc/unit_groups_menu_bloc.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/states/items_menu_view_state.dart';
import 'package:convertouch/presenter/states/unit_groups_menu_states.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/presenter/states/units_menu_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget wrapIntoUnitsMenuBloc(
    Widget Function(UnitsFetched unitsFetched) builderFunc) {
  return BlocBuilder<UnitsMenuBloc, UnitsMenuState>(
      buildWhen: (prev, next) {
        return prev != next && next is UnitsFetched;
      }, builder: (_, unitsFetched) {
        if (unitsFetched is UnitsFetched) {
          return builderFunc.call(unitsFetched);
        } else {
          return const SizedBox(width: 0, height: 0);
        }
      });
}

Widget wrapIntoUnitsMenuBlocForItem(
    Widget Function(UnitsMenuState unitSelected) builderFunc) {
  return BlocBuilder<UnitsMenuBloc, UnitsMenuState>(
      buildWhen: (prev, next) {
        return prev != next && next is UnitSelected;
      }, builder: (_, unitSelected) {
        return builderFunc.call(unitSelected);
      });
}

Widget wrapIntoUnitGroupsMenuBloc(
    Widget Function(UnitGroupsFetched unitGroupsFetched) builderFunc) {
  return BlocBuilder<UnitGroupsMenuBloc, UnitGroupsMenuState>(
      buildWhen: (prev, next) {
        return prev != next && next is UnitGroupsFetched;
      }, builder: (_, unitGroupsFetched) {
        if (unitGroupsFetched is UnitGroupsFetched) {
          return builderFunc.call(unitGroupsFetched);
        } else {
          return const SizedBox(width: 0, height: 0);
        }
      });
}

Widget wrapIntoItemsMenuViewBloc(
    Widget Function(ItemsMenuViewState itemsMenuViewState) builderFunc) {
  return BlocBuilder<ItemsMenuViewBloc, ItemsMenuViewState>(
      builder: (_, itemsMenuViewState) {
        return builderFunc.call(itemsMenuViewState);
      });
}

Widget wrapIntoUnitsConversionBloc(
    Widget Function(UnitsConversionState conversionInitialized) builderFunc) {
  return BlocBuilder<UnitsConversionBloc, UnitsConversionState>(
      buildWhen: (prev, next) {
        return prev != next && next is ConversionInitialized;
      }, builder: (_, conversionInitialized) {
        return builderFunc.call(conversionInitialized);
      });
}

Widget wrapIntoUnitsConversionBlocForItem(UnitValueModel item,
    Widget Function(UnitValueModel item) builderFunc) {
  return BlocBuilder<UnitsConversionBloc, UnitsConversionState>(
    buildWhen: (prev, next) {
      return prev != next &&
        next is UnitConverted &&
        next.unitValue.unit.id == item.unit.id;
    }, builder: (_, unitConverted) {
      if (unitConverted is UnitConverted) {
        return builderFunc.call(unitConverted.unitValue);
      } else {
        return builderFunc.call(item);
      }
    });
}
