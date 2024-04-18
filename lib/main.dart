import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_observer.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
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
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_unit_details.dart';
import 'package:convertouch/presentation/scaffold.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logger/logger.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final logger = Logger(
  printer: PrettyPrinter(
    printTime: true,
  ),
);

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Bloc.observer = ConvertouchBlocObserver();
  logger.d("Before dependencies initialization");
  await di.init();
  logger.d("Dependencies initialization finished");
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
          create: (context) => di.locator<UnitGroupsBloc>()
            ..add(
              const FetchUnitGroups(searchString: null),
            ),
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
      child: DismissKeyboard(
        child: appBlocBuilder((appState) {
          final statusBarColor =
              pageColors[appState.theme]!.appBar.background.regular;
          final systemNavbarColor =
              pageColors[appState.theme]!.bottomBar.background.regular;
          Brightness iconBrightness = appState.theme == ConvertouchUITheme.dark
              ? Brightness.light
              : Brightness.dark;

          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: statusBarColor,
              statusBarIconBrightness: iconBrightness,
              systemNavigationBarColor: systemNavbarColor,
              systemNavigationBarIconBrightness: iconBrightness,
              systemNavigationBarDividerColor: systemNavbarColor,
            ),
          );

          return MaterialApp(
            title: appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: quicksandFontFamily,
            ),
            home: const ConvertouchScaffold(),
          );
        }),
      ),
    );
  }
}
