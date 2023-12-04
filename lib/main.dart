import 'dart:developer';

import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/bloc_observer.dart';
import 'package:convertouch/presentation/bloc/menu_items_view/menu_items_view_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = ConvertouchBlocObserver();
  await di.init();
  log("Dependencies initialization finished");
  runApp(const ConvertouchApp());
}

class ConvertouchApp extends StatelessWidget {
  const ConvertouchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.locator<ConvertouchAppBloc>()),
        BlocProvider(create: (context) => di.locator<UnitGroupsViewModeBloc>()),
        BlocProvider(create: (context) => di.locator<UnitsViewModeBloc>()),
        BlocProvider(create: (context) => di.locator<UnitsConversionBloc>()),
        BlocProvider(
          create: (context) =>
              di.locator<UnitGroupsBloc>()..add(const FetchUnitGroups()),
        ),
        BlocProvider(
            create: (context) => di.locator<UnitGroupsBlocForConversion>()),
        BlocProvider(create: (context) => di.locator<UnitsBloc>()),
        BlocProvider(create: (context) => di.locator<UnitsBlocForConversion>()),
        // BlocProvider(create: (context) => di.locator<UnitCreationBloc>()),
        // BlocProvider(create: (context) => di.locator<UnitGroupCreationBloc>()),
      ],
      child: MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: quicksandFontFamily),
        home: const ConvertouchScaffold(),
      ),
    );
  }
}
