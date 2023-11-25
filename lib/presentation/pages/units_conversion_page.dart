import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/pages/abstract_page.dart';
import 'package:convertouch/presentation/pages/items_view/conversion_items_view.dart';
import 'package:convertouch/presentation/pages/items_view/item/menu_item.dart';
import 'package:convertouch/presentation/pages/scaffold/app_bar.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:convertouch/presentation/pages/style/model/color.dart';
import 'package:convertouch/presentation/pages/style/model/color_variation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsConversionPage extends ConvertouchPage {
  const ConvertouchUnitsConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return unitsConversionBloc((pageState) {
      return Column(
        children: [
          Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            padding: const EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
            child: ConvertouchMenuItem(
              item: pageState.unitGroupInConversion,
              color: appBarUnitGroupItemColor[pageState.theme]!,
              onTap: () {
                BlocProvider.of<UnitGroupsBloc>(context).add(
                  FetchUnitGroupsForConversion(
                    unitGroupInConversion: pageState.unitGroupInConversion,
                  ),
                );
              },
              theme: pageState.theme,
            ),
          ),
          Expanded(
            child: ConvertouchConversionItemsView(
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
                BlocProvider.of<UnitsConversionBloc>(context).add(
                  InitializeConversion(
                    sourceConversionItem: UnitValueModel(
                      unit: item.unit,
                      value: double.tryParse(value),
                    ),
                    unitsInConversion: pageState.conversionItems
                        .map((item) => item.unit)
                        .toList(),
                    unitGroupInConversion: pageState.unitGroupInConversion,
                  ),
                );
              },
              onItemRemove: (item) {
                BlocProvider.of<UnitsConversionBloc>(context).add(
                  RemoveConversion(
                    unitIdBeingRemoved: item.unit.id!,
                    conversionItems: pageState.conversionItems,
                    unitGroupInConversion: pageState.unitGroupInConversion,
                  ),
                );
              },
              theme: pageState.theme,
            ),
          ),
        ],
      );
    });
  }

  @override
  void onStart(BuildContext context) {
    BlocProvider.of<UnitsConversionBloc>(context).add(
      // TODO: support last session params retrieval
      const InitializeConversion(),
    );
  }

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) {
    return ConvertouchAppBar(
      content: unitsConversionBloc((pageState) {
        return buildAppBarForState(context, pageState);
      }),);
  }

  @override
  Widget buildFloatingActionButton(BuildContext context) {
    return unitsConversionBloc((pageState) {
      ConvertouchScaffoldColor commonColor = scaffoldColor[pageState.theme]!;
      FloatingButtonColorVariation removalButtonColor = removalFloatingButtonColor[pageState.theme]!;

      return Visibility(
        visible: pageState.floatingButtonVisible,
        child: SizedBox(
          height: 70,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              FittedBox(
                child: pageState.removalMode
                    ? floatingActionButton(
                  iconData: Icons.delete_outline_rounded,
                  onClick: () {
                    BlocProvider.of<UnitsBloc>(context).add(
                      pageState.unitGroupInConversion != null ?
                      FetchUnitsForConversion(
                        unitGroupInConversion: pageState.unitGroupInConversion,
                      ) : FetchUnitGroupsForConversion(
                        unitGroupInConversion: pageState.unitGroupInConversion,
                      ),
                    );
                  },
                  color: conversionPageFloatingButtonColor[pageState.theme]!,
                )
                    : floatingActionButton(
                  iconData: Icons.add,
                  onClick: () {
                    BlocProvider.of<UnitsBloc>(context).add(
                      pageState.unitGroupInConversion != null ?
                      FetchUnitsForConversion(
                        unitGroupInConversion: pageState.unitGroupInConversion,
                      ) : FetchUnitGroupsForConversion(
                        unitGroupInConversion: pageState.unitGroupInConversion,
                      ),
                    );
                  },
                  color: conversionPageFloatingButtonColor[pageState.theme]!,
                ),
              ),
              pageState.removalMode
                  ? itemsRemovalCounter(
                itemsCount: pageState.selectedItemIdsForRemoval.length,
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
