import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/view/scaffold/bloc.dart';
import 'package:convertouch/view/units_conversion_page.dart';
import 'package:convertouch/view/unit_groups_menu_page.dart';
import 'package:flutter/material.dart';

class ConvertouchHomePage extends StatelessWidget {
  const ConvertouchHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return wrapIntoUnitsConversionBloc((conversionInitialized) {
      return conversionInitialized is ConversionInitialized &&
              conversionInitialized.convertedUnitValues.isNotEmpty
          ? const ConvertouchUnitsConversionPage()
          : const ConvertouchUnitGroupsMenuPage();
    });
  }
}
