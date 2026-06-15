import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/bloc/bloc_observer.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/scaffold.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/utils/common_utils.dart';
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
      ],
      child: DismissKeyboard(
        child: appBlocBuilder(
          builderFunc: (appState) {
            return MaterialApp(
              title: appName,
              themeAnimationDuration: Duration.zero,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                  backgroundColor: appColors[ConvertouchUITheme.light]
                      .page
                      .appBar
                      .background
                      .regular,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: appColors[ConvertouchUITheme.light]
                      .page
                      .bottomBar
                      .background
                      .regular,
                ),
                fontFamily: quicksandFontFamily,
                brightness: Brightness.light,
                splashColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              darkTheme: ThemeData(
                appBarTheme: AppBarTheme(
                  backgroundColor: appColors[ConvertouchUITheme.dark]
                      .page
                      .appBar
                      .background
                      .regular,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: appColors[ConvertouchUITheme.dark]
                      .page
                      .bottomBar
                      .background
                      .regular,
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
