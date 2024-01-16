import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/units_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageForConversion extends StatelessWidget {
  const ConvertouchUnitsPageForConversion({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      ButtonColorVariation floatingButtonColor =
          unitsPageFloatingButtonColors[appState.theme]!;

      return unitsBlocBuilderForConversion((pageState) {
        return unitGroupsChangeBlocListenerWrap(
          handler: (unitGroupsStateChange) {
            if (unitGroupsStateChange.removedIds
                .contains(pageState.unitGroup.id)) {
              Navigator.of(context).pop();
            }
          },
          child: unitsChangeBlocListenerWrap(
            handler: (unitsStateChange) {
              BlocProvider.of<UnitsBlocForConversion>(context).add(
                FetchUnitsToMarkForConversion(
                  unitGroup: pageState.unitGroup,
                  unitsAlreadyMarkedForConversion:
                      pageState.unitsMarkedForConversion,
                  searchString: pageState.searchString,
                ),
              );
            },
            child: ConvertouchUnitsPage(
              pageTitle: 'Add units to conversion',
              customLeadingIcon: null,
              units: pageState.units,
              onSearchStringChanged: (text) {
                BlocProvider.of<UnitsBlocForConversion>(context).add(
                  FetchUnitsToMarkForConversion(
                    unitGroup: pageState.unitGroup,
                    unitsAlreadyMarkedForConversion:
                        pageState.unitsMarkedForConversion,
                    searchString: text,
                  ),
                );
              },
              onSearchReset: () {
                BlocProvider.of<UnitsBlocForConversion>(context).add(
                  FetchUnitsToMarkForConversion(
                    unitGroup: pageState.unitGroup,
                    unitsAlreadyMarkedForConversion:
                        pageState.unitsMarkedForConversion,
                    searchString: null,
                  ),
                );
              },
              onUnitTap: (unit) {
                BlocProvider.of<UnitsBlocForConversion>(context).add(
                  FetchUnitsToMarkForConversion(
                    unitGroup: pageState.unitGroup,
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
              markedUnitIdsForConversion: pageState.unitIdsMarkedForConversion,
              selectedUnitVisible: false,
              selectedUnitId: null,
              floatingButton: ConvertouchFloatingActionButton(
                icon: Icons.check_outlined,
                visible: pageState.allowUnitsToBeAddedToConversion,
                onClick: () {
                  BlocProvider.of<ConversionBloc>(context).add(
                    BuildConversion(
                      conversionParams: InputConversionModel(
                        unitGroup: pageState.unitGroup,
                        sourceConversionItem:
                            pageState.currentSourceConversionItem,
                        targetUnits: pageState.unitsMarkedForConversion,
                      ),
                    ),
                  );
                  Navigator.of(context).popUntil(
                    (route) => route.isFirst,
                  );
                },
                background: floatingButtonColor.background,
                foreground: floatingButtonColor.foreground,
              ),
            ),
          ),
        );
      });
    });
  }
}
