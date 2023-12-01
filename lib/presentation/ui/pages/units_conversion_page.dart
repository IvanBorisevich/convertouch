import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/ui/items_view/conversion_items_view.dart';
import 'package:convertouch/presentation/ui/items_view/item/menu_item.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitsConversionPage extends StatelessWidget {
  const ConvertouchUnitsConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return unitsConversionBloc((pageState) {
      return globalBloc((globalState) {
        FloatingButtonColorVariation floatingButtonColor =
            conversionPageFloatingButtonColors[globalState.theme]!;

        return ConvertouchPage(
          globalState: globalState,
          title: "Conversions",
          secondaryAppBar: pageState.unitGroup != null
              ? ConvertouchMenuItem(
                  pageState.unitGroup!,
                  color: appBarUnitGroupItemColors[globalState.theme]!,
                  onTap: () {
                    // BlocProvider.of<UnitGroupsBloc>(context).add(
                    //   FetchUnitGroupsForConversion(
                    //     unitGroupInConversion:
                    //         pageState.unitGroupInConversion,
                    //   ),
                    // );
                  },
                  theme: globalState.theme,
                )
              : empty(),
          secondaryAppBarColor: Colors.transparent,
          body: ConvertouchConversionItemsView(
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
            theme: globalState.theme,
          ),
          floatingActionButton: ConvertouchFloatingActionButton.adding(
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
            background: floatingButtonColor.background,
            foreground: floatingButtonColor.foreground,
          ),
        );
      });
    });
  }
}
