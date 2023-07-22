import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/view/scaffold/bloc_wrappers.dart';
import 'package:convertouch/view/units_conversion_page.dart';
import 'package:convertouch/view/unit_groups_page.dart';
import 'package:flutter/material.dart';

class ConvertouchHomePage extends StatelessWidget {
  const ConvertouchHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return unitsConversionBloc((conversionInitialized) {
      return conversionInitialized is ConversionInitialized &&
              conversionInitialized.conversionItems.isNotEmpty
          ? const ConvertouchUnitsConversionPage()
          : const ConvertouchUnitGroupsPage();
    });
  }
}
