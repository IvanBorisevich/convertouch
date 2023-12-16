import 'package:convertouch/domain/model/input/units_conversion_events.dart';
import 'package:convertouch/domain/model/input/units_events.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presentation/ui/pages/templates/units_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageForConversion extends StatelessWidget {
  const ConvertouchUnitsPageForConversion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBloc((appState) {
      FloatingButtonColorVariation floatingButtonColor =
          unitsPageFloatingButtonColors[appState.theme]!;

      return unitsBlocForConversion((pageState) {
        bool allowUnitsToBeAddedToConversion =
            pageState.allowUnitsToBeAddedToConversion;
        List<int>? markedUnitIds = pageState.unitIdsMarkedForConversion;
        List<UnitModel>? markedUnits = pageState.unitsMarkedForConversion;
        ConversionItemModel? sourceConversionItem =
            pageState.currentSourceConversionItem;

        return ConvertouchUnitsPage(
          pageTitle: 'Add units to conversion',
          units: pageState.units,
          onSearchStringChanged: (text) {
            BlocProvider.of<UnitsBlocForConversion>(context).add(
              FetchUnitsToMarkForConversion(
                unitGroup: pageState.unitGroup!,
                unitsAlreadyMarkedForConversion:
                    pageState.unitsMarkedForConversion,
                searchString: text,
              ),
            );
          },
          onSearchReset: () {
            BlocProvider.of<UnitsBlocForConversion>(context).add(
              FetchUnitsToMarkForConversion(
                unitGroup: pageState.unitGroup!,
                unitsAlreadyMarkedForConversion:
                    pageState.unitsMarkedForConversion,
                searchString: null,
              ),
            );
          },
          onUnitTap: (unit) {
            BlocProvider.of<UnitsBlocForConversion>(context).add(
              FetchUnitsToMarkForConversion(
                unitGroup: pageState.unitGroup!,
                unitsAlreadyMarkedForConversion:
                    pageState.unitsMarkedForConversion,
                unitNewlyMarkedForConversion: unit as UnitModel,
                currentSourceConversionItem:
                    pageState.currentSourceConversionItem,
                searchString: pageState.searchString,
              ),
            );
          },
          onUnitTapForRemoval: null,
          onUnitLongPress: null,
          onUnitsRemove: null,
          itemIdsSelectedForRemoval: const [],
          removalModeAllowed: false,
          removalModeEnabled: false,
          appBarRightWidgets: const [],
          markedUnitsForConversionVisible: true,
          markUnitsOnTap: true,
          markedUnitIdsForConversion: markedUnitIds,
          selectedUnitVisible: false,
          selectedUnitId: null,
          floatingButton: ConvertouchFloatingActionButton(
            icon: Icons.check_outlined,
            visible: allowUnitsToBeAddedToConversion,
            onClick: () {
              BlocProvider.of<UnitsConversionBloc>(context).add(
                BuildConversion(
                  unitGroup: pageState.unitGroup,
                  units: markedUnits,
                  sourceConversionItem: sourceConversionItem,
                ),
              );
              Navigator.of(context).popUntil(
                (route) => route.isFirst,
              );
            },
            background: floatingButtonColor.background,
            foreground: floatingButtonColor.foreground,
          ),
        );
      });
    });
  }
}
