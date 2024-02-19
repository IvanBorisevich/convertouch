import 'dart:developer';

import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_observer.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_unit_details.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_unit_details.dart';
import 'package:convertouch/presentation/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

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
        BlocProvider(
          create: (context) => di.locator<AppBloc>()
            ..add(
              const GetAppSettings(),
            ),
        ),
        BlocProvider(
          create: (context) => di.locator<NavigationBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<ConversionBloc>()
            ..add(
              const GetLastSavedConversion(),
            ),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitGroupsBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitGroupsBlocForConversion>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitGroupsBlocForUnitDetails>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitsBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitsBlocForConversion>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitsBlocForUnitDetails>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitDetailsBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitGroupDetailsBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<RefreshingJobsBloc>(),
        ),
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
