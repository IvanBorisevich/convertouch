import 'dart:developer';

import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/presentation/bloc/base_bloc.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/pages/abstract_page.dart';
import 'package:convertouch/presentation/pages/items_view/conversion_items_view.dart';
import 'package:convertouch/presentation/pages/items_view/item/menu_item.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsConversionPage extends ConvertouchPage {
  const ConvertouchUnitsConversionPage({super.key});

  @override
  Widget buildBody(
    BuildContext context,
    ConvertouchCommonStateBuilt commonState,
  ) {
    return unitsConversionBloc((pageState) {
      return Column(
        children: [
          Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            padding: const EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
            child: pageState.unitGroup != null
                ? ConvertouchMenuItem(
                    pageState.unitGroup!,
                    color: appBarUnitGroupItemColors[commonState.theme]!,
                    onTap: () {
                      // BlocProvider.of<UnitGroupsBloc>(context).add(
                      //   FetchUnitGroupsForConversion(
                      //     unitGroupInConversion:
                      //         pageState.unitGroupInConversion,
                      //   ),
                      // );
                    },
                    theme: commonState.theme,
                  )
                : empty(),
          ),
          Expanded(
            child: ConvertouchConversionItemsView(
              pageState.conversionItems,
              onItemTap: (item) {
                // BlocProvider.of<UnitsBloc>(context).add(
                //   FetchUnits(
                //     unitGroupId: conversionInitialized.unitGroup!.id!,
                //     markedUnits: conversionInitialized.conversionItems
                //         .map((item) => item.unit)
                //         .toList(),
                //     inputValue: item.value,
                //     selectedUnit: item.unit,
                //     action: ConvertouchAction.fetchUnitsToSelectForConversion,
                //   ),
                // );
              },
              onItemValueChanged: (item, value) {
                // BlocProvider.of<UnitsConversionBloc>(context).add(
                // BuildConversion(
                //   sourceConversionItem: UnitValueModel(
                //     unit: item.unit,
                //     value: double.tryParse(value),
                //   ),
                //   unitsInConversion: pageState.conversionItems
                //       .map((item) => item.unit)
                //       .toList(),
                //   unitGroupInConversion: pageState.unitGroupInConversion,
                // ),
                // );
              },
              onItemRemove: (item) {
                // BlocProvider.of<UnitsConversionBloc>(context).add(
                //   RemoveConversionItem(
                //     itemUnitId: item.unit.id!,
                //     conversionItems: pageState.conversionItems,
                //     unitGroupInConversion: pageState.unitGroupInConversion,
                //   ),
                // );
              },
              theme: commonState.theme,
            ),
          ),
        ],
      );
    });
  }

  @override
  void onStart(BuildContext context) {
    log("On start loading unit conversions page");
    BlocProvider.of<UnitsConversionBloc>(context).add(
      // TODO: support last session params retrieval
      const BuildConversion(),
    );
  }

  @override
  Widget buildAppBar(
    BuildContext context,
    ConvertouchCommonStateBuilt commonState,
  ) {
    return buildAppBarForState(
      context,
      commonState,
      pageTitle: "Conversions",
    );
  }

  @override
  Widget buildFloatingActionButton(
    BuildContext context,
    ConvertouchCommonStateBuilt commonState,
  ) {
    return unitsConversionBloc((pageState) {
      return Visibility(
        visible: pageState.floatingButtonVisible,
        child: floatingActionButton(
          iconData: Icons.add,
          onClick: () {
            // BlocProvider.of<UnitsBloc>(context).add(
            //   pageState.unitGroupInConversion != null
            //       ? FetchUnitsForConversion(
            //           unitGroupInConversion: pageState.unitGroupInConversion,
            //         )
            //       : FetchUnitGroupsForConversion(
            //           unitGroupInConversion: pageState.unitGroupInConversion,
            //         ),
            // );
          },
          color: conversionPageFloatingButtonColors[commonState.theme]!,
        ),
      );
    });
  }
}
