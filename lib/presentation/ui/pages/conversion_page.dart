import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/input/conversion_events.dart';
import 'package:convertouch/domain/model/input/unit_groups_events.dart';
import 'package:convertouch/domain/model/input/units_events.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/ui/items_view/conversion_items_view.dart';
import 'package:convertouch/presentation/ui/items_view/item/menu_item.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchConversionPage extends StatelessWidget {
  const ConvertouchConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return conversionsBloc((pageState) {
      return appBloc((appState) {
        FloatingButtonColorVariation floatingButtonColor =
            conversionPageFloatingButtonColors[appState.theme]!;

        return ConvertouchPage(
          appState: appState,
          title: "Conversion",
          secondaryAppBar: pageState.unitGroup != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: ConvertouchMenuItem(
                    pageState.unitGroup!,
                    customColors: appBarUnitGroupItemColors[appState.theme]!,
                    onTap: () {
                      BlocProvider.of<UnitGroupsBlocForConversion>(context).add(
                        FetchUnitGroupsForChangeInConversion(
                          currentUnitGroupInConversion: pageState.unitGroup!,
                          searchString: null,
                        ),
                      );
                      Navigator.of(context)
                          .pushNamed(unitGroupsPageForConversion);
                    },
                    itemsViewMode: ItemsViewMode.list,
                    theme: appState.theme,
                  ),
                )
              : empty(),
          secondaryAppBarHeight: pageState.unitGroup != null ? 60 : 0,
          secondaryAppBarColor: Colors.transparent,
          body: ConvertouchConversionItemsView(
            pageState.conversionItems,
            onItemTap: (item) {},
            onItemValueChanged: (item, value) {
              BlocProvider.of<ConversionBloc>(context).add(
                BuildConversion(
                  sourceConversionItem: ConversionItemModel.fromStrValue(
                    unit: item.unit,
                    strValue: value,
                  ),
                  units: pageState.conversionItems
                      .map((item) => item.unit)
                      .toList(),
                  unitGroup: pageState.unitGroup,
                ),
              );
            },
            onItemRemove: (item) {
              BlocProvider.of<ConversionBloc>(context).add(
                RemoveConversionItem(
                  itemUnitId: item.unit.id!,
                  conversionItems: pageState.conversionItems,
                  unitGroupInConversion: pageState.unitGroup,
                ),
              );
            },
            theme: appState.theme,
          ),
          floatingActionButton: ConvertouchFloatingActionButton.adding(
            onClick: () {
              if (pageState.unitGroup == null) {
                BlocProvider.of<UnitGroupsBlocForConversion>(context).add(
                  const FetchUnitGroupsForFirstAddingToConversion(
                    searchString: null,
                  ),
                );
                Navigator.of(context).pushNamed(unitGroupsPageForConversion);
              } else {
                BlocProvider.of<UnitsBlocForConversion>(context).add(
                  FetchUnitsToMarkForConversion(
                    unitGroup: pageState.unitGroup!,
                    unitsAlreadyMarkedForConversion: pageState.conversionItems
                        .map((unitValue) => unitValue.unit)
                        .toList(),
                    currentSourceConversionItem: pageState.sourceConversionItem,
                    searchString: null,
                  ),
                );
                Navigator.of(context).pushNamed(unitsPageForConversion);
              }
            },
            background: floatingButtonColor.background,
            foreground: floatingButtonColor.foreground,
          ),
        );
      });
    });
  }
}
