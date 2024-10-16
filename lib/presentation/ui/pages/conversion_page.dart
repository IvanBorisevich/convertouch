import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/conversion_items_view.dart';
import 'package:convertouch/presentation/ui/widgets/refresh_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchConversionPage extends StatelessWidget {
  const ConvertouchConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final unitsBloc = BlocProvider.of<UnitsBlocForConversion>(context);
    final unitsSelectionBloc =
        BlocProvider.of<ItemsSelectionBlocForConversion>(context);
    final conversionBloc = BlocProvider.of<ConversionBloc>(context);
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return appBlocBuilder(
      builderFunc: (appState) {
        ConvertouchColorScheme floatingButtonColor =
            conversionPageFloatingButtonColors[appState.theme]!;

        return conversionBlocBuilder(
          builderFunc: (pageState) {
            final conversion = pageState.conversion;

            Widget addingButton() {
              return ConvertouchFloatingActionButton.adding(
                onClick: () {
                  unitsBloc.add(
                    FetchUnits(
                      unitGroup: conversion.unitGroup,
                    ),
                  );
                  unitsSelectionBloc.add(
                    StartItemsMarking(
                      previouslyMarkedIds: conversion.targetConversionItems
                          .map((unitValue) => unitValue.unit.id)
                          .toList(),
                      markedItemsMinNumForSelection: 2,
                    ),
                  );
                  navigationBloc.add(
                    const NavigateToPage(
                      pageName: PageName.unitsPageForConversion,
                    ),
                  );
                },
                colorScheme: floatingButtonColor,
              );
            }

            return ConvertouchPage(
              title: pageState.conversion.unitGroup.name,
              body: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ConvertouchConversionItemsView(
                  conversion.targetConversionItems,
                  valueType: conversion.unitGroup.valueType,
                  onUnitItemTap: (item) {
                    unitsBloc.add(
                      FetchUnits(
                        unitGroup: conversion.unitGroup,
                      ),
                    );

                    unitsSelectionBloc.add(
                      StartItemSelection(
                        previouslySelectedId: item.unit.id,
                        excludedIds: conversion.targetConversionItems
                            .map((e) => e.unit.id)
                            .whereNot((id) => id == item.unit.id)
                            .toList(),
                      ),
                    );

                    navigationBloc.add(
                      const NavigateToPage(
                        pageName: PageName.unitsPageForConversion,
                      ),
                    );
                  },
                  onTextValueChanged: (item, value) {
                    conversionBloc.add(
                      EditConversionItemValue(
                        newValue: value,
                        unitId: item.unit.id,
                      ),
                    );
                  },
                  onItemRemoveTap: (item) {
                    conversionBloc.add(
                      RemoveConversionItems(
                        unitIds: [item.unit.id],
                      ),
                    );
                  },
                  noItemsView: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "No Conversion Items Added",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: unitPageEmptyViewColor[appState.theme]!
                                  .foreground
                                  .regular,
                            ),
                          ),
                        ),
                        addingButton(),
                      ],
                    ),
                  ),
                  theme: appState.theme,
                ),
              ),
              floatingActionButton: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  const ConvertouchRefreshFloatingButton(),
                  conversion.targetConversionItems.isNotEmpty
                      ? addingButton()
                      : empty(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
