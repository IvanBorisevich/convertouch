import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/presentation/bloc/bloc_observer.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_param_sets_page/conversion_param_sets_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_param_sets_page/single_param_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/single_group_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/scaffold.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/style/color/colors_dark.dart';
import 'package:convertouch/presentation/ui/style/color/colors_light.dart';
import 'package:convertouch/presentation/ui/widgets/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = ConvertouchBlocObserver();
  logger.d("Before dependencies initialization");
  await di.init();
  logger.d("Dependencies initialization finished");
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
              const GetAppSettingsInit(),
            ),
        ),
        BlocProvider(
          create: (context) => di.locator<NavigationBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<ItemsSelectionBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<ItemsSelectionBlocForUnitDetails>(),
        ),
        BlocProvider(
          create: (context) => di.locator<ConversionBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitGroupsBloc>()
            ..add(
              const FetchItems<UnitGroupsFetchParams>(),
            ),
        ),
        BlocProvider(
          create: (context) => di.locator<SingleGroupBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitGroupsBlocForUnitDetails>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitsBloc>(),
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
        BlocProvider(
          create: (context) => di.locator<ConversionParamSetsBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<SingleParamBloc>(),
        ),
      ],
      child: DismissKeyboard(
        child: appBlocBuilder(
          builderFunc: (appState) {
            // SystemChrome.setSystemUIOverlayStyle(
            //   buildSystemUiOverlayStyle(
            //     context: context,
            //     theme: appState.theme,
            //   ),
            // );

            return MaterialApp(
              title: appName,
              themeAnimationDuration: Duration.zero,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                  backgroundColor:
                      pageColorSchemeLight.appBar.background.regular,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: pageColorSchemeLight.bottomBar.background.regular,
                ),
                fontFamily: quicksandFontFamily,
                brightness: Brightness.light,
                splashColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              darkTheme: ThemeData(
                appBarTheme: AppBarTheme(
                  backgroundColor:
                      pageColorSchemeDark.appBar.background.regular,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: pageColorSchemeDark.bottomBar.background.regular,
                ),
                fontFamily: quicksandFontFamily,
                brightness: Brightness.dark,
                splashColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              themeMode: appState.theme == ConvertouchUITheme.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: AnnotatedRegion(
                value: buildSystemUiOverlayStyle(
                  context: context,
                  theme: appState.theme,
                ),
                child: const ConvertouchScaffold(),
              ),
            );
          },
        ),
      ),
    );
  }
}

SystemUiOverlayStyle buildSystemUiOverlayStyle({
  required BuildContext context,
  required ConvertouchUITheme theme,
  bool dialogOpened = false,
}) {
  final statusUpBarColor = pageColors[theme]!.appBar.background.regular;
  final systemBottomNavbarColor =
      pageColors[theme]!.bottomBar.background.regular;

  Brightness iconBrightness =
      theme == ConvertouchUITheme.dark ? Brightness.light : Brightness.dark;

  return SystemUiOverlayStyle(
    statusBarColor: statusUpBarColor,
    statusBarIconBrightness: iconBrightness,
    systemNavigationBarColor: systemBottomNavbarColor,
    systemNavigationBarIconBrightness: iconBrightness,
    systemNavigationBarDividerColor: Colors.transparent,
  );
}
