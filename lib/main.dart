import 'dart:developer';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/base_bloc.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';
import 'package:convertouch/presentation/bloc/bloc_observer.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_creation_page/unit_group_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/pages/home_page.dart';
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
        BlocProvider(create: (context) => di.locator<ConvertouchCommonBloc>()),
        BlocProvider(create: (context) => di.locator<UnitsConversionBloc>()),
        BlocProvider(create: (context) => di.locator<UnitGroupsBloc>()),
        BlocProvider(create: (context) => di.locator<UnitsBloc>()),
        // BlocProvider(create: (context) => di.locator<UnitCreationBloc>()),
        // BlocProvider(create: (context) => di.locator<UnitGroupCreationBloc>()),
      ],
      child: MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: quicksandFontFamily),
        home: const ConvertouchHomePage(),
      ),
    );
  }
}
