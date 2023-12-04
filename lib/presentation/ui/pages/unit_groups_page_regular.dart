import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/unit_groups_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPageRegular extends StatelessWidget {
  const ConvertouchUnitGroupsPageRegular({super.key});

  @override
  Widget build(BuildContext context) {
    return appBloc((appState) {
      FloatingButtonColorVariation floatingButtonColor =
          unitGroupsPageFloatingButtonColors[appState.theme]!;

      return unitGroupsBloc((pageState) {
        return ConvertouchUnitGroupsPage(
          pageTitle: "Unit Groups",
          unitGroups: pageState.unitGroups,
          onUnitGroupTap: (item) {
            BlocProvider.of<UnitsBloc>(context).add(
              FetchUnits(unitGroup: item as UnitGroupModel),
            );
            Navigator.of(context).pushNamed(unitsPageRegular);
          },
          appBarRightWidgets: const [],
          selectedUnitGroupVisible: false,
          selectedUnitGroupId: null,
          removalModeAllowed: true,
          floatingButton: ConvertouchFloatingActionButton.adding(
            onClick: () {
              Navigator.of(context).pushNamed(unitGroupCreationPage);
            },
            visible: true,
            background: floatingButtonColor.background,
            foreground: floatingButtonColor.foreground,
          ),
        );
      });
    });
  }
}
