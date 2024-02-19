import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchErrorPage extends StatelessWidget {
  final String pageTitle;
  final ConvertouchException error;

  const ConvertouchErrorPage({
    this.pageTitle = "Something Went Wrong...",
    required this.error,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      PageColorScheme pageColorScheme = pageColors[appState.theme]!;

      return ConvertouchPage(
        title: pageTitle,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Center(
                  child: Icon(
                    Icons.troubleshoot_outlined,
                    size: 140,
                    color: pageColorScheme.page.foreground,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: pageColorScheme.page.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      error.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: pageColorScheme.page.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<NavigationBloc>(context).add(
                        const NavigateBack(),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: pageColorScheme.page.foreground,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'Go Back',
                        style: TextStyle(
                          color: pageColorScheme.page.foreground,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
