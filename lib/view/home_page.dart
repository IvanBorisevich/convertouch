import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/view/units_conversion_page.dart';
import 'package:convertouch/view/unit_groups_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchHomePage extends StatelessWidget {
  const ConvertouchHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitsConversionBloc, UnitsConversionState>(buildWhen: (prev, next) {
      return prev != next && next is ConversionInitialized;
    }, builder: (_, convertedUnitsState) {
      if (convertedUnitsState is ConversionInitialized &&
          convertedUnitsState.convertedUnitValues.isNotEmpty) {
        return const ConvertouchUnitsConversionPage();
      } else {
        return const ConvertouchUnitGroupsMenuPage();
      }
    });
  }
}
