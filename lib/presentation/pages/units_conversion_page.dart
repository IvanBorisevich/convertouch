import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/app/app_states.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/units/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units/units_events.dart';
import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_events.dart';
import 'package:convertouch/presentation/pages/abstract_page.dart';
import 'package:convertouch/presentation/pages/items_view/conversion_items_view.dart';
import 'package:convertouch/presentation/pages/items_view/item/menu_item.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc_wrappers.dart';

class ConvertouchUnitsConversionPage extends ConvertouchPage {
  const ConvertouchUnitsConversionPage({super.key});

  @override
  Widget buildBody(BuildContext context, AppStateChanged appState) {
    return unitsConversionBloc((conversionInitialized) {
      return Column(
        children: [
          Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            padding: const EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
            child: ConvertouchMenuItem(
              item: conversionInitialized.unitGroup,
              color: appBarUnitGroupItemColor[appState.theme]!,
              onTap: () {
                BlocProvider.of<UnitGroupsBloc>(context).add(
                  FetchUnitGroups(
                    selectedUnitGroupId: conversionInitialized.unitGroup != null
                        ? conversionInitialized.unitGroup!.id!
                        : -1,
                    markedUnits: conversionInitialized.conversionItems
                        .map((item) => item.unit)
                        .toList(),
                    action:
                        ConvertouchAction.fetchUnitGroupsToSelectForConversion,
                  ),
                );
              },
              theme: appState.theme,
            ),
          ),
          Expanded(
            child: ConvertouchConversionItemsView(
              conversionInitialized.conversionItems,
              onItemTap: (item) {
                BlocProvider.of<UnitsBloc>(context).add(
                  FetchUnits(
                    unitGroupId: conversionInitialized.unitGroup!.id!,
                    markedUnits: conversionInitialized.conversionItems
                        .map((item) => item.unit)
                        .toList(),
                    inputValue: item.value,
                    selectedUnit: item.unit,
                    action: ConvertouchAction.fetchUnitsToSelectForConversion,
                  ),
                );
              },
              onItemValueChanged: (item, value) {
                BlocProvider.of<UnitsConversionBloc>(context).add(
                  InitializeConversion(
                    inputValue: double.tryParse(value),
                    inputUnit: item.unit,
                    conversionUnits: conversionInitialized.conversionItems
                        .map((item) => item.unit)
                        .toList(),
                    unitGroup: conversionInitialized.unitGroup,
                  ),
                );
              },
              onItemRemove: (item) {
                BlocProvider.of<UnitsConversionBloc>(context).add(
                  RemoveConversion(
                    unitValueModel: item,
                    currentConversionItems:
                        conversionInitialized.conversionItems,
                    unitGroup: conversionInitialized.unitGroup!,
                  ),
                );
              },
              theme: appState.theme,
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget buildButtonToAdd(BuildContext context, AppStateChanged appState) {
    return unitsConversionBloc((conversionInitialized) {
      return floatingActionButton(
        iconData: Icons.add,
        onClick: conversionInitialized.unitGroup != null ? () {
          BlocProvider.of<UnitsBloc>(context).add(
            FetchUnits(
              unitGroupId: conversionInitialized.unitGroup!.id!,
              markedUnits: conversionInitialized.conversionItems
                  .map((item) => item.unit)
                  .toList(),
              inputValue: conversionInitialized.sourceUnitValue,
              action: ConvertouchAction.fetchUnitsToStartMark,
            ),
          );
        } : null,
        color: conversionPageFloatingButtonColor[appState.theme]!,
      );
    });
  }

  @override
  void onStart(BuildContext context, AppStateChanged appState) {
    BlocProvider.of<UnitsConversionBloc>(context).add(
      InitializeConversion(

      ),
    );
  }
}
