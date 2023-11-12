import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_states.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/pages/units_conversion_page.dart';
import 'package:convertouch/presentation/pages/unit_groups_page.dart';
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
