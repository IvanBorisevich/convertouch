import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/units_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageRegular extends StatelessWidget {
  const ConvertouchUnitsPageRegular({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      PageColorScheme pageColorScheme = pageColors[appState.theme]!;
      ConvertouchColorScheme floatingButtonColor =
          unitsPageFloatingButtonColors[appState.theme]!;
      ConvertouchColorScheme removalButtonColor =
          removalFloatingButtonColors[appState.theme]!;

      return unitsBlocBuilder((pageState) {
        return ConvertouchUnitsPage(
          pageTitle: pageState.unitGroup.name,
          units: pageState.units,
          customLeadingIcon: pageState.removalMode
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: pageColorScheme.appBar.foreground.regular,
                  ),
                  onPressed: () {
                    BlocProvider.of<UnitsBloc>(context).add(
                      DisableUnitsRemovalMode(
                        unitGroup: pageState.unitGroup,
                      ),
                    );
                  },
                )
              : null,
          appBarRightWidgets: [
            IconButton(
              onPressed: () {
                BlocProvider.of<UnitGroupDetailsBloc>(context).add(
                  GetExistingUnitGroupDetails(
                    unitGroup: pageState.unitGroup,
                  ),
                );
              },
              icon: Icon(
                pageState.unitGroup.oob
                    ? Icons.info_outline_rounded
                    : Icons.edit_outlined,
                color: pageColorScheme.appBar.foreground.regular,
              ),
            )
          ],
          onSearchStringChanged: (text) {
            BlocProvider.of<UnitsBloc>(context).add(
              FetchUnitsOnSearchStringChange(
                unitGroup: pageState.unitGroup,
                searchString: text,
              ),
            );
          },
          onSearchReset: () {
            BlocProvider.of<UnitsBloc>(context).add(
              FetchUnitsOnSearchStringChange(
                unitGroup: pageState.unitGroup,
                searchString: null,
              ),
            );
          },
          onUnitTap: (unit) {
            BlocProvider.of<UnitDetailsBloc>(context).add(
              GetExistingUnitDetails(
                unit: unit as UnitModel,
                unitGroup: pageState.unitGroup,
              ),
            );
          },
          onUnitTapForRemoval: (unit) {
            BlocProvider.of<UnitsBloc>(context).add(
              FetchUnitsToMarkForRemoval(
                unitGroup: pageState.unitGroup,
                searchString: pageState.searchString,
                newMarkedId: unit.id,
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
                  newMarkedId: unit.id,
                  alreadyMarkedIds: pageState.markedIdsForRemoval,
                ),
              );
            }
          },
          onUnitsRemove: null,
          itemIdsSelectedForRemoval: pageState.markedIdsForRemoval,
          removalModeAllowed: true,
          removalModeEnabled: pageState.removalMode,
          editableUnitsVisible: true,
          markedUnitsForConversionVisible: false,
          markedUnitIdsForConversion: null,
          selectedUnitVisible: false,
          selectedUnitId: null,
          disabledUnitId: null,
          floatingButton: pageState.removalMode
              ? ConvertouchFloatingActionButton.removal(
                  visible: pageState.markedIdsForRemoval.isNotEmpty,
                  extraLabelText:
                      pageState.markedIdsForRemoval.length.toString(),
                  colorScheme: removalButtonColor,
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
                  visible: !pageState.unitGroup.refreshable &&
                      pageState.unitGroup.conversionType !=
                          ConversionType.formula,
                  onClick: () {
                    BlocProvider.of<UnitDetailsBloc>(context).add(
                      GetNewUnitDetails(
                        unitGroup: pageState.unitGroup,
                      ),
                    );
                  },
                  colorScheme: floatingButtonColor,
                ),
        );
      });
    });
  }
}
