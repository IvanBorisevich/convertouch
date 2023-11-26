import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_creation_page/unit_group_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/pages/abstract_page.dart';
import 'package:convertouch/presentation/pages/items_view/menu_items_view.dart';
import 'package:convertouch/presentation/pages/scaffold/navigation_service.dart';
import 'package:convertouch/presentation/pages/scaffold/search_bar.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:convertouch/presentation/pages/style/model/color.dart';
import 'package:convertouch/presentation/pages/style/model/color_variation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPage extends ConvertouchPage {
  const ConvertouchUnitGroupsPage({super.key});

  @override
  Widget buildBody(BuildContext context, ConvertouchCommonStateBuilt commonState,) {
    return unitGroupsBloc((pageState) {
      ScaffoldColorVariation scaffoldColor = scaffoldColors[commonState.theme]!.regular;
      FloatingButtonColorVariation color =
          unitGroupsPageFloatingButtonColors[commonState.theme]!;

      UnitGroupModel? selectedGroup;

      if (pageState is UnitGroupsFetchedForUnitCreation) {
        selectedGroup = pageState.unitGroupInUnitCreation;
      } else if (pageState is UnitGroupsFetchedForConversion) {
        selectedGroup = pageState.unitGroupInConversion;
      }

      return Column(
        children: [
          Container(
            height: 53,
            decoration: BoxDecoration(
              color: scaffoldColor.appBarColor,
            ),
            padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 7, 7),
            child: ConvertouchSearchBar(
              placeholder: "Search unit groups...",
              theme: commonState.theme,
              iconViewMode: ItemsViewMode.list, //pageState.iconViewMode!,
              pageViewMode: ItemsViewMode.grid,
            ),
          ),
          Expanded(
            child: ConvertouchMenuItemsView(
              pageState.unitGroups,
              selectedItemId: selectedGroup?.id,
              showSelectedItem: selectedGroup != null,
              removalModeAllowed: pageState.runtimeType == UnitGroupsFetched,
              onItemTap: (item) {
                // if (pageState is UnitGroupsFetchedForUnitCreation) {
                //   BlocProvider.of<UnitCreationBloc>(context).add(
                //     PrepareUnitCreation(
                //       unitGroup: item as UnitGroupModel,
                //     ),
                //   );
                // } else if (pageState is UnitGroupsFetchedForConversion) {
                // } else {
                //   BlocProvider.of<UnitsBloc>(context).add(
                //     FetchUnitsOfGroup(
                //       unitGroupId: item.id!,
                //     ),
                //   );
                // }
              },
              commonState: commonState,
            ),
          ),
        ],
      );
    });
  }

  @override
  void onStart(BuildContext context) {
    BlocProvider.of<UnitGroupsBloc>(context).add(
      // TODO: support last session params retrieval
      const FetchUnitGroups(),
    );
  }

  @override
  Widget buildAppBar(
      BuildContext context,
      ConvertouchCommonStateBuilt commonState,
      ) {
    return unitGroupsBloc((unitGroupsFetched) {
      return buildAppBarForState(
        context,
        commonState,
        pageTitle: "Unit Groups",
      );
    });
  }

  @override
  Widget buildFloatingActionButton(BuildContext context, ConvertouchCommonStateBuilt commonState,) {
    return unitGroupsBloc((pageState) {
      ConvertouchScaffoldColor commonColor = scaffoldColors[commonState.theme]!;
      FloatingButtonColorVariation removalButtonColor =
          removalFloatingButtonColors[commonState.theme]!;

      return Visibility(
        visible: pageState.floatingButtonVisible,
        child: SizedBox(
          height: 70,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              FittedBox(
                child: commonState.removalMode
                    ? floatingActionButton(
                        iconData: Icons.delete_outline_rounded,
                        onClick: () {},
                        color:
                            conversionPageFloatingButtonColors[commonState.theme]!,
                      )
                    : floatingActionButton(
                        iconData: Icons.add,
                        onClick: () {
                          // BlocProvider.of<UnitGroupsBloc>(context).add(
                          //   PrepareUnitGroupCreation(),
                          // );
                        },
                        color:
                            conversionPageFloatingButtonColors[commonState.theme]!,
                      ),
              ),
              commonState.removalMode
                  ? itemsRemovalCounter(
                      itemsCount: commonState.selectedItemIdsForRemoval.length,
                      backgroundColor: removalButtonColor.background,
                      foregroundColor: removalButtonColor.foreground,
                      borderColor: commonColor.regular.backgroundColor,
                    )
                  : empty(),
            ],
          ),
        ),
      );
    });
  }
}
