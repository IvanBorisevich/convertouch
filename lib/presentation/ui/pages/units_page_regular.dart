import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/pages/templates/units_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageRegular extends StatelessWidget {
  const ConvertouchUnitsPageRegular({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      PageColorScheme pageColorScheme = pageColors[appState.theme]!;
      ButtonColorSet floatingButtonColor =
          unitsPageFloatingButtonColors[appState.theme]!;
      ButtonColorSet removalButtonColor =
          removalFloatingButtonColors[appState.theme]!;

      return unitsBlocBuilder((pageState) {
        return ConvertouchUnitsPage(
          pageTitle: pageState.unitGroup.name,
          units: pageState.units,
          customLeadingIcon: pageState.removalMode
              ? leadingIcon(
                  icon: Icons.clear,
                  color: pageColorScheme.appBar.regular,
                  onClick: () {
                    BlocProvider.of<UnitsBloc>(context).add(
                      DisableUnitsRemovalMode(
                        unitGroup: pageState.unitGroup,
                      ),
                    );
                  },
                )
              : null,
          appBarRightWidgets: const [],
          onSearchStringChanged: (text) {
            BlocProvider.of<UnitsBloc>(context).add(
              FetchUnits(
                unitGroup: pageState.unitGroup,
                searchString: text,
              ),
            );
          },
          onSearchReset: () {
            BlocProvider.of<UnitsBloc>(context).add(
              FetchUnits(
                unitGroup: pageState.unitGroup,
                searchString: null,
              ),
            );
          },
          onUnitTap: (unit) {},
          onUnitTapForRemoval: (unit) {
            BlocProvider.of<UnitsBloc>(context).add(
              FetchUnitsToMarkForRemoval(
                unitGroup: pageState.unitGroup,
                searchString: pageState.searchString,
                newMarkedId: unit.id!,
                alreadyMarkedIds: pageState.markedIdsForRemoval,
              ),
            );
          },
          onUnitLongPress: (unit) {
            if (!pageState.removalMode) {
              BlocProvider.of<UnitsBloc>(context).add(
                FetchUnitsToMarkForRemoval(
                  unitGroup: pageState.unitGroup,
                  searchString: pageState.searchString,
                  newMarkedId: unit.id!,
                  alreadyMarkedIds: pageState.markedIdsForRemoval,
                ),
              );
            }
          },
          onUnitsRemove: null,
          itemIdsSelectedForRemoval: pageState.markedIdsForRemoval,
          removalModeAllowed: true,
          removalModeEnabled: pageState.removalMode,
          markedUnitsForConversionVisible: false,
          markedUnitIdsForConversion: null,
          selectedUnitVisible: false,
          selectedUnitId: null,
          floatingButton: pageState.removalMode
              ? ConvertouchFloatingActionButton.removal(
                  visible: pageState.markedIdsForRemoval.isNotEmpty,
                  extraLabelText:
                      pageState.markedIdsForRemoval.length.toString(),
                  background: removalButtonColor.background,
                  foreground: removalButtonColor.foreground,
                  border: pageColorScheme.page.background,
                  onClick: () {
                    BlocProvider.of<UnitsBloc>(context).add(
                      RemoveUnits(
                        ids: pageState.markedIdsForRemoval,
                        unitGroup: pageState.unitGroup,
                      ),
                    );
                  },
                )
              : ConvertouchFloatingActionButton.adding(
                  visible: !pageState.unitGroup.refreshable,
                  onClick: () {
                    BlocProvider.of<UnitCreationBloc>(context).add(
                      PrepareUnitCreation(
                        unitGroup: pageState.unitGroup,
                        baseUnit: null,
                      ),
                    );
                    Navigator.of(context).pushNamed(
                      PageName.unitCreationPage.name,
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
