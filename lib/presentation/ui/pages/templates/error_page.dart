import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchErrorPage<B extends ConvertouchBloc,
    S extends ConvertouchState> extends StatelessWidget {
  final String pageTitle;
  final ConvertouchErrorState errorState;
  final S lastSuccessfulState;

  const ConvertouchErrorPage({
    this.pageTitle = "Something Went Wrong...",
    required this.errorState,
    required this.lastSuccessfulState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      ConvertouchScaffoldColor scaffoldColor = scaffoldColors[appState.theme]!;

      return ConvertouchPage(
        appState: appState,
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
                    color: scaffoldColor.regular.appBarFontColor,
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
                      color: scaffoldColor.regular.appBarColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      errorState.exception.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: scaffoldColor.regular.appBarFontColor,
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
                      BlocProvider.of<B>(context).add(
                        ShowState<S>(
                          state: lastSuccessfulState,
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: scaffoldColor.regular.appBarFontColor,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'Go Back',
                        style: TextStyle(
                          color: scaffoldColor.regular.appBarFontColor,
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
