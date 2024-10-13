import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/unit_groups_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversionGroupsPage extends StatelessWidget {
  const ConversionGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final unitGroupsBloc =
        BlocProvider.of<UnitGroupsBlocForConversion>(context);
    final conversionBloc = BlocProvider.of<ConversionBloc>(context);
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return unitGroupsBlocBuilder(
      bloc: unitGroupsBloc,
      builderFunc: (pageState) {
        return ConvertouchUnitGroupsPage(
          pageTitle: 'Conversion Groups',
          searchBarPlaceholder: 'Search conversion groups...',
          customLeadingIcon: null,
          unitGroups: pageState.unitGroups,
          onSearchStringChanged: (text) {
            unitGroupsBloc.add(
              FetchUnitGroups(
                searchString: text,
              ),
            );
          },
          onSearchReset: () {
            unitGroupsBloc.add(
              const FetchUnitGroups(),
            );
          },
          onUnitGroupTap: (unitGroup) {
            conversionBloc.add(
              GetConversion(unitGroup: unitGroup),
            );
            navigationBloc.add(
              const NavigateToPage(pageName: PageName.conversionPage),
            );
          },
          onUnitGroupTapForRemoval: null,
          onUnitGroupLongPress: null,
          onUnitGroupsRemove: null,
          itemIdsSelectedForRemoval: const [],
          appBarRightWidgets: const [],
          selectedUnitGroupVisible: false,
          selectedUnitGroupId: null,
          disabledUnitGroupIds: null,
          removalModeEnabled: false,
          removalModeAllowed: false,
          editableUnitGroupsVisible: false,
          floatingButton: null,
        );
      },
    );
  }
}
